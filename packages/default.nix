final: prev: {
  widevine-installer = prev.callPackage ./widevine-installer.nix {};
  widevine = prev.callPackage ./widevine.nix {};
  firefox = prev.firefox.override (old: {
    extraPrefsFiles = ["${final.widevine-installer}/conf/gmpwidevine.js"];
  });
}
