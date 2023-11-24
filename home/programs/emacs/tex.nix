{
  pkgs,
  lib,
  ...
}: {
  programs.emacs = {
    orgTexConfigFile = ./org-tex-cfg.el;
    enableOrgTex = lib.mkDefault false;

    texEmacsPackages = epkgs: (let
      org-auctex = epkgs.trivialBuild rec {
        pname = "org-auctex";
        version = "e1271557b9f36ca94cabcbac816748e7d0dc989c";

        buildInputs = [epkgs.auctex];

        src = pkgs.fetchFromGitHub {
          owner = "karthink";
          repo = pname;
          rev = version;
          sha256 = "sha256-cMAhwybnq5HA1wOaUqDPML3nnh5m1iwEETTPWqPbAvw=";
        };
      };
    in (with epkgs; [
      org-auctex
      auctex
      cdlatex
      citeproc
      graphviz-dot-mode
      ivy-bibtex
      gnuplot
      htmlize
      org-auctex
      org-contrib
      org-download
      pdf-tools
      plantuml-mode
    ]));

    texPackages = let
      aspellPackage = pkgs.aspellWithDicts (d: [d.en d.en-science d.en-computers d.fr]);
      texliveset = pkgs.texlive.combine {
        inherit
          (pkgs.texlive)
          scheme-basic
          babel
          amscls
          amsmath
          biber
          biblatex
          biblatex-mla
          block
          cancel
          caption
          capt-of
          csquotes
          enotez
          enumitem
          etex
          etoolbox
          fancyhdr
          float
          fontaxes
          graphics
          hanging
          hyperref
          latex
          latexindent
          latexmk
          logreq
          metafont
          mlacls
          newtx
          pdflscape
          pdfpages
          preprint
          psnfss
          ragged2e
          titlesec
          tools
          translations
          ulem
          url
          wrapfig
          xstring
          xkeyval
          ;
      };
    in
      with pkgs; [
        texliveset
        aspellPackage
        gnuplot
        plantuml
      ];
  };
}
