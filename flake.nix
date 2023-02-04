{
  description = "Willem's Home Manager configuration";

  inputs = {
    nixpkgs-22_11.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-22_11";
    };
    nurrepo.url = "github:nix-community/NUR";
  };

  outputs =
    { self, nixpkgs-unstable, nixpkgs-22_11, home-manager, nurrepo, ... }@inputs:
    let
      system = "aarch64-darwin";

      pkgs = import nixpkgs-22_11 {
        inherit system;
        overlays = [
          (final: prev: {
            nixpkgs-unstable = import nixpkgs-unstable {
              inherit system;
               overlays = [ ];
             };
           })
        ];
      };

      nur = import nurrepo {
        nurpkgs = pkgs;
        pkgs = pkgs;
      };

      nurNoPkgs = import nurrepo {
        nurpkgs = pkgs;
        pkgs = throw "nixpkgs eval";
      };
    in {
      homeConfigurations.willem = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ nurrepo.hmModules.nur ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { inherit nur nurNoPkgs; };
      };
    };
}
