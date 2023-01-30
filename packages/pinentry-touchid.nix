{ stdenv, pkgs, fetchFromGitHub, ... }:

pkgs.mkShell {
  name = "pinentry-touchid";
  src = fetchFromGitHub {
    owner = "jorgelbg";
    repo = "pinentry-touchid";
    rev = "1170eb6bc7b23313aee622887b47b77be6e5fb5f";
    sha256 = "sha256-DT8vYDcBD5FMMVe4JcxNmYnfJ1o18deiKkfVQcW3AN0=";
  };

  buildInputs = with pkgs; [
    go
    gopls
    gotools
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.LocalAuthentication
  ];

  buildPhase = ''
    unset GOPATH GOROOT
    export NIX_LDFLAGS="-F${pkgs.darwin.apple_sdk.frameworks.CoreFoundation}/Library/Frameworks -framework CoreFoundation $NIX_LDFLAGS";

    go mod download

    go build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp pinentry-touchid $out/bin/.
  '';

  shellHook = ''
    unset GOPATH GOROOT
    export NIX_LDFLAGS="-F${pkgs.darwin.apple_sdk.frameworks.CoreFoundation}/Library/Frameworks -framework CoreFoundation $NIX_LDFLAGS";
  '';
}
