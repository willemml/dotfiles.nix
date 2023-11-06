{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.base = {config, ...}: {
      imports = [
        ../../nixos/profiles/common.nix
        ../../nixos/profiles/linux/base.nix
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.home-manager-integration
        self.nixosModules.nixpkgs-useFlakeNixpkgs
      ];

      nixpkgs.overlays = builtins.attrValues self.overlays;
      nixpkgs.config.allowUnfree = true;

      home-manager.users.willem = self.homeManagerModules.user-willem-linux;
    };

    darwinModules.base = {config, ...}: {
      imports = [
        ../../nixos/profiles/common.nix
        inputs.home-manager.darwinModules.home-manager
        self.nixosModules.linkNixInputs
        self.nixosModules.home-manager-integration
        self.nixosModules.nix-useCachix
        self.nixosModules.nixpkgs-useFlakeNixpkgs
      ];

      nixpkgs.overlays = builtins.attrValues self.overlays;
      nixpkgs.config.allowUnfree = true;

      home-manager.users.willem = self.homeManagerModules.user-willem-darwin;
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

    nixosConfigurations.m1-installer-live = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        self.nixosModules.appleSilicon
        self.nixosModules.base
        ../../nixos/hosts/live.nix
        ../../nixos/hosts/asahi-live.nix
      ];
    };

    nixosConfigurations.arm-live = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        self.nixosModules.base
        ../../nixos/hosts/live.nix
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
