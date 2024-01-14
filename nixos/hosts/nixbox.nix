{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  torrent_group_id = 987;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../profiles/hyprland.nix
    ../profiles/default.nix
    ../users/willem/home/linux.nix
    ../modules/zerotier.nix
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["amdgpu"];
  boot.extraModulePackages = [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = ["zfs"];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "06818aaa";

  hardware.opengl.driSupport = true;
  hardware.opengl.enable = true;

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/24855432-019b-43d9-9b83-9135b9dc31a6";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F2E9-F515";
    fsType = "vfat";
  };

  boot.zfs.extraPools = ["zpool"];

  swapDevices = [{device = "/dev/disk/by-uuid/36bb51f0-f56d-4408-b61c-7905789a7304";}];

  environment.systemPackages = [pkgs.zfs];

  services.zfs.autoScrub.enable = true;

  services.jellyfin.enable = true;

  users.groups.torrent.gid = torrent_group_id;

  services.transmission = {
    enable = false;

    package = pkgs.transmission_4;

    group = "torrent";

    settings = rec {
      download-dir = "/zpool/media/torrents";
      incomplete-dir = "/zpool/media/torrents/.incomplete";
      incomplete-dir-enabled = true;
      peer-port = 51413;
      rpc-enabled = true;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
      rpc-whitelist = "10.1.2.*,127.0.0.*";
      rpc-host-whitelist-enabled = false;
    };
  };

  networking.nftables.enable = true;
  networking.nftables.flushRuleset = true;

  networking.nftables.tables."nixos-fw".content = lib.mkForce "";

  networking.nftables.ruleset = ''
    table inet filter {
      chain input {
        type filter hook input priority 0;

        # accept all localhost and zerotier traffic
        iifname lo accept
        iifname "zt*" accept

        # accept traffic sent by us
        ct state {established, related} accept

        # ICMP
        # routers may also want: mld-listener-query, nd-router-solicit
        ip protocol icmp icmp type { destination-unreachable, router-advertisement, time-exceeded, parameter-problem } accept

        # allow "ping"
        ip protocol icmp icmp type echo-request accept

        # jellyfin
        tcp dport 8096 accept
        tcp dport 8920 accept
        udp dport 1900 accept
        udp dport 7359 accept

        # transmission web ui
        tcp dport 9091 accept

        # zerotier
        udp dport 9993 accept
        tcp dport 9993 accept

        # ssh
        tcp dport 22 accept

        iifname "tun0" tcp dport 51413 accept
        iifname "tun0" udp dport 51413 accept

        iifname {lo, "zt*"} tcp dport 9091 accept

        iifname "tun0" skgid ${toString torrent_group_id} accept

        # drop all other packets
        counter drop
        #accept
      }

      chain output {
        type filter hook output priority 0;

        tcp dport 53 accept
        udp dport 53 accept

        oifname {"lo", "zt*"} tcp sport 9091 accept

        skgid ${toString torrent_group_id} oifname != "tun0" counter drop

        # zerotier
        oifname "zt*" accept
        udp dport 9993 accept
        tcp dport 9993 accept

        accept
      }

      chain forward {
        type filter hook forward priority 0;

        accept
      }
    }
  '';

  networking.useDHCP = lib.mkDefault true;

  networking.hostName = "nixbox";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
