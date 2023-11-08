{
  modulesPath,
  lib,
  ...
}: {
  imports = [
    "${modulesPath}/virtualisation/qemu-vm.nix"
  ];

  console.keyMap = lib.mkDefault "colemak";

  security.sudo.wheelNeedsPassword = false;

  boot.initrd.kernelModules = ["virtio_balloon" "virtio_console" "virtio_rng"];
  boot.initrd.availableKernelModules = ["virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio"];
}
