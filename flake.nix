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

  outputs = inputs@{ nixpkgs, home-manager, darwin, nur, ... }:
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
  in {
    homeConfigurations.willem = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [ nur.hmModules.nur ./home ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = { inherit nurNoPkgs; inputs = { inherit (inputs); }; };
    };
    # darwinConfigurations = {
      #   hostname = darwin.lib.darwinSystem {
        #     inherit system (inputs);
        #     modules = [
          #       ./system
          #       home-manager.darwinModules.home-manager {
            #         home-manager.useGlobalPkgs = true;
            #         home-manager.useUserPackages = true;
            #         home-manager.users.willem = import ./home;

            #         extraSpecialArgs = { inherit (inputs) nurNoPkgs; };
            #       }
            #     ];
            #   };
            # };
  };
}
