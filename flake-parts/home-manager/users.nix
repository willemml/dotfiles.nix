{ inputs, self, lib, ... }:
{
  flake = {
    homeManagerModules.nixpkgsConfig = {
      nixpkgs.config.allowUnfreePredicate = lib.const true;
      nixpkgs.config.packageOverrides = pkgs: {
        nur = import inputs.nur { inherit pkgs; nurpkgs = pkgs; };
      };
      nixpkgs.config.allowUnsupportedSystem = true;
      nixpkgs.overlays = builtins.attrValues self.overlays;
    };
    testOutput = builtins.attrValues self.overlays;
  };
  perSystem = { pkgs, self', ... }:
    rec {
      homeConfigurations.willem = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          self.homeManagerModules.nixpkgs-useFlakeNixpkgs
          self.homeManagerModules.nixpkgsConfig
          self.homeManagerModules.profiles-user-willem
        ];
        extraSpecialArgs = {
          nurNoPkgs = import inputs.nur {
            nurpkgs = pkgs;
            pkgs = throw "nixpkgs eval";
          };
        };
      };
      packages =
        let activationPackages = builtins.mapAttrs (_: lib.getAttr "activationPackage") homeConfigurations;
        in
        lib.pipe activationPackages [
          (lib.filterAttrs (_: drv: pkgs.system == drv.system))
          (lib.mapAttrs' (username: lib.nameValuePair "home-${username}"))
        ];
    };
}
