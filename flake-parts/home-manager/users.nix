{ inputs, self, lib, ... }:
{
  perSystem = { pkgs, ... }:
    let
      activationPackages = builtins.mapAttrs (_: lib.getAttr "activationPackage") self.homeConfigurations;
    in
    {
      homeConfigurations.willem = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          self.homeManagerModules.profiles-user-willem
        ];
        extraSpecialArgs = {
          inherit pkgs;
          nurNoPkgs = import inputs.nur {
            nurpkgs = pkgs;
            pkgs = throw "nixpkgs eval";
          };
        };
      };
#      packages = lib.pipe activationPackages [
 #       (lib.filterAttrs (_: drv: pkgs.system == drv.system))
  #      (lib.mapAttrs' (username: lib.nameValuePair "home-${username}"))
   #   ];
    };
}
