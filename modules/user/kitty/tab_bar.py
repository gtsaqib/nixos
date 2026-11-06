# ty: ignore[unresolved-import]
import math
import os
import termios
import time

from kitty import fast_data_types as fdt
from kitty.fast_data_types import Screen, add_timer, get_boss, get_options
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb
from kitty.utils import color_as_int

SEPARATOR = ""
SEPARATOR_LEFT = ""
DEFAULT_MODE_LABEL = "NORMAL"
MAX_PROGRAM_LEN = 20
REFRESH_SECONDS = 0.5

KEY_TIMEOUT = 2.0
MAX_KEYS = 32

MODE_COLOR = "color4"
PROGRAM_COLOR = "color2"
KEY_COLOR = "color1"
DARKEN = 0.65

MODS = ((4, "C"), (1, "S"), (2, "A"), (8, "Super"))
MODS_MASK = 0x0F
SPECIAL_KEYS = {
    getattr(fdt, f"GLFW_FKEY_{name}"): label
    for name, label in (
        ("ESCAPE", "Esc"),
        ("ENTER", "CR"),
        ("TAB", "Tab"),
        ("BACKSPACE", "BS"),
        ("INSERT", "Ins"),
        ("DELETE", "Del"),
        ("LEFT", "Left"),
        ("RIGHT", "Right"),
        ("UP", "Up"),
        ("DOWN", "Down"),
        ("PAGE_UP", "PgUp"),
        ("PAGE_DOWN", "PgDn"),
        ("HOME", "Home"),
        ("END", "End"),
    )
}
SPECIAL_KEYS.update({getattr(fdt, f"GLFW_FKEY_F{n}"): f"F{n}" for n in range(1, 13)})

_timer_id = None
_hooked = False
_left_width = 0
_keys = []
_last_key_at = 0.0


def _srgb_to_linear(value: int) -> float:
    c = value / 255
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4


def _linear_to_srgb(c: float) -> int:
    c = min(max(c, 0.0), 1.0)
    return round(
        (12.92 * c if c <= 0.0031308 else 1.055 * c ** (1 / 2.4) - 0.055) * 255
    )


def _to_oklch(rgb: int) -> tuple:
    """0xRRGGBB -> (lightness, chroma, hue in radians)."""
    r, g, b = (_srgb_to_linear((rgb >> shift) & 255) for shift in (16, 8, 0))
    l = (0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b) ** (1 / 3)
    m = (0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b) ** (1 / 3)
    s = (0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b) ** (1 / 3)
    lightness = 0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s
    a = 1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s
    b = 0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s
    return lightness, math.hypot(a, b), math.atan2(b, a)


def _from_oklch(lightness: float, chroma: float, hue: float) -> int:
    """(lightness, chroma, hue in radians) -> 0xRRGGBB, clamped to sRGB."""
    a, b = chroma * math.cos(hue), chroma * math.sin(hue)
    l = (lightness + 0.3963377774 * a + 0.2158037573 * b) ** 3
    m = (lightness - 0.1055613458 * a - 0.0638541728 * b) ** 3
    s = (lightness - 0.0894841775 * a - 1.2914855480 * b) ** 3
    linear = (
        4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s,
    )
    rgb = 0
    for c in linear:
        rgb = rgb << 8 | _linear_to_srgb(c)
    return rgb


def darken(rgb: int, amount: float = DARKEN) -> int:
    lightness, chroma, hue = _to_oklch(rgb)
    return _from_oklch(max(0.0, lightness * (1 - amount)), chroma, hue)


def _color(opts, name: str) -> int:
    return color_as_int(getattr(opts, name))


def _bar_bg(opts) -> int:
    return max(color_as_int(opts.background) - 1, 0)


def _put(screen: Screen, text: str, fg: int, bg: int, bold: bool = False) -> None:
    screen.cursor.fg = as_rgb(fg)
    screen.cursor.bg = as_rgb(bg)
    screen.cursor.bold = bold
    screen.draw(text)


def _block(screen: Screen, text: str, color: int, bold: bool = False) -> None:
    _put(screen, text, color, darken(color), bold)


def _key_text(ev) -> str:
    """'h', 'H', ' ' when typing; '<C-b>', '<S-Tab>', '<Del>' for the rest."""
    key = ev.key
    mods = ev.mods & MODS_MASK
    caps = bool(ev.mods & 0x40)

    name = SPECIAL_KEYS.get(key)
    if name is None:
        if key == 32:
            if not mods:
                return " "
            name = "Space"
        elif 32 < key < 0xE000:
            name = chr(key).lower()
        else:
            return ""

    if len(name) == 1 and not mods & 0x0E:
        if name.isalpha():
            return name.upper() if bool(mods & 1) != caps else name
        return (chr(ev.shifted_key) or name) if mods & 1 and ev.shifted_key else name

    prefix = "".join(f"{p}-" for bit, p in MODS if mods & bit)
    return f"<{prefix}{name}>"


