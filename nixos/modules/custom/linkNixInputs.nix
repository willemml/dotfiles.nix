# https://github.com/LnL7/nix-darwin/issues/277#issuecomment-992866471
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.nix;

  nixRegistry = builtins.mapAttrs (name: value: {flake = value;}) inputs;
  etcNixInputs =
    pkgs.runCommandNoCC "etc-nix-inputs"
    {
      inputNames = builtins.attrNames inputs;
      inputPaths = builtins.map (x: x.outPath) (builtins.attrValues inputs);
    } ''
      mkdir -p $out
      inputNames=($inputNames)
      inputPaths=($inputPaths)
      for (( i=0; i<''${#inputNames[@]}; i++)); do
        source=''${inputPaths[$i]}
        name=''${inputNames[$i]}
        if [[ -f $source/default.nix ]]; then
          ln -s $source $out/$name
        fi
      done
    '';
in
  # Based on flake-utils-plus#nixosModules.autoGenFromInputs
  # https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/master/lib/options.nix
  #
  # We're not using that directly because we don't need the rest of the flake, and to work around
  # https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/105 and
  # https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/107
  {
    options = {
      nix.generateNixPathFromInputs = mkOption {
        type = types.bool;
        description = ''
          If set, NIX_PATH will be generated from available inputs.
          This requires `nix.linkInputs` to be enabled, and setting this will default
          `nix.linkInputs` to true.
        '';
        default = false;
        example = true;
      };
      nix.generateRegistryFromInputs = mkOption {
        type = types.bool;
        description = ''
          If set, the system Nix registry will be generated from available inputs.
          Otherwise, the registry will still include the `self` flake.
        '';
        default = false;
        example = true;
      };
      nix.linkInputs = mkOption {
        type = types.bool;
        description = "If set, inputs will be symlinked into /etc/nix/inputs.";
        example = true;
      };
    };

    config = {
      assertions = [
        {
          assertion = cfg.generateNixPathFromInputs -> cfg.linkInputs;
          message = "nix.generateNixPathFromInputs requires nix.linkInputs";
        }
      ];

      nix.linkInputs = mkDefault cfg.generateNixPathFromInputs;

      nix.registry =
        if cfg.generateRegistryFromInputs
        then nixRegistry
        else {self.flake = inputs.self;};

      environment.etc."nix/inputs" = mkIf cfg.linkInputs {
        source = etcNixInputs;
      };

      nix.nixPath = mkIf cfg.generateNixPathFromInputs ["/etc/nix/inputs"];
    };
  }
