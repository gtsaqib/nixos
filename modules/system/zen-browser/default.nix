{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  prefs = {
    "general.smoothScroll.mouseWheel.durationMinMS" = 80;
    "general.smoothScroll.mouseWheel.durationMaxMS" = 150;
    "zen.tabs.ctrl-tab.ignore-essential-tabs" = true;
    "zen.tabs.vertical.right-side" = true;
    "zen.view.compact.enable-at-startup" = true;
    "browser.ml.linkPreview.enabled" = true;
    "browser.ml.linkPreview.collapsed" = true;
    "browser.ctrlTab.sortByRecentlyUsed" = true;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.link.open_newwindow.override.external" = 7;
    "browser.search.suggest.enabled" = true;
    "browser.urlbar.suggest.history" = false;
    "browser.urlbar.suggest.bookmark" = false;
    "browser.urlbar.suggest.recentsearches" = false;
    "browser.urlbar.suggest.searches" = false;
    "identity.fxaccounts.enabled" = false;
    "media.hardware-video-decoding.force-enabled" = true;
    "media.av1.enabled" = false;
    "signon.rememberSignons" = false;
    "signon.autofillForms" = false;
    "signon.generation.enabled" = false;
    "dom.webgpu.enabled" = true;
    "dom.security.https_only_mode" = true;
    "extensions.autoDisableScopes" = 0;
    "extensions.pocket.enabled" = false;
    "privacy.query_stripping.enabled" = true;
    "privacy.donottrackheader.enabled" = true;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };

  extensions = [
    # https://addons.mozilla.org/api/v5/addons/addon/<SHORT_ID>/ to get the guid
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    (extension "darkreader" "addon@darkreader.org")
    (extension "violentmonkey" "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}")
    (extension "styl-us" "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}")
    (extension "wappalyzer" "wappalyzer@crunchlabz.com")
    (extension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me")
    (extension "h264ify" "jid1-TSgSxBhncsPBWQ@jetpack")
    (extension "return-youtube-dislikes" "{762f9885-5a13-4abd-9c77-433dcd38b8fd}")
  ];
in
{
  environment.systemPackages = [
    (pkgs.wrapFirefox
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
      {
        extraPrefs = lib.concatLines (
          lib.mapAttrsToList (
            name: value: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});"
          ) prefs
        );

        extraPolicies = {
          DisableTelemetry = true;
          ExtensionSettings = builtins.listToAttrs extensions;

          SearchEngines = {
            Default = "Brave Search";
            Add = [
              {
                Name = "Brave Search";
                URLTemplate = "https://search.brave.com/search?q={searchTerms}";
                SuggestionURLTemplate = "https://search.brave.com/api/suggest?q={searchTerms}";
                IconURL = "https://brave.com/favicon.ico";
                Alias = "@brave";
              }
              {
                Name = "NixOS Packages";
                URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@np";
              }
              {
                Name = "NixOS Options";
                URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@no";
              }
            ];
          };
        };
      }
    )
  ];
}
