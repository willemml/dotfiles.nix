{ withSystem, ... }:
{
  flake = {
    packages.aarch64-darwin.test = (withSystem "aarch64-darwin" ({ pkgs, ... }: pkgs.writeScriptBin "runme" ''
      	  echo "I am currently being run!"
    ''));
  };

}
