{
  description = "Willem's Home Manager configuration";

  inputs = {
    nixpkgs-willem.url = "git+file:///Users/willem/dev/nixpkgs";
    #nixpkgs-willem.url = "github:willemml/nixpkgs/master";
    nixpkgs-22_11.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-22_11";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    { self, nixpkgs-willem, nixpkgs-unstable, nixpkgs-22_11, home-manager, nur, ... }@inputs:
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

      pkgsCustom = import nixpkgs-willem {
        inherit system;
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
        modules = [ nur.hmModules.nur ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { inherit nurNoPkgs pkgsCustom; };
      };
    };
}
