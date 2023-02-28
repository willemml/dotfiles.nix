self: super: {
  tree-sitter-grammars = super.tree-sitter-grammars // {
    tree-sitter-python = super.tree-sitter-grammars.tree-sitter-python.overrideAttrs (_: {
      nativeBuildInputs = [ super.nodejs super.tree-sitter ];
      configurePhase = ''
        tree-sitter generate --abi 13 src/grammar.json
      '';
    });
  };
  org-auctex = super.callPackage ./org-auctex.nix { pkgs = super; };
}