def _typing_hidden(boss) -> bool:
    """Password prompt (sudo, ssh): the pty has echo off but is still line based."""
    window = boss.active_window
    fd = window.child.child_fd if window else None
    if fd is None:
        return False
    lflag = termios.tcgetattr(fd)[3]
    return not lflag & termios.ECHO and bool(lflag & termios.ICANON)


def _record_key(ev) -> None:
    global _last_key_at
    boss = get_boss()
    if ev.action == 0 or _typing_hidden(boss):
        return
    text = _key_text(ev)
    if not text:
        return
    _keys.append(text)
    del _keys[:-MAX_KEYS]
    _last_key_at = time.monotonic()
    boss.active_tab_manager.mark_tab_bar_dirty()


def _install_key_hook(boss) -> None:
    """See every key press by wrapping kitty's key dispatcher."""
    global _hooked
    if _hooked:
        return
    original = boss.dispatch_possible_special_key

    def hook(ev):
        try:
            _record_key(ev)
        except Exception:  # noqa: BLE001, S110
            pass
        return original(ev)

    boss.dispatch_possible_special_key = hook
    _hooked = True


def _visible_keys() -> str:
    global _keys
    if time.monotonic() - _last_key_at > KEY_TIMEOUT:
        _keys = []
    return "".join(_keys)


def _redraw_tab_bar(_timer_id) -> None:
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()


def _mode_label(boss) -> str:
    mappings = boss.mappings
    name = mappings.current_keyboard_mode_name
    if name == "__sequence__":
        keys = mappings.keyboard_mode_stack[-1].sequence_keys
        return "".join(_key_text(k) for k in keys) or "SEQUENCE"
    return name.upper() or DEFAULT_MODE_LABEL


def program_name(tab) -> str:
    window = tab.active_window if tab else None
    procs = window.child.foreground_processes if window else []
    cmdline = procs[0]["cmdline"] if procs else None
    return os.path.basename(cmdline[0]).lstrip("-") if cmdline else ""


def tab_cwd(boss, tab_data: TabBarData) -> str:
    tab = boss.tab_for_id(tab_data.tab_id)
    window = tab.active_window if tab else None
    return (window.cwd_of_child if window else None) or ""


def short_cwd(path: str, limit: int) -> str:
    if not path:
        return "?"
    home = os.path.expanduser("~")
    if path == home or path.startswith(home + os.sep):
        path = "~" + path[len(home) :]
    if len(path) > limit:
        path = "…" + path[-(max(limit, 2) - 1) :]
    return path


def _draw_left(screen: Screen, boss, tm, opts) -> None:
    global _left_width
    start = screen.cursor.x

    _block(screen, f" {_mode_label(boss)} ", _color(opts, MODE_COLOR), bold=True)

    prog = program_name(tm.active_tab) or "-"
    if len(prog) > MAX_PROGRAM_LEN:
        prog = prog[: MAX_PROGRAM_LEN - 1] + "…"
    _block(screen, f" {prog} ", _color(opts, PROGRAM_COLOR))

    _left_width = screen.cursor.x - start


def _draw_right(screen: Screen, opts, bar_bg: int) -> None:
    """Pressed keys at the right edge; the rest of the bar gets the bar color."""
    keys = _visible_keys()
    avail = screen.columns - screen.cursor.x - 3
    if not keys or avail < 2:
        _put(screen, " " * (screen.columns - screen.cursor.x), bar_bg, bar_bg)
        return

    if len(keys) > avail:
        keys = "…" + keys[-(avail - 1) :]
    text = f" {keys} "
    color = _color(opts, KEY_COLOR)
    gap = screen.columns - screen.cursor.x - len(text) - 1  # -1 for the arrow

    _put(screen, " " * gap, bar_bg, bar_bg)
    _put(screen, SEPARATOR_LEFT, darken(color), bar_bg)
    _block(screen, text, color)


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    _before: int,
    _max_title_length: int,
    index: int,
    is_last: bool,
    _extra_data: ExtraData,
) -> int:
    global _timer_id
    boss = get_boss()
    tm = boss.active_tab_manager
    if tm is None:
        return screen.cursor.x

    if _timer_id is None:
        _timer_id = add_timer(_redraw_tab_bar, REFRESH_SECONDS, True)
    _install_key_hook(boss)

    opts = get_options()
    bar_bg = _bar_bg(opts)

    if index == 1:
        _draw_left(screen, boss, tm, opts)

    overhead = len(str(index)) + 4
    budget = max(3, (screen.columns - _left_width) // max(1, len(tm.tabs)) - overhead)

    bg = draw_data.tab_bg(tab)
    cwd = short_cwd(tab_cwd(boss, tab), budget)
    _put(screen, f" {index} {cwd} ", draw_data.tab_fg(tab), bg, bold=tab.is_active)

    if is_last:
        next_bg = bar_bg
    else:
        next_tab = tm.tabs[index]
        next_bg = color_as_int(
            draw_data.active_bg if next_tab is tm.active_tab else draw_data.inactive_bg
        )
    _put(screen, SEPARATOR, bg, next_bg)

    screen.cursor.bold = False
    end = screen.cursor.x
    if is_last:
        _draw_right(screen, opts, bar_bg)
    return end
