{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../profiles/hyprland.nix
    ../profiles/default.nix
    ../users/willem/home/linux.nix
    ../modules/zerotier.nix
    ../modules/nordvpn.nix
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
    device = "/dev/disk/by-uuid/9b616ca8-63fe-4d81-a13e-25c9a95a1a55";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4FEE-904E";
    fsType = "vfat";
  };

  fileSystems."/zpool" = {
    device = "zpool";
    fsType = "zfs";
  };

  environment.systemPackages = [pkgs.zfs];

  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = true;

  services.transmission = {
    enable = true;

    settings = rec {
      download-dir = "/zpool/torrents/complete";
      incomplete-dir = "/zpool/torrents/incomplete";
      incomplete-dir-enabled = true;
      rpc-enabled = true;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
      rpc-host-whitelist-enabled = false;
    };
  };

  networking.firewall.allowedTCPPorts = [9091];
  networking.firewall.allowedUDPPorts = [9091];

  networking.firewall.logRefusedConnections = true;
  networking.firewall.logRefusedPackets = true;

  networking.nftables.enable = true;
  networking.nftables.flushRuleset = true;

  networking.nftables.tables."nixos-fw".content = lib.mkForce "";

  networking.firewall.trustedInterfaces = ["zt*"];

  swapDevices = [];

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

        # drop all other packets
        #counter drop
        accept
      }

      chain output {
        type filter hook output priority 0;

        oifname != { "lo", "tun0", "zt*" } skgid 70 counter reject

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
