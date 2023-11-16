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

    nix-github-actions.inputs.nixpkgs.follows = "nixpkgs";
    nix-github-actions.url = "github:nix-community/nix-github-actions";

    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";

    nixos-apple-silicon.inputs.nixpkgs.follows = "nixpkgs";
    nixos-apple-silicon.url = "github:tpwrules/nixos-apple-silicon";

    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
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
      in {
        overlays = {
          default = import ./packages;
          fenix = inputs.fenix.overlays.default;
          emacs = inputs.emacs-overlay.overlays.default;
        };

        nixosConfigurations = {
          x86_64-live = mkNixos "x86_64" [./nixos/hosts/x86_64-live.nix];
          aarch64-live = mkNixos "aarch64" [./nixos/hosts/aarch64-live.nix];

          nixbox = mkNixos "x86_64" [./nixos/hosts/nixbox.nix];
          thinkpad = mkNixos "x86_64" [./nixos/hosts/thinkpad.nix];

          darwin-arm-minimal-vm = mkNixos "aarch64" [./nixos/hosts/vms/aarch64-darwin-host/minimal.nix];
          darwin-arm-homeconsole-vm = mkNixos "aarch64" [./nixos/hosts/vms/aarch64-darwin-host/home-console.nix];
        };

        darwinConfigurations.zeus = mkDarwin "aarch64" [./nixos/hosts/zeus.nix];

        packages = {
          aarch64-darwin = {
            minimal-vm = self.nixosConfigurations.darwin-arm-minimal-vm.config.system.build.vm;
            homeconsole-vm = self.nixosConfigurations.darwin-arm-homeconsole-vm.config.system.build.vm;
          };

          x86_64-linux.live-image = self.nixosConfigurations.x86_64-live.config.system.build.isoImage;
          aarch64-linux.live-image = self.nixosConfigurations.x86_64-live.config.system.build.isoImage;
        };

        githubActions = nix-github-actions.lib.mkGithubMatrix {
          checks.x86_64-linux = {
            nixbox = self.nixosConfigurations.nixbox.config.system.build.toplevel;
            thinkpad = self.nixosConfigurations.thinkpad.config.system.build.toplevel;
            pre-commit-check = self.checks.x86_64-linux.pre-commit-check;
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
