{
  pkgs,
  config,
  ...
}: {
  boot.postBootCommands = let
    inherit (config.hardware.asahi.pkgs) asahi-fwextract;
  in ''
    for o in $(</proc/cmdline); do
      case "$o" in
        live.nixos.passwd=*)
          set -- $(IFS==; echo $o)
          echo "nixos:$2" | ${pkgs.shadow}/bin/chpasswd
          ;;
      esac
    done

    echo Extracting Asahi firmware...
    mkdir -p /tmp/.fwsetup/{esp,extracted}

    mount /dev/disk/by-partuuid/`cat /proc/device-tree/chosen/asahi,efi-system-partition` /tmp/.fwsetup/esp
    ${asahi-fwextract}/bin/asahi-fwextract /tmp/.fwsetup/esp/asahi /tmp/.fwsetup/extracted
    umount /tmp/.fwsetup/esp

    pushd /tmp/.fwsetup/
    cat /tmp/.fwsetup/extracted/firmware.cpio | ${pkgs.cpio}/bin/cpio -id --quiet --no-absolute-filenames
    mkdir -p /lib/firmware
    mv vendorfw/* /lib/firmware
    popd
    rm -rf /tmp/.fwsetup
  '';

  hardware.asahi.extractPeripheralFirmware = false;

  isoImage.squashfsCompression = "zstd -Xcompression-level 6";

  networking.wireless.enable = false;

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
}
