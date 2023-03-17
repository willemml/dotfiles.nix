{ inputs, self, lib, ... }:
{
  perSystem = { pkgs, self', ... }:
    rec {
      homeConfigurations.willem = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules =
          let
            nurNoPkgs = (import inputs.nur { pkgs = null; nurpkgs = pkgs; });
          in
          [
            self.homeManagerModules.nixpkgs-useFlakeNixpkgs
            self.homeManagerModules.nixpkgs-Config
            self.homeManagerModules.default
          ];
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
