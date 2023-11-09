{...}: {
  imports = [
    ../../../modules/users/willem/vm.nix
    ../../../modules/vm/headless.nix
    ../../../modules/vm/aarch64-darwin-host.nix
    ../../../profiles/default.nix
  ];
}
