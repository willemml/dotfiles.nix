{
  pkgs,
  lib,
  ...
}: {
  programs.emacs = {
    earlyInitFile = ./early-init.el;
    initFile = ./init.el;

    enable = true;

    package = pkgs.emacs29-nox;

    extraPackages = epkgs:
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
      in [
        all-the-icons
        all-the-icons-dired
        company-mode
        counsel
        dash
        editorconfig
        edit-indirect
        f
        flycheck
        format-all
        ivy
        magit
        magit-section
        meow
        nix-mode
        nix-update
        org
        org-modern
        pinentry
        polymode
        poly-org
        rustic
        s
        separedit
        swiper
        yasnippet
      ])
      ++ (with pkgs; [
        sqlite
      ]);
  };

  services.emacs = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    client.enable = true;
    startWithUserSession = true;
  };
}
