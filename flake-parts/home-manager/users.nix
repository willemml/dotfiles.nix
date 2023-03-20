{
  inputs,
  self,
  lib,
  ...
}: {
  flake = {
    homeManagerModules.user-willem = {
      imports = [
        self.homeManagerModules.default
        self.homeManagerModules.nixpkgs-useFlakeNixpkgs
        self.homeManagerModules.nixpkgs-config
      ];

      home.username = "willem";
      home.stateVersion = "22.11";
    };

    homeManagerModules.user-willem-darwin = {
      imports = [
        self.homeManagerModules.darwin
        self.homeManagerModules.user-willem
      ];

      home.homeDirectory = "/Users/willem";
    };

    homeManagerModules.user-willem-linux = {
      imports = [self.homeManagerModules.user-willem];

      home.homeDirectory = "/home/willem";
    };
  };

  perSystem = {
    pkgs,
    self',
    system,
    ...
  }: rec {
    homeConfigurations.willem = let
      systemType =
        if pkgs.stdenv.isDarwin
        then "darwin"
        else "linux";
    in
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [self.homeManagerModules."user-willem-${systemType}"];
      };
    packages = let
      activationPackages = builtins.mapAttrs (_: lib.getAttr "activationPackage") homeConfigurations;
    in
      lib.pipe activationPackages [
        (lib.filterAttrs (_: drv: pkgs.system == drv.system))
        (lib.mapAttrs' (username: lib.nameValuePair "home-${username}"))
      ];
  };
}
