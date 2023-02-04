{ stdenv, pkgs, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  name = "pinentry-touchid";
  src = fetchFromGitHub {
    owner = "jorgelbg";
    repo = "pinentry-touchid";
    rev = "1170eb6bc7b23313aee622887b47b77be6e5fb5f";
    sha256 = "sha256-asLFY7ztRKXEFsetB3Ym/0tJ1BBOn0yYpL8MIn1Z//0=";
  };

  nativeBuildInputs = with pkgs; [
    go
    gopls
    gotools
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.LocalAuthentication
  ];

  sourceRoot = ".";

  buildPhase = ''
    unset GOROOT

    export GOPATH="/tmp/gopath-$(echo $RANDOM | md5sum | head -c 20)"
    export GOCACHE="/tmp/gocache-$(echo $RANDOM | md5sum | head -c 20)"

    export NIX_LDFLAGS="-F${pkgs.darwin.apple_sdk.frameworks.CoreFoundation}/Library/Frameworks -framework CoreFoundation $NIX_LDFLAGS";

    cd source

    go mod download
    go build
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv pinentry-touchid $out/bin/pinentry-touchid
  '';
}
