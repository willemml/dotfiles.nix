{ stdenv, pkgs, fetchurl, ... }:

let
  versions = {
    aarch64-darwin = "1101351";
    x86_64-darwin = "1101350";
  };

  version = versions.${stdenv.hostPlatform.system};

  pname = "chromium";
  appName = "Chromium";

  srcs = {
    aarch64-darwin = fetchurl {
      url = "https://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac_Arm/${version}/chrome-mac.zip";
      sha256 = "sha256-LlbYlJmFLzyHIiygofa0Btm7NAOvWXXhmbjMHldVoGo=";
      name = "${pname}_aarch64_${version}.zip";
    };
    x86_64-darwin = fetchurl {
      url = "https://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/${version}/chrome-mac.zip";
      sha256 = "sha256-O+OnjakEpjCRbSjDysEA6RKKaKaSMw+LSO2ZLcxz2vM=";
      name = "${pname}_x86_64_${version}.zip";
    };
  };
  src =  srcs.${stdenv.hostPlatform.system};
in import ./mk-mac-binpkg.nix { inherit pkgs src pname appName version; srcsubdir = "chrome-mac"; }
