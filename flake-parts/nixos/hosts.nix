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
      ];

      nixpkgs.overlays = builtins.attrValues self.overlays;
      nixpkgs.config.allowUnfree = true;
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

    nixosConfigurations.zeusvm = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        self.nixosModules.base
        self.nixosModules.willem-home
        ../../nixos/hosts/zeus.utmvm.nix
      ];
    };

    nixosConfigurations.zeusasahi = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        self.nixosModules.appleSilicon
        self.nixosModules.base
        self.nixosModules.willem-home
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
      specialArgs = {inherit inputs;};
    };
  };
}
