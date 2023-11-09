{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.base = {...}: {
      imports = [
        ../../nixos/profiles/common.nix
        ../../nixos/profiles/linux/base.nix
        self.nixosModules.useFlakeNixpkgs
        self.nixosModules.users-willem
        inputs.nix-index-database.nixosModules.nix-index
      ];

      nixpkgs.overlays = builtins.attrValues self.overlays;
      nixpkgs.config.allowUnfree = true;
    };

    nixosModules.darwinArmVM = {...}: {
      virtualisation.host.pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
    };

    nixosModules.willem-home = {...}: {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.homeManagerIntegration
      ];
      home-manager.users.willem = self.homeManagerModules.user-willem-linux;
    };

    darwinModules.base = {...}: {
      imports = [
        ../../nixos/profiles/common.nix
        self.nixosModules.linkNixInputs
        self.nixosModules.useFlakeNixpkgs
      ];

      nixpkgs.overlays = builtins.attrValues self.overlays;
      nixpkgs.config.allowUnfree = true;
    };

    nixosConfigurations.winbox = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.nixosModules.base
        self.nixosModules.willem-home
        ../../nixos/hosts/nixbox.nix
      ];

      specialArgs = {inherit inputs;};
    };

    nixosConfigurations.arm-live = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        self.nixosModules.base
        ../../nixos/hosts/live.nix
      ];
      specialArgs = {inherit inputs;};
    };

    nixosConfigurations.darwinArmMinimalVM = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        self.nixosModules.users-willemVm
        self.nixosModules.base
        self.nixosModules.headlessVm
        self.nixosModules.darwinArmVM
      ];
      specialArgs = {inherit inputs;};
    };

    darwinConfigurations.zeus = inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        self.darwinModules.base
        ../../nixos/hosts/zeus.darwin.nix
      ];
      specialArgs = {inherit inputs;};
    };

    packages.aarch64-darwin.minimalVM = self.nixosConfigurations.darwinArmMinimalVM.config.system.build.vm;
  };
}
