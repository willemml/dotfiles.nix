_final: prev: {
  org-auctex = prev.callPackage ./org-auctex.nix {};
  darwin-zsh-completions = prev.callPackage ./darwin-zsh-completions.nix {};
}
