{inputs, ...}: {
  imports = [
    ../profiles/live-image.nix
    ../modules/apple-silicon.nix
  ];

  networking.hostName = "nixos-live-aarch64";
}
