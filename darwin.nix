{ config, pkgs, lib, inputs, ... }:

{
  imports = [ ./launchd.nix ./apps.nix ];

  targets.darwin = {
    defaults = {
      "com.googlecode.iterm2" = import ./iterm2.nix;
    };
  };
}
