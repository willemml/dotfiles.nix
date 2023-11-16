{...}: {
  nix.settings = {
    substituters = [
      "https://willemml.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "willemml.cachix.org-1:A8M1pBOuBmA6f4Pq4+VNO0r4Joi2I3DZI72V3U+YnKg="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
