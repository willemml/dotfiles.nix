{...}: {
  imports = [./default.nix];
  users.users.willem.hashedPassword = "";
  services.getty.autologinUser = "willem";
}
