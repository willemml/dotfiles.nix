{ fetchurl, lib, mkMacBinPackage, stdenv }:
let
  appName = "VLC";
  pname = "vlc";
  version = "3.0.18";
  srcs = {
    aarch64-darwin = fetchurl {
      url =
        "http://get.videolan.org/vlc/${version}/macosx/vlc-${version}-arm64.dmg";
      sha256 = "sha256-mcJZvbxSIf1QgX9Ri3Dpv57hdeiQdDkDyYB7x3hmj0c=";
      name = "${pname}_aarch64_${version}.dmg";
    };
    x86_64-darwin = fetchurl {
      url =
        "http://get.videolan.org/vlc/${version}/macosx/vlc-${version}-intel64.dmg";
      sha256 = "sha256-iO3N/Os70vaANn2QCdOKDBR/p1jy3TleQ0EsHgjOHMs=";
      name = "${pname}_x86_64_${version}.dmg";
    };
  };
  src = srcs.${stdenv.hostPlatform.system};
in
mkMacBinPackage {
  inherit src pname appName version;
  meta = with lib; {
    description = "Cross-platform media player and streaming server";
    homepage = "http://www.videolan.org/vlc/";
    license = licenses.lgpl21Plus;
    platforms = platforms.darwin;
  };
}


