My dotfiles using Nix. System configuration done using [nix-darwin](https://github.com/LnL7/nix-darwin) and
[NixOS](https://nixos.org/). User configuration using [home-manager](https://github.com/nix-community/home-manager). This repo is put
together as a flake using [flake-parts](https://github.com/hercules-ci/flake-parts). On NixOS home-manager is used
as a NixOS module, on Darwin it is used separately from nix-darwin.

dotfiles.nix is inspired by [terlar/nix-config](https://github.com/terlar/nix-config/tree/main), [~rycee/configurations](https://sr.ht/~rycee/configurations/)
and [hlissner/dotfiles](https://github.com/hlissner/dotfiles).

All Nix code in this repo is formatted using [alejandra](https://github.com/kamadorueda/alejandra).


# Usage

Show what this flake provides:

    nix flake show

Switch both system (NixOS) and home:

    nixos-rebuild switch --flake .

Switch system (nix-darwin):

    darwin-rebuild switch --flake .

Switch home only (on Darwin):

    nix run .#home

Build home without switching:

    nix build .#home

Update all inputs:

    nix flake update --commit-lock-file

Update a single input:

    nix flake lock --update-input nixpkgs --commit-lock-file

Format all nix files:

    nix fmt

Enter the dev shell (if not using [nix-direnv](https://github.com/nix-community/nix-direnv)):

    nix develop


# Tasks


## TODO Services as modules

Services should be converted to modules.
These should ideally support both linux and darwin hosts (launchd and systemd).

