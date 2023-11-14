{...}: {
  imports = [./base.nix];
  users.users.willem = {
    extraGroups = ["networkmanager" "wheel" "video" "udev"];
    isNormalUser = true;
  };
}
