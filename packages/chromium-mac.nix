{ fetchurl, lib, mkMacBinPackage, stdenv }:

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
      url =
        "https://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac_Arm/${version}/chrome-mac.zip";
      sha256 = "sha256-LlbYlJmFLzyHIiygofa0Btm7NAOvWXXhmbjMHldVoGo=";
      name = "${pname}_aarch64_${version}.zip";
    };
    x86_64-darwin = fetchurl {
      url =
        "https://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/${version}/chrome-mac.zip";
      sha256 = "sha256-O+OnjakEpjCRbSjDysEA6RKKaKaSMw+LSO2ZLcxz2vM=";
      name = "${pname}_x86_64_${version}.zip";
    };
  };
  src = srcs.${stdenv.hostPlatform.system};
in
mkMacBinPackage {
  inherit src pname appName version;
  srcsubdir = "chrome-mac";
  meta = with lib; {
    description = "An open source web browser from Google.";
    longDescription = ''
      Chromium is an open source web browser from Google that aims to build a
      safer, faster, and more stable way for all Internet users to experience
      the web. It has a minimalist user interface and provides the vast majority
      of source code for Google Chrome (which has some additional features).
    '';
    homepage = "https://www.chromium.org/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    mainProgram = "chromium";
  };
}
