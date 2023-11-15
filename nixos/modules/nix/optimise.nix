{...}: {
  nix = {
    settings.auto-optimise-store = true;
    gc.automatic = true;
    gc.options = "--delete-older-than 14d";
  };
}
