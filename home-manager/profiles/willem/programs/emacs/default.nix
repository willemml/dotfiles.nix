{
  config,
  pkgs,
  ...
}: let
  emacsPackage =
    (pkgs.emacsPackagesFor pkgs.emacs29).emacsWithPackages
    (epkgs:
      (with epkgs; let
        company-mode = epkgs.trivialBuild rec {
          pname = "company-mode";
          version = "7c24dc8668af5aea8a5d07aeceda5fac7a2a85b5";

          src = pkgs.fetchFromGitHub {
            owner = pname;
            repo = pname;
            rev = version;
            sha256 = "sha256-6aX2S4cUop1rdxweIF5f1qrgNmYd1mtWgT9T1Q1s2h8=";
          };
        };
        lean4-mode = epkgs.trivialBuild rec {
          pname = "lean4-mode";
          version = "d1c936409ade7d93e67107243cbc0aa55cda7fd5";

          buildInputs = [epkgs.dash epkgs.f epkgs.magit-section epkgs.lsp-mode epkgs.s epkgs.flycheck];

          postInstall = ''
            cp -r data $out/share/emacs/site-lisp/data
          '';

          src = pkgs.fetchFromGitHub {
            owner = "leanprover";
            repo = pname;
            rev = version;
            sha256 = "sha256-tD5Ysa24fMIS6ipFc50OjabZEUge4riSb7p4BR05ReQ=";
          };
        };
      in [
        all-the-icons
        all-the-icons-dired
        company-mode
        company-sourcekit
        counsel
        dash
        editorconfig
        edit-indirect
        f
        flycheck
        format-all
        ivy
        lean4-mode
        lsp-mode
        lua-mode
        magit
        magit-section
        meow
        nix-mode
        nix-update
        org
        org-modern
        polymode
        poly-org
        rustic
        s
        separedit
        solarized-theme
        swift-mode
        swiper
        yasnippet
      ])
      ++ (with pkgs; [
        sqlite
      ]));
in {
  home.file.".emacs.d/early-init.el".source = ./early-init.el;
  home.file.".emacs.d/init.el".source = ./init.el;

  programs.emacs.enable = true;

  programs.emacs.package = emacsPackage;

  services.emacs = pkgs.lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    client.enable = true;
    startWithUserSession = true;
  };
}
