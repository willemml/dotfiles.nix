{
  config,
  pkgs,
  ...
}: let
  aspellPackage = pkgs.aspellWithDicts (d: [d.en d.en-science d.en-computers d.fr]);
  emacsPackage =
    (pkgs.emacsPackagesFor pkgs.emacs29).emacsWithPackages
    (epkgs:
      (with epkgs; let
        company-mode = epkgs.trivialBuild {
          pname = "company-mode";
          version = "4203cfb";

          src = pkgs.fetchFromGitHub {
            owner = "company-mode";
            repo = "company-mode";
            rev = "4203cfbe1303ca86e61ffa31cb88d75782dbb893";
            sha256 = "sha256-wj0vXlVkNEA1gD1oT3phzK5Dr/LNkiE2oRzzRmLE+20=";
          };
        };
        mu4e = epkgs.trivialBuild {
          pname = "mu4e";
          version = pkgs.mu.version;

          src = "${pkgs.mu}/share/emacs/site-lisp/mu4e";
        };
        mu4e-accounts = epkgs.trivialBuild {
          pname = "mu4e-accounts";
          version = "0.1";
          buildInputs = [pkgs.mu];
          src = let
            smtpConfig = name: (
              let
                account = config.accounts.email.accounts.${name};
                port = builtins.toString account.smtp.port;
                host = account.smtp.host;
              in ''
                ("${name}"
                     (mu4e-drafts-folder "/${name}/${account.folders.drafts}")
                     (mu4e-sent-folder "/${name}/${account.folders.sent}")
                     (mu4e-trash-folder "/${name}/${account.folders.trash}")
                     ; (mu4e-maildir-shortcuts
                     ;   '( (:maildir "/${name}/${account.folders.inbox}"  :key ?i)
                     ;      (:maildir "/${name}/${account.folders.sent}"   :key ?s)
                     ;      (:maildir "/${name}/${account.folders.drafts}" :key ?d)
                     ;      (:maildir "/${name}/${account.folders.trash}"  :key ?t)))
                     (smtpmail-default-smtp-server "${host}")
                     (smtpmail-smtp-server "${host}")
                     (smtpmail-smtp-service ${port} )
                     ${
                  if account.flavor == "gmail.com"
                  then "(mu4e-sent-messages-behavior 'delete)"
                  else ""
                }
                     (smtpmail-smtp-user "${account.userName}")
                     (user-mail-address "${account.address}"))
              ''
            );
            smtpAccountStrings = pkgs.lib.forEach (builtins.attrNames config.accounts.email.accounts) (account: " ${(smtpConfig account)} ");
            smtpAccounts = "'( ${pkgs.lib.concatStrings smtpAccountStrings} )";
          in
            pkgs.writeText "mu4e-accounts.el" ''
              (defvar my-mu4e-account-alist ${smtpAccounts} )
              (provide 'mu4e-accounts)
            '';
        };
        org-auctex = epkgs.trivialBuild {
          pname = "org-auctex";
          version = "e1271557b9f36ca94cabcbac816748e7d0dc989c";

          buildInputs = [epkgs.auctex];

          src = pkgs.fetchFromGitHub {
            owner = "karthink";
            repo = "org-auctex";
            rev = "e1271557b9f36ca94cabcbac816748e7d0dc989c";
            sha256 = "sha256-cMAhwybnq5HA1wOaUqDPML3nnh5m1iwEETTPWqPbAvw=";
          };
        };
        rustic = epkgs.rustic.overrideAttrs (old: {
          patches = [
            (builtins.fetchurl {
              url = "https://github.com/yuuyins/rustic/commit/12a3a962ff4aad605bfdfcc2ded99878b2d7de6e.patch";
              sha256 = "sha256-x4JI0zwjj/3jP4ArVt6WTXfuNdbZX8ah9ZEcRiOKW5U=";
            })
          ];
        });
      in [
        all-the-icons
        all-the-icons-dired
        auctex
        cdlatex
        citeproc
        company-mode
        company-sourcekit
        counsel
        editorconfig
        edit-indirect
        format-all
        gnuplot
        graphviz-dot-mode
        htmlize
        ivy
        ivy-bibtex
        magit
        meow
        mu4e
        mu4e-accounts
        nix-mode
        nix-update
        org
        org-auctex
        org-contrib
        org-download
        org-modern
        pdf-tools
        plantuml-mode
        polymode
        poly-org
        rustic
        separedit
        solarized-theme
        swift-mode
        swiper
        yasnippet
      ])
      ++ (with pkgs; [
        aspellPackage
        gnuplot
        plantuml
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
