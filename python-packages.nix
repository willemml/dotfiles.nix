{ pkgs }:

pkgs.python310.withPackages (p: with p; [ matplotlib latexify-py ])
