{
  description = "Willem's Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    nixos-apple-silicon.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs@{ self, darwin, flake-utils, home-manager, mach-nix, nixos-apple-silicon, nixpkgs, nur, ... }:
    let
      pkgsfunc = ({ system, overlays ? [ ] }: import nixpkgs
        {
          inherit system;
          overlays = [ (import ./overlays) ] ++ overlays;
          config = {
            allowUnfree = true;
            packageOverrides = pkgs: {
              nur = import nur { inherit pkgs; nurpkgs = pkgs; };
            };
          };
        });

      user-config = (pkgs: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit pkgs;
          nurNoPkgs = import nur {
            nurpkgs = pkgs;
            pkgs = throw "nixpkgs eval";
          };
        };
        home-manager.sharedModules = [ nur.hmModules.nur ];
        home-manager.users.willem = ./home;
      });
    in
    {
      darwinConfigurations = {
        zeus = darwin.lib.darwinSystem rec {
          inherit inputs;

          system = "aarch64-darwin";

          pkgs = pkgsfunc {
            inherit system;
            overlays = [ (import ./overlays/darwin.nix) ];
          };

          modules = [
            ./modules/nix.nix
            ./system/zeus.darwin.nix
            ./system/common.nix
            home-manager.darwinModules.home-manager
            (user-config pkgs)
          ];
        };
      };

      nixosConfigurations.zeus-utmvm = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";

        pkgs = pkgsfunc { inherit system; };

        specialArgs = { inherit inputs; };

        modules = [
          home-manager.nixosModules.home-manager
          (user-config pkgs)
          ./modules/nix.nix
          ./system/zeus.utmvm.nix
        ];
      };

      nixosConfigurations.zeus-asahi = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";

        pkgs = pkgsfunc {
          inherit system;
          overlays = [ nixos-apple-silicon.overlays ];
        };

        specialArgs = { inherit inputs; };

        modules = [
          nixos-apple-silicon.nixosModules.apple-silicon-support
          home-manager.nixosModules.home-manager
          (user-config pkgs)
          ./modules/nix.nix
          ./system/zeus.asahi.nix
        ];
      };
    };
}
