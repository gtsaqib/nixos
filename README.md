# My NixOS

Personal NixOS config for `gts`. flake-based, home-manager integrated.

- wm: hyprland (uwsm, dynamic cursors)
- desktop / ui: noctalia (greeter, shell, dynamic wallpaper theming)
- term & editor: kitty + helix
- shell: fish + starship
- browsers: zen-browser, helium
- secrets: sops-nix (age)
- cli toys: yazi, lazygit, bottom, difftastic, fastfetch

Try it (though you need my age key):

```sh
nh os switch
# or: nixos-rebuild switch --flake .#gts
```

### structure
- `system/` & `modules/system/`: system-level configs, hardware, kernel, services
- `user/` & `modules/user/`: home-manager modules, dotfiles, app templates
- `pkgs/`: custom packages / overlays
- `secrets/`: sops-encrypted secrets
