{
  lib,
  pkgs,
  ...
}: {
  users.users.willem = {
    shell = lib.mkDefault pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "video" "udev"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBx1z962nl87rmOk/vw3EBSgqU/VlCqON8zTeLHQcSBp willem@zeus"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFprwUFAmOqWlUtRkpGMAQJs6zJVesYIstXVLL3yjse willem@nixbox"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGe3g5Fuw+jcj+KMeV3cLJPkoBxUogqTtC3Hg7hMj8py willem@thinkpad"
    ];
  };
}
