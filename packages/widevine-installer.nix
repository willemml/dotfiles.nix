{pkgs, ...}:
pkgs.stdenv.mkDerivation rec {
  name = "widevine-installer";
  version = "7a3928fe1342fb07d96f61c2b094e3287588958b";
  src = pkgs.fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "${name}";
    rev = "${version}";
    sha256 = "sha256-XI1y4pVNpXS+jqFs0KyVMrxcULOJ5rADsgvwfLF6e0Y=";
  };

  buildInputs = with pkgs; [which python3 squashfsTools];

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/conf"
    cp widevine-installer "$out/bin/"
    cp widevine_fixup.py "$out/bin/"
    cp conf/gmpwidevine.js "$out/conf/"
    echo "$(which unsquashfs)"
    sed -e "s|unsquashfs|$(which unsquashfs)|" -i "$out/bin/widevine-installer"
    sed -e "s|python3|$(which python3)|" -i "$out/bin/widevine-installer"
    sed -e "s|read|#read|" -i "$out/bin/widevine-installer"
    sed -e 's|$(whoami)|root|' -i "$out/bin/widevine-installer"
    sed -e 's|URL=.*|URL="$DISTFILES_BASE"|' -i "$out/bin/widevine-installer"
  '';
}
