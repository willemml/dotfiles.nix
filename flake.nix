{
  description = "Willem's Darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, nur, ... }:
    let
      pkgsfunc = (system: import nixpkgs {
        inherit system;
        overlays = [
          (import ./overlays)
        ];
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

          pkgs = pkgsfunc system;

          modules = [
            ./modules/nix.nix
            ./system/darwin.nix
            home-manager.darwinModules.home-manager
            (user-config pkgs)
          ];
        };
      };
      nixosConfigurations.zeus-utm-vm = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";

        pkgs = pkgsfunc system;

        specialArgs = { inherit inputs; };

        modules = [
          ./modules/nix.nix
          ./system/utm-arm-vm.nix
          home-manager.nixosModules.home-manager
          (user-config pkgs)
        ];
      };
    };
}
