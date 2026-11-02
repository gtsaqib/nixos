{ pkgs, ... }:

{
  home.packages = with pkgs; [
    stylua
    nixfmt
    yamlfmt
    mago
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "noctalia";

      editor = {
        line-number = "relative";
        # cursorline = true;
        continue-comments = false;
        completion-trigger-len = 1;
        trim-final-newlines = true;
        trim-trailing-whitespace = true;
        bufferline = "always";
        popup-border = "all";
        end-of-line-diagnostics = "hint";
        soft-wrap.enable = true;
        inline-diagnostics.cursor-line = "warning";

        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        file-picker = {
          hidden = false;
          ignore = false;
          git-ignore = false;
          git-global = false;
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          center = [
            "register"
            "diagnostics"
          ];
          right = [
            "selections"
            "position"
          ];
        };

        indent-guides = {
          render = true;
          character = "▏";
        };
      };

      keys = {
        normal = {
          C-s = ":w";

          space = {
            space = "last_picker";
            x = ":yank-diagnostic";
          };
        };
        insert = {
          C-s = ":w";
          C-c = "normal_mode";
          C-v = "paste_clipboard_before";
          C-p = "paste_before";
        };
      };
    };

    languages = {
      language-server = {
        nixd.command = "${pkgs.nixd}/bin/nixd";
        emmylua_ls.command = "${pkgs.emmylua-ls}/bin/emmylua_ls";
        tombi.command = "${pkgs.tombi}/bin/tombi";
        yaml-language-server.command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
        vscode-html-language-server.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
        vscode-css-language-server.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
        vscode-json-language-server.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
        vscode-eslint-language-server.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server";

        tsc = {
          command = "${pkgs.typescript}/bin/tsc";
          args = [
            "--lsp"
            "--stdio"
          ];
        };

        tailwindcss-ls.command = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server";
        svelteserver.command = "${pkgs.svelte-language-server}/bin/svelteserver";
        vuels.command = "${pkgs.vue-language-server}/bin/vue-language-server";
        phpantom.command = "${pkgs.phpantom-lsp}/bin/phpantom_lsp";
        ty.command = "${pkgs.ty}/bin/ty";
        ruff.command = "${pkgs.ruff}/bin/ruff";
        gopls.command = "${pkgs.gopls}/bin/gopls";
        markdown-oxide.command = "${pkgs.markdown-oxide}/bin/markdown-oxide";
      };
      language =
        let
          mkTsLanguages = map (name: {
            inherit name;
            language-servers = [ "tsc" ];
          });
        in
        [
          {
            name = "lua";
            language-servers = [ "emmylua_ls" ];

            formatter = {
              command = "stylua";
              args = [
                "--search-parent-directories"
                "-"
              ];
            };
          }
          {
            name = "php";
            language-servers = [ "phpantom" ];

            formatter = {
              command = "mago";
              args = [
                "format"
                "--stdin-input"
              ];
            };
          }
        ]
        ++ mkTsLanguages [
          "javascript"
          "typescript"
          "jsx"
          "tsx"
        ];
    };
  };
}
