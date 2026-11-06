{ ... }:

{
  programs = {
    fish.interactiveShellInit = ''
      fastfetch
      set fish_greeting ""
    '';
    fastfetch = {
      enable = true;
      settings = {
        logo = {
          type = "small";
          padding = {
            top = 2;
            right = 2;
          };
        };
        display = {
          separator = " ";
        };
        modules = [
          {
            key = "╭───────────╮";
            type = "custom";
          }
          {
            key = "│ {#31}󰌢 user    {#keys}│";
            type = "title";
            format = "{user-name}{at-symbol-colored}{host-name}";
          }
          {
            key = "│ {#32}󰅐 uptime  {#keys}│";
            type = "uptime";
          }
          {
            key = "│ {#33}{icon} distro  {#keys}│";
            type = "os";
          }
          {
            key = "│ {#34} kernel  {#keys}│";
            type = "kernel";
          }
          {
            key = "│ {#35} desktop {#keys}│";
            type = "de";
          }
          {
            key = "│ {#35} desktop {#keys}│";
            type = "wm";
          }
          {
            key = "│ {#31} term    {#keys}│";
            type = "terminal";
          }
          {
            key = "│ {#32} shell   {#keys}│";
            type = "shell";
          }
          {
            key = "│ {#33}󰍛 cpu     {#keys}│";
            type = "cpu";
            showPeCoreCount = true;
          }
          {
            key = "│ {#34}󰉉 disk    {#keys}│";
            type = "disk";
            folders = "/";
          }
          {
            key = "│ {#35} memory  {#keys}│";
            type = "memory";
          }
          {
            key = "│ {#36}󰁹 battery {#keys}│";
            type = "battery";
          }
          {
            key = "│ {#37}󰩟 network {#keys}│";
            type = "localip";
            format = "{ipv4} ({ifname})";
          }
          {
            key = "├───────────┤";
            type = "custom";
          }
          {
            key = "│ {#39} colors  {#keys}│";
            type = "colors";
            symbol = "circle";
          }
          {
            key = "│ {#31}󰎆 media   {#keys}│";
            type = "media";
            format = "{artist} - {combined}";
          }
          {
            key = "╰───────────╯";
            type = "custom";
          }
        ];
      };
    };
  };
}
