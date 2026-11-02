{ pkgs, inputs, ... }:

let
  cws = id: "${id};https://clients2.google.com/service/update2/crx";
in
{
  environment.systemPackages = [
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  environment.etc."chromium/policies/managed/helium.json".text = builtins.toJSON {
    BookmarkBarEnabled = true;
    PasswordManagerEnabled = false;
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    HttpsUpgradesEnabled = true;
    HttpsOnlyMode = "force_enabled";
    BlockThirdPartyCookies = true;

    ExtensionInstallForcelist = [
      (cws "eimadpbcbfnmbkopoojfekhnkhdbieeh")
      (cws "jinjaccalgkegednnccohejagnlnfdag")
      (cws "clngdbkpkpeebahjckkjfobafhncgmne")
      (cws "gppongmhjkpfnbhagpmjfkannfbllamg")
      (cws "ghmbeldphafepmbegfdlkpapadhbakde")
      (cws "gebbhagfogifgggkldgodflihgfeippi")
      (cws "aleakchihdccplidncghkekgioiakgal")
    ];

    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Brave Search";
    DefaultSearchProviderKeyword = "brave";
    DefaultSearchProviderSearchURL = "https://search.brave.com/search?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://search.brave.com/api/suggest?q={searchTerms}";

    SiteSearchSettings = [
      {
        name = "NixOS Packages";
        shortcut = "np";
        url = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
        featured = true;
      }
      {
        name = "NixOS Options";
        shortcut = "no";
        url = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
        featured = true;
      }
    ];
  };
}
