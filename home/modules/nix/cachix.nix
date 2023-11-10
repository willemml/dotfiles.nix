{...}: {
  nix.settings.substituters = [
    "https://willemml.cachix.org"
    "https://cache.nixos.org"
  ];
  nix.settings.trusted-public-keys = [
    "willemml.cachix.org-1:A8M1pBOuBmA6f4Pq4+VNO0r4Joi2I3DZI72V3U+YnKg="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
}
