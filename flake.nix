{
  description = "Willem's Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin.url = "github:willemml/nix-darwin?ref=feat/networking.hosts";
    #darwin.url = "git+file:///Users/willem/dev/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    fenix.url = "github:nix-community/fenix";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    nix-github-actions.inputs.nixpkgs.follows = "nixpkgs";
    nix-github-actions.url = "github:nix-community/nix-github-actions";

    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";

    nixos-apple-silicon.inputs.nixpkgs.follows = "nixpkgs";
    nixos-apple-silicon.url = "github:tpwrules/nixos-apple-silicon";

    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nixd.url = "github:nix-community/nixd";
    nixd.inputs.nixpkgs.follows = "nixpkgs";
    nixd.inputs.flake-parts.follows = "flake-parts";
  };

  outputs = {
    darwin,
    nixpkgs,
    self,
    ...
  } @ inputs: let
    globals = import ./common/globals.nix;
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} rec {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
        "aarch64-linux"
      ];

      flake = let
        mkSystem = type: system: definition: (type {
          inherit system;
          specialArgs = {
            inherit inputs globals;
            overlays = self.overlays;
          };
          modules = definition;
        });

        mkNixos = arch: (mkSystem nixpkgs.lib.nixosSystem "${arch}-linux");
        mkDarwin = arch: (mkSystem darwin.lib.darwinSystem "${arch}-darwin");

        forAllSystems = nixpkgs.lib.genAttrs systems;
      in rec {
        overlays = {
          default = import ./packages;
          fenix = inputs.fenix.overlays.default;
        };

        nixosConfigurations = {
          x86_64-live = mkNixos "x86_64" [./nixos/hosts/x86_64-live.nix];
          aarch64-live = mkNixos "aarch64" [./nixos/hosts/aarch64-live.nix];

          glassbox = mkNixos "x86_64" [./nixos/hosts/glassbox.nix];
          nixbox = mkNixos "x86_64" [./nixos/hosts/nixbox.nix];
          thinkpad = mkNixos "x86_64" [./nixos/hosts/thinkpad.nix];
          voyager = mkNixos "aarch64" [./nixos/hosts/voyager];

          darwin-arm-minimal-vm = mkNixos "aarch64" [./nixos/hosts/vms/aarch64-darwin-host/minimal.nix];
          darwin-arm-homeconsole-vm = mkNixos "aarch64" [./nixos/hosts/vms/aarch64-darwin-host/home-console.nix];
        };

        darwinConfigurations.zeus = mkDarwin "aarch64" [./nixos/hosts/zeus.nix];

        packages = {
          aarch64-darwin = {
            minimal-vm = self.nixosConfigurations.darwin-arm-minimal-vm.config.system.build.vm;
            homeconsole-vm = self.nixosConfigurations.darwin-arm-homeconsole-vm.config.system.build.vm;
            default = self.darwinConfigurations.zeus.config.system.build.toplevel;
          };
        };
      };

      perSystem = {
        system,
        self',
        pkgs,
        lib,
        ...
      }: {
        checks.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
          };
        };

        devShells.default = pkgs.mkShell {
          inherit (self'.checks.pre-commit-check) shellHook;
        };

        formatter = pkgs.alejandra;
      };
    };
}
