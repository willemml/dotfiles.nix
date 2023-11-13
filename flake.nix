{
  description = "Willem's Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin.url = "github:willemml/nix-darwin?ref=feat/networking.hosts";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    fenix.url = "github:nix-community/fenix";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager.url = "github:willemml/home-manager?ref=feat/programs.hishtory";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    nixos-apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    nixos-apple-silicon.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-github-actions.url = "github:nix-community/nix-github-actions";
    nix-github-actions.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    darwin,
    flake-parts,
    home-manager,
    nix-github-actions,
    nixpkgs,
    pre-commit-hooks,
    self,
    ...
  } @ inputs: let
    globals = import ./common/globals.nix;
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} rec {
      imports = [
        ./flake/home-manager.nix
        ./flake/overlays.nix
      ];

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
          modules = [definition];
        });

        mkNixos = arch: (mkSystem nixpkgs.lib.nixosSystem "${arch}-linux");
        mkDarwin = arch: (mkSystem darwin.lib.darwinSystem "${arch}-darwin");

        mkHome = system: config: (home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit globals inputs;
            overlays = self.overlays;
          };
          modules = [
            {nix.package = nixpkgs.legacyPackages.${system}.nix;}
            config
          ];
        });
        forAllSystems = nixpkgs.lib.genAttrs systems;
      in {
        nixosConfigurations.x86_64-live = mkNixos "x86_64" ./nixos/hosts/x86_64-live.nix;
        nixosConfigurations.aarch64-live = mkNixos "aarch64" ./nixos/hosts/aarch64-live.nix;

        nixosConfigurations.nixbox = mkNixos "x86_64" ./nixos/hosts/nixbox.nix;

        nixosConfigurations.darwin-arm-minimal-vm = mkNixos "aarch64" ./nixos/hosts/vms/aarch64-darwin-host/minimal.nix;
        nixosConfigurations.darwin-arm-homeconsole-vm = mkNixos "aarch64" ./nixos/hosts/vms/aarch64-darwin-host/home-console.nix;

        darwinConfigurations.zeus = mkDarwin "aarch64" ./nixos/hosts/zeus.nix;

        homeConfigurations = forAllSystems (system: {
          willem = mkHome system ./home/${builtins.replaceStrings ["aarch64-" "x86_64-"] ["" ""] system}/default.nix;
        });

        packages.aarch64-darwin.minimal-vm = self.nixosConfigurations.darwin-arm-minimal-vm.config.system.build.vm;
        packages.aarch64-darwin.homeconsole-vm = self.nixosConfigurations.darwin-arm-homeconsole-vm.config.system.build.vm;

        packages.x86_64-linux.live-image = self.nixosConfigurations.x86_64-live.config.system.build.isoImage;
        packages.aarch64-linux.live-image = self.nixosConfigurations.x86_64-live.config.system.build.isoImage;

        githubActions = nix-github-actions.lib.mkGithubMatrix {
          checks.x86_64-linux = {
            nixbox = self.nixosConfigurations.nixbox.config.system.build.toplevel;
            pre-commit-check = self.checks.x86_64-linux.pre-commit-check;
          };
          checks.x86_64-darwin = {
            home = self.checks.x86_64-darwin.home;
            system = (mkDarwin "x86_64" ./nixos/hosts/zeus.nix).config.system.build.toplevel;
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

        checks.home = self'.packages.home;

        packages.home = self.homeConfigurations.${system}.willem.activationPackage;

        devShells.default = pkgs.mkShell {
          inherit (self'.checks.pre-commit-check) shellHook;
        };

        formatter = pkgs.alejandra;
      };
    };
}
