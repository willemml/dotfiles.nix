{
  pkgs,
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/installation-device.nix")
  ];
  networking.hostName = "nixos-live";

  environment.systemPackages = with pkgs; [
    curl
    ddrescue
    efibootmgr
    efivar
    fuse
    fuse3
    gptfdisk
    hdparm
    ms-sys
    nano
    nvme-cli
    parted
    pciutils
    screen
    sdparm
    smartmontools
    socat
    sshfs-fuse
    testdisk
    unzip
    usbutils
    wget
    w3m-nographics
    zip
  ];

  # Include support for various filesystems and tools to create / manipulate them.
  boot.supportedFilesystems =
    ["btrfs" "cifs" "f2fs" "jfs" "ntfs" "reiserfs" "vfat" "xfs"]
    ++ lib.optional (lib.meta.availableOn pkgs.stdenv.hostPlatform config.boot.zfs.package) "zfs";

  boot.enableContainers = false;

  # get rid of mdadm warning
  boot.swraid.mdadmConf = ''
    PROGRAM ${pkgs.coreutils}/bin/true
  '';

  # Configure host id for ZFS to work
  networking.hostId = lib.mkDefault "deadbeef";
}
