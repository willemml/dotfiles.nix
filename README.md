My dotfiles using Nix. System configuration done using [nix-darwin](https://github.com/LnL7/nix-darwin) and
[NixOS](https://nixos.org/). User configuration using [home-manager](https://github.com/nix-community/home-manager). 
This repo is put together as a flake using [flake-parts](https://github.com/hercules-ci/flake-parts).

All Nix code in this repo is formatted using [alejandra](https://github.com/kamadorueda/alejandra).

# Usage

Switch both system (NixOS) and home:

    nixos-rebuild switch --flake .

Switch system (nix-darwin):

    darwin-rebuild switch --flake .

Update all inputs:

    nix flake update --commit-lock-file

Update a single input:

    nix flake lock --update-input nixpkgs --commit-lock-file

Format all nix files:

    nix fmt

Enter the dev shell (if not using [nix-direnv](https://github.com/nix-community/nix-direnv)):

    nix develop

