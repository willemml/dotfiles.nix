{ self, inputs, ... }: {
  flake = {
    nixosModules.base = { config, ... }: {
      imports = [
        ../../nixos/profiles/common.nix
        ../../nixos/profiles/linux-common.nix
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.default
        self.nixosModules.home-manager-integration
        self.nixosModules.nixpkgs-useFlakeNixpkgs
      ];

      nixpkgs.overlays = builtins.attrValues self.overlays;
      nixpkgs.config.allowUnfree = true;
    };

    darwinModules.base = { config, ... }: {
      imports = [
        ../../nixos/profiles/common.nix
        inputs.home-manager.darwinModules.home-manager
        self.nixosModules.custom-linkNixInputs
        self.nixosModules.home-manager-integration
      ];

      nixpkgs.overlays = builtins.attrValues self.overlays;
      nixpkgs.config.allowUnfree = true;
    };

    nixosConfigurations.zeusvm = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        self.nixosModules.base
        ../../nixos/hosts/zeus.utmvm.nix
      ];
    };

    nixosConfigurations.zeusasahi = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        self.nixosModules.appleSilicon
        self.nixosModules.base
        ../../nixos/hosts/zeus.asahi.nix
      ];

    };

    darwinConfigurations.zeus = inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        self.darwinModules.base
        ../../nixos/hosts/zeus.darwin.nix
      ];
    };
  };
}