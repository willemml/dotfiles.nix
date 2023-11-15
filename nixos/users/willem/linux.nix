{...}: {
  imports = [./default.nix];
  users.users.willem = {
    extraGroups = ["networkmanager" "wheel" "video" "udev"];
    isNormalUser = true;

    home = "/home/willem";
  };
}
