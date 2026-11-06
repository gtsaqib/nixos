{ ... }:

{
  home.shellAliases.icat = "kitten icat";

  programs = {
    fish.interactiveShellInit = ''
      if set -q KITTY_WINDOW_ID
        bind \ck "kitty @ action clear_terminal last_command active" repaint
        # bind \cl "kitty @ action clear_terminal reset active" repaint
      end
    '';
    kitty = {
      enable = true;

      font = {
        name = "Maple Mono NF";
        size = 12;
      };

      settings = {
        background_opacity = 0.5;
        dynamic_background_opacity = true;
        inactive_text_alpha = -0.75;
        confirm_os_window_close = 0;
        allow_remote_control = "yes";
        listen_on = "unix:/tmp/kitty";
        disable_ligatures = "cursor";
        cursor_trail = 1;
        custom_shaders = "cursor-trail-motion-blur";
        strip_trailing_spaces = "always";
        enabled_layouts = "tall, fat, grid, horizontal, splits, stack, vertical";
        tab_bar_style = "custom";
        tab_bar_min_tabs = 1;
        active_tab_font_style = "none";
        clear_all_shortcuts = "yes";
      };

      extraConfig =
        let
          mod = "ctrl+shift";
          leader = "ctrl+b";
        in
        ''
          include themes/noctalia.conf

          kitten_alias hints hints --alphabet abcdefghijklmnopqrstuvwxyz1234567890 --hints-offset 0

          map ${mod}+c copy_selection_or_last_command_output
          map ${mod}+v paste_from_clipboard
          map ${mod}+s paste_from_selection
          map ${mod}+equal change_font_size all +1.0
          map ${mod}+minus change_font_size all -1.0
          map ${mod}+0 change_font_size all 0

          map ${mod}+k scroll_line_up
          map ${mod}+j scroll_line_down
          map ${mod}+u scroll_page_up
          map ${mod}+d scroll_page_down
          map ${mod}+p scroll_to_prompt -1 3
          map ${mod}+n scroll_to_prompt 1
          map ${mod}+h show_scrollback
          map ${mod}+slash search_scrollback
          map ${mod}+space command_palette

          map ${leader}>w new_window_with_cwd
          map ${leader}>ctrl+w new_window_with_cwd
          map ${leader}>q close_window
          map ${leader}>ctrl+q close_window
          map ${leader}>r set_window_title
          map ${leader}>ctrl+r set_window_title

          map ${leader}>h neighboring_window left
          map ${leader}>ctrl+h neighboring_window left
          map ${leader}>j neighboring_window down
          map ${leader}>ctrl+j neighboring_window down
          map ${leader}>k neighboring_window up
          map ${leader}>ctrl+k neighboring_window up
          map ${leader}>l neighboring_window right
          map ${leader}>ctrl+l neighboring_window right
          map ${leader}>b next_window
          map ${leader}>ctrl+b next_window
          map ${leader}>shift+b previous_window
          map ${leader}>f focus_visible_window
          map ${leader}>ctrl+f focus_visible_window
          map ${leader}>1 first_window
          map ${leader}>2 second_window
          map ${leader}>3 third_window
          map ${leader}>4 fourth_window
          map ${leader}>5 fifth_window
          map ${leader}>6 sixth_window
          map ${leader}>7 seventh_window
          map ${leader}>8 eighth_window
          map ${leader}>9 ninth_window
          map ${leader}>0 tenth_window

          map ${leader}>shift+h move_window left
          map ${leader}>shift+j move_window down
          map ${leader}>shift+k move_window up
          map ${leader}>shift+l move_window right
          map ${leader}>shift+f swap_with_window

          map --new-mode resize ${leader}>e
          map --mode resize h resize_window narrower
          map --mode resize j resize_window shorter
          map --mode resize k resize_window taller
          map --mode resize l resize_window wider
          map --mode resize r reset_window_sizes
          map --mode resize ctrl+c pop_keyboard_mode
          map --mode resize enter pop_keyboard_mode

          map ${leader}>t new_tab
          map ${leader}>ctrl+t new_tab
          map ${leader}>shift+r set_tab_title

          map ${leader}>n next_tab
          map ${leader}>ctrl+n next_tab
          map ${leader}>p previous_tab
          map ${leader}>ctrl+p previous_tab
          map ${leader}>ctrl+f select_tab
          map ${leader}>ctrl+1 goto_tab 1
          map ${leader}>ctrl+2 goto_tab 2
          map ${leader}>ctrl+3 goto_tab 3
          map ${leader}>ctrl+4 goto_tab 4
          map ${leader}>ctrl+5 goto_tab 5
          map ${leader}>ctrl+6 goto_tab 6
          map ${leader}>ctrl+7 goto_tab 7
          map ${leader}>ctrl+8 goto_tab 8
          map ${leader}>ctrl+9 goto_tab 9
          map ${leader}>ctrl+0 goto_tab 10

          map ${leader}>shift+n move_tab_forward
          map ${leader}>shift+p move_tab_backward

          map --new-mode appearance ${leader}>o
          map --mode appearance o set_background_opacity 1
          map --mode appearance shift+o set_background_opacity 0
          map --mode appearance equal set_background_opacity +0.1
          map --mode appearance minus set_background_opacity -0.1
          map --mode appearance r set_background_opacity default
          map --mode appearance f kitten choose-fonts
          map --mode appearance 0 remote_control set-spacing --all padding=0
          map --mode appearance 1 remote_control set-spacing --all padding=4
          map --mode appearance 2 remote_control set-spacing --all padding=8
          map --mode appearance 3 remote_control set-spacing --all padding=12
          map --mode appearance 4 remote_control set-spacing --all padding=20
          map --mode appearance 5 remote_control set-spacing --all padding=32
          map --mode appearance shift+r remote_control set-spacing --all padding=default
          map --mode appearance ctrl+c pop_keyboard_mode
          map --mode appearance enter pop_keyboard_mode

          map ${leader}>z toggle_layout stack
          map ${leader}>ctrl+z toggle_layout stack

          map --new-mode layout ${leader}>m
          map --mode layout n next_layout
          map --mode layout p last_used_layout
          map --mode layout t goto_layout tall
          map --mode layout f goto_layout fat
          map --mode layout g goto_layout grid
          map --mode layout h goto_layout horizontal
          map --mode layout v goto_layout vertical
          map --mode layout s goto_layout splits
          map --mode layout r layout_action rotate
          map --mode layout m layout_action mirror toggle
          map --mode layout i layout_action increase_num_full_size_windows
          map --mode layout d layout_action decrease_num_full_size_windows
          map --mode layout b layout_action bias 50 62 70
          map --mode layout ctrl+c pop_keyboard_mode
          map --mode layout enter pop_keyboard_mode

          map --new-mode kittens --on-action end ${leader}>space
          map --mode kittens f kitten choose-files
          map --mode kittens d kitten choose-files --mode dir
          map --mode kittens slash kitten unicode_input
          map --mode kittens l kitten hints --type line --program -
          map --mode kittens shift+l kitten hints --type line --program @
          map --mode kittens w kitten hints --type word --program -
          map --mode kittens shift+w kitten hints --type word --program @
          map --mode kittens h kitten hints --type hash --program -
          map --mode kittens shift+h kitten hints --type hash --program @
          map --mode kittens p kitten hints --type path
          map --mode kittens shift+p kitten hints --type path --program @
          map --mode kittens n kitten hints --type linenum
          map --mode kittens shift+n kitten hints --type linenum --program @
          map --mode kittens u kitten hints --type url
          map --mode kittens shift+u kitten hints --type url --program @
          map --mode kittens y kitten hints --type hyperlink
          map --mode kittens shift+y kitten hints --type hyperlink --program @
          map --mode kittens ctrl+c pop_keyboard_mode
          map --mode kittens enter pop_keyboard_mode
        '';
    };
  };

  xdg.configFile."kitty/tab_bar.py".source = ./tab_bar.py;
}
