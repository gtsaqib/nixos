{ lib, ... }:

let
  inherit (builtins)
    elem
    filter
    genList
    ;

  action = name: args: extra: {
    ${name} = {
      _args = args;
    }
    // extra;
  };

  a = name: args: action name args { };

  bind = keys: actions: {
    bind = {
      _args = keys;
      _children = actions;
    };
  };

  mode = name: bindings: {
    ${name}._children = bindings;
  };

  chars = lib.stringToCharacters "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

  unusedAlphabet =
    bindings:
    let
      boundKeys = lib.concatLists (map (binding: binding.bind._args) bindings);
    in
    filter (key: !(elem key boundKeys)) chars;

  withFallback =
    bindings:
    bindings
    ++ map (
      key:
      bind
        [ key ]
        [
          (a "WriteChars" [ key ])
          (a "SwitchToMode" [ "Locked" ])
        ]
    ) (unusedAlphabet bindings);

  locked = [
    (bind
      [ "Ctrl b" ]
      [
        (a "SwitchToMode" [ "Normal" ])
      ]
    )
  ];

  normal = [
    (bind
      [ "Backspace" "Ctrl c" ]
      [
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "r" ]
      [
        (a "SwitchToMode" [ "RenamePane" ])
        (a "PaneNameInput" [ 0 ])
      ]
    )
    (bind
      [ "R" ]
      [
        (a "SwitchToMode" [ "RenameTab" ])
        (a "TabNameInput" [ 0 ])
      ]
    )
    (bind
      [ "/" "?" ]
      [
        (a "SwitchToMode" [ "EnterSearch" ])
        (a "SearchInput" [ 0 ])
      ]
    )
    (bind
      [ "e" ]
      [
        (a "SwitchToMode" [ "Resize" ])
      ]
    )
    (bind
      [ "g" ]
      [
        (a "SwitchToMode" [ "Scroll" ])
      ]
    )
    (bind
      [ "o" ]
      [
        (a "SwitchToMode" [ "Session" ])
      ]
    )

    (bind
      [ "v" ]
      [
        (a "NewPane" [ "Right" ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "s" ]
      [
        (a "NewPane" [ "Down" ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "t" ]
      [
        (a "NewTab" [ ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )

    (bind
      [ "b" ]
      [
        (a "BreakPane" [ ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "q" ]
      [
        (a "CloseFocus" [ ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "f" ]
      [
        (a "ToggleFocusFullscreen" [ ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "y" ]
      [
        (a "TogglePanePinned" [ ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )

    (bind
      [ "Space" ]
      [
        (a "TogglePaneEmbedOrFloating" [ ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "Ctrl Space" ]
      [
        (a "ToggleFloatingPanes" [ ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )

    (bind
      [ "h" ]
      [
        (a "MoveFocus" [ "left" ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "j" ]
      [
        (a "MoveFocus" [ "down" ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "k" ]
      [
        (a "MoveFocus" [ "up" ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "l" ]
      [
        (a "MoveFocus" [ "right" ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )

    (bind
      [ "Ctrl b" ]
      [
        (a "FocusNextPane" [ ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "Ctrl B" ]
      [
        (a "FocusPreviousPane" [ ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )

    (bind
      [ "p" ]
      [
        (a "GoToPreviousTab" [ ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "n" ]
      [
        (a "GoToNextTab" [ ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
  ]
  ++ map (
    n:
    bind
      [ (toString n) ]
      [
        (a "GoToTab" [ n ])
        (a "SwitchToMode" [ "Locked" ])
      ]
  ) (genList (i: i + 1) 9)
  ++ [
    (bind
      [ "Q" ]
      [
        (a "Quit" [ ])
      ]
    )
  ];

  renamepane = [
    (bind
      [ "Enter" ]
      [
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "Ctrl c" ]
      [
        (a "UndoRenamePane" [ ])
        (a "SwitchToMode" [ "Normal" ])
      ]
    )
  ];

  renametab = [
    (bind
      [ "Enter" ]
      [
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "Ctrl c" ]
      [
        (a "UndoRenameTab" [ ])
        (a "SwitchToMode" [ "Normal" ])
      ]
    )
  ];

  entersearch = [
    (bind
      [ "Enter" ]
      [
        (a "SwitchToMode" [ "Scroll" ])
      ]
    )
    (bind
      [ "Ctrl c" ]
      [
        (a "SearchInput" [ 0 ])
        (a "SwitchToMode" [ "Normal" ])
      ]
    )

    (bind
      [ "Ctrl n" ]
      [
        (a "Search" [ "Down" ])
      ]
    )
    (bind
      [ "Ctrl N" ]
      [
        (a "Search" [ "Up" ])
      ]
    )

    (bind
      [ "Alt c" ]
      [
        (a "SearchToggleOption" [ "CaseSensitivity" ])
      ]
    )
    (bind
      [ "Alt w" ]
      [
        (a "SearchToggleOption" [ "Wrap" ])
      ]
    )
    (bind
      [ "Alt o" ]
      [
        (a "SearchToggleOption" [ "WholeWord" ])
      ]
    )
  ];

  resize = [
    (bind
      [ "Ctrl c" ]
      [
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "Backspace" ]
      [
        (a "SwitchToMode" [ "Normal" ])
      ]
    )
    (bind
      [ "/" "?" ]
      [
        (a "SwitchToMode" [ "EnterSearch" ])
        (a "SearchInput" [ 0 ])
      ]
    )

    (bind
      [ "h" ]
      [
        (a "Resize" [ "Left" ])
      ]
    )
    (bind
      [ "j" ]
      [
        (a "Resize" [ "Down" ])
      ]
    )
    (bind
      [ "k" ]
      [
        (a "Resize" [ "Up" ])
      ]
    )
    (bind
      [ "l" ]
      [
        (a "Resize" [ "Right" ])
      ]
    )

    (bind
      [ "+" ]
      [
        (a "Resize" [ "Increase" ])
      ]
    )
    (bind
      [ "-" ]
      [
        (a "Resize" [ "Decrease" ])
      ]
    )

    (bind
      [ "H" ]
      [
        (a "MovePane" [ "left" ])
      ]
    )
    (bind
      [ "J" ]
      [
        (a "MovePane" [ "down" ])
      ]
    )
    (bind
      [ "K" ]
      [
        (a "MovePane" [ "up" ])
      ]
    )
    (bind
      [ "L" ]
      [
        (a "MovePane" [ "right" ])
      ]
    )

    (bind
      [ "p" ]
      [
        (a "MoveTab" [ "Left" ])
      ]
    )
    (bind
      [ "n" ]
      [
        (a "MoveTab" [ "Right" ])
      ]
    )
  ];

  scroll = [
    (bind
      [ "Ctrl c" ]
      [
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "Backspace" ]
      [
        (a "SwitchToMode" [ "Normal" ])
      ]
    )
    (bind
      [ "/" "?" ]
      [
        (a "SwitchToMode" [ "EnterSearch" ])
        (a "SearchInput" [ 0 ])
      ]
    )

    (bind
      [ "j" ]
      [
        (a "ScrollDown" [ ])
      ]
    )
    (bind
      [ "k" ]
      [
        (a "ScrollUp" [ ])
      ]
    )

    (bind
      [ "d" ]
      [
        (a "HalfPageScrollDown" [ ])
      ]
    )
    (bind
      [ "u" ]
      [
        (a "HalfPageScrollUp" [ ])
      ]
    )
    (bind
      [ "f" ]
      [
        (a "PageScrollDown" [ ])
      ]
    )
    (bind
      [ "b" ]
      [
        (a "PageScrollUp" [ ])
      ]
    )

    (bind
      [ "g" ]
      [
        (a "ScrollToTop" [ ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "e" ]
      [
        (a "ScrollToBottom" [ ])
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "Ctrl j" ]
      [
        (a "ScrollToNextPrompt" [ ])
      ]
    )
    (bind
      [ "Ctrl k" ]
      [
        (a "ScrollToPreviousPrompt" [ ])
      ]
    )

    (bind
      [ "n" ]
      [
        (a "Search" [ "Down" ])
      ]
    )
    (bind
      [ "N" ]
      [
        (a "Search" [ "Up" ])
      ]
    )

    (bind
      [ "Alt c" ]
      [
        (a "SearchToggleOption" [ "CaseSensitivity" ])
      ]
    )
    (bind
      [ "Alt w" ]
      [
        (a "SearchToggleOption" [ "Wrap" ])
      ]
    )
    (bind
      [ "Alt o" ]
      [
        (a "SearchToggleOption" [ "WholeWord" ])
      ]
    )
  ];

  session = [
    (bind
      [ "Ctrl c" ]
      [
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
    (bind
      [ "Backspace" ]
      [
        (a "SwitchToMode" [ "Normal" ])
      ]
    )
    (bind
      [ "/" "?" ]
      [
        (a "SwitchToMode" [ "EnterSearch" ])
        (a "SearchInput" [ 0 ])
      ]
    )

    (bind
      [ "b" ]
      [
        (action "Run" [ "btm" ] {
          _children = [
            { floating = true; }
            { width = "80%"; }
            { height = "80%"; }
          ];
        })
        (a "SwitchToMode" [ "Locked" ])
      ]
    )

    (bind
      [ "w" ]
      [
        (action "LaunchOrFocusPlugin" [ "session-manager" ] {
          _children = [
            { floating = true; }
            { move_to_focused_tab = true; }
          ];
        })
        (a "SwitchToMode" [ "Locked" ])
      ]
    )

    (bind
      [ "l" ]
      [
        (action "LaunchOrFocusPlugin" [ "zellij:layout-manager" ] {
          _children = [
            { floating = true; }
            { move_to_focused_tab = true; }
          ];
        })
        (a "SwitchToMode" [ "Locked" ])
      ]
    )
  ];

  keybinds = {
    _props = {
      clear-defaults = true;
    };
    _children = [
      (mode "locked" locked)
      (mode "normal" (withFallback normal))
      (mode "renamepane" renamepane)
      (mode "renametab" renametab)
      (mode "entersearch" entersearch)
      (mode "resize" (withFallback resize))
      (mode "scroll" (withFallback scroll))
      (mode "session" (withFallback session))
    ];
  };
in
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    exitShellOnExit = true;

    settings = {
      theme = "noctalia";
      default_mode = "locked";
      pane_frame_style = "full";
      show_startup_tips = false;
      mouse_hover_tips = false;
      scroll_mode_sync = false;

      inherit keybinds;
    };
  };
}
