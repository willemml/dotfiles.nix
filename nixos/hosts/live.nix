{pkgs, ...}: {
  networking.hostName = "nixos-live";

  isoImage.makeEfiBootable = true;

  documentation.nixos.enable = true;

  users.users.willem.initialHashedPassword = "";
  users.users.root.initialHashedPassword = "";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.getty.autologinUser = "willem";

  services.openssh.enable = true;

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
    mesa
  ];

  # Include support for various filesystems and tools to create / manipulate them.
  boot.supportedFilesystems =
    ["btrfs" "cifs" "f2fs" "jfs" "ntfs" "reiserfs" "vfat" "xfs"]
    ++ lib.optional (lib.meta.availableOn pkgs.stdenv.hostPlatform config.boot.zfs.package) "zfs";

  boot.enableContainers = false;

  # Configure host id for ZFS to work
  networking.hostId = lib.mkDefault "8425e349";
}
