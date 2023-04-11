{
  pkgs,
  fetchFromGitHub,
  lib,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "vkquake";
  name = "vkQuake";

  src = fetchFromGitHub {
    owner = "Novum";
    repo = "vkQuake";
    rev = "98e9e1c76e4ea57d6960c8b4c67a72f7f50f45ea";
    sha256 = "sha256-XMsvc9886eYI+CzBMckop7WCAulm2qlKdNu+3qDK7zY=";
  };

  nativeBuildInputs = with pkgs; [
    meson
    pkgconfig
    python3
    cmake
    ninja
    darwin.binutils
    ripgrep
  ];

  buildInputs = with pkgs; [
    vulkan-headers
    glslang
    spirv-tools
    SDL2
    libvorbis
    flac
    libopus
    opusfile
    flac
    libmad
    darwin.moltenvk
  ];

  macApp = ./vkQuake.app;

  buildPhase = ''
    # -*-sh-*-
    cp -r $src/* .
    meson build && ninja -C build
    cp -r $macApp vkQuake.app
    chmod -R a+rw vkQuake.app
    ls
    cp build/vkquake vkQuake.app/Contents/Resources/vkquake
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/Applications
    mv build/vkquake $out/bin/vkquake
    mv vkQuake.app $out/Applications/.
  '';
}
