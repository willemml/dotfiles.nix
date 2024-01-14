{globals, ...}: {
  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = globals.zerotier.networks;
}
