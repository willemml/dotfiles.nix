{
  home.file = {
    ".config/nixpkgs/config.nix".text = ''
      # -*-nix-*-
      {
        nixpkgs.config.allowUnfreePredicate = (_: true);
        allowUnfree = true;
      }
    '';
  };
}
