{ ... }:

{
  programs.ghostty = {
    enable = true;
    clearDefaultKeybinds = true;

    settings = {
      theme = "noctalia";
      font-family = "Maple Mono NF";
      font-size = 12;
      background-opacity = 0.5;
      background-blur = true;
      unfocused-split-opacity = 0.75;
      clipboard-trim-trailing-spaces = true;
      confirm-close-surface = false;
      quit-after-last-window-closed-delay = "1h";

      keybind =
        let
          mod = "ctrl+shift";
        in
        [
          "${mod}+c=copy_to_clipboard:mixed"
          "${mod}+v=paste_from_clipboard"
          "${mod}+s=paste_from_selection"
          "${mod}+equal=increase_font_size:1"
          "${mod}+minus=decrease_font_size:1"
          "${mod}+0=reset_font_size"

          "${mod}+k=scroll_page_lines:-1"
          "${mod}+j=scroll_page_lines:1"
          "${mod}+u=scroll_page_up"
          "${mod}+d=scroll_page_down"
          "${mod}+p=jump_to_prompt:-1"
          "${mod}+n=jump_to_prompt:1"
          "${mod}+h=write_scrollback_file:open"
          "${mod}+slash=start_search"
          "${mod}+space=toggle_command_palette"
        ];
    };
  };
}
