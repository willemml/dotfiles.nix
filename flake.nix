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
    system = "aarch64-darwin";

    pkgs = import nixpkgs {
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
    };

    nurNoPkgs = import nur {
      nurpkgs = pkgs;
      pkgs = throw "nixpkgs eval";
    };

    home-manager-config = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit nurNoPkgs pkgs; inputs = { inherit (inputs); }; };
      home-manager.sharedModules = [ nur.hmModules.nur ];
      home-manager.users.willem = ./home;
      users.users.willem = {
        home = "/Users/willem";
        isHidden = false;
        name = "willem";
        shell = pkgs.zshInteractive;
      };
    };
  in {
    darwinConfigurations = {
      zeus = darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./system/darwin.nix
          home-manager.darwinModules.home-manager
          home-manager-config
        ];
      };
    };
  };
}
