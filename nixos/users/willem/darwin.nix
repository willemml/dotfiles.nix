{...}: {
  imports = [./default.nix];

  users.users.willem = {
    isHidden = false;

    home = "/Users/willem";
  };
}
