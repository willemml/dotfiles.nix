{ config, pkgs, inputs, nurNoPkgs, ... }:

let
  pcfg = config.programs.emacs.init.usePackage;
in
{
  imports = [ nurNoPkgs.repos.rycee.hmModules.emacs-init ];

  programs.emacs.enable = true;

  services.emacs = pkgs.lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    client.enable = true;
    startWithUserSession = true;
  };

  programs.emacs.init = {
    enable = true;
    packageQuickstart = true;
    recommendedGcSettings = true;
    usePackageVerbose = false;
    earlyInit = ''
                                              ; -*-emacs-lisp-*-
      ;; Disable Toolbar
      (tool-bar-mode -1)

      ;; Disable scrollbar
      (scroll-bar-mode -1)

      ;; Disable menubar
      (menu-bar-mode -1)

      (setq debug-on-error t)

      ;; Use UTF-8
      (set-terminal-coding-system 'utf-8)
      (set-keyboard-coding-system 'utf-8)
      (prefer-coding-system 'utf-8)

      ;; Minimize native-comp warnings
      (setq native-comp-async-report-warnings-errors nil)
      (setq warning-minimum-level 'error)

      ;; Disable startup message.
      (setq inhibit-startup-screen t
            inhibit-startup-echo-area-message (user-login-name))

      ;; Empty initial scratch buffer.
      (setq initial-major-mode 'emacs-lisp-mode
            initial-scratch-message nil)
    '';

    prelude = ''
                                              ; -*-emacs-lisp-*-
      (setq package-archives '(("melpa"        . "https://melpa.org/packages/")
                               ("melpa-stable" . "https://stable.melpa.org/packages/")
                               ("gnu"          . "https://elpa.gnu.org/packages/")
                               ("nongnu"       . "https://elpa.nongnu.org/nongnu/")))

      (setenv "PATH" (concat "${config.home.profileDirectory}/bin:" (getenv "PATH")))
    '';

    postlude = ''
                                              ;-*-emacs-lisp-*-
      ;; Accept 'y' and 'n' rather than 'yes' and 'no'.
      (defalias 'yes-or-no-p 'y-or-n-p)

      ;; Typically, I only want spaces when pressing the TAB key. I also
      ;; want 4 of them.
      (setq-default indent-tabs-mode nil
                    tab-width 4
                    c-basic-offset 4)

      ;; Increase emacs data read limit (default too low for LSP)
      (setq read-process-output-max (* 1024 1024))

      ;; Stop creating backup and autosave files.
      (setq make-backup-files nil
            auto-save-default nil)

      ;; Always show line and column number in the mode line.
      (line-number-mode)
      (column-number-mode)

      ;; Soft wrap lines
      (visual-line-mode)

      ;; Use one space to end sentences.
      (setq sentence-end-double-space nil)

      ;; Enable highlighting of current line.
      (global-hl-line-mode 1)

      (defun with-buffer-name-prompt-and-make-subdirs ()
        "Offer to create parent directory when finding file in a non-existent directory."
        (let ((parent-directory (file-name-directory buffer-file-name)))
          (when (and (not (file-exists-p parent-directory))
          		   (y-or-n-p (format "Directory `%s' does not exist! Create it? " parent-directory)))
            (make-directory parent-directory t))))
      (add-to-list 'find-file-not-found-functions #'with-buffer-name-prompt-and-make-subdirs)

      (global-set-key (kbd "M-n") "~")
      (global-set-key (kbd "M-N") "`")

      ;; Keybind to format/prettify document, uses either format-all or
      ;; lsp-mode depending on availability
      (global-set-key (kbd "C-c C-y")  'my/format-document)

      ;; Don't warn when cannot guess python indent level
      (setq-default python-indent-guess-indent-offset-verbose nil)

      ;; Disable scroll + C to zoom
      (global-unset-key (kbd "C-<wheel-down>"))
      (global-unset-key (kbd "C-<wheel-up>"))
    '';

    usePackage = {
      all-the-icons = {
        enable = true;
        extraConfig = ":if (display-graphic-p)";
      };

      all-the-icons-dired = {
        enable = true;
        hook = [ "(dired-mode . all-the-icons-dired-mode)" ];
      };

      calibredb = {
        enable = true;
        config = ''
                                        ; -*-emacs-lisp-*-
          (setq calibredb-root-dir "~/Documents/calibre-library")
          (setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
          (setq calibredb-library-alist '(("~/Documents/calibre-library")))
          (setq sql-sqlite-program "${pkgs.sqlite}/bin/sqlite3")
        '';
      };

      cdlatex = {
        enable = true;
        after = [ "latex" ];
        hook = [ "(LaTeX-mode . turn-on-cdlatex)" ];
      };

      citeproc.enable = true;

      company = {
        enable = true;
        defines = [ "comapny-text-icons-margin" ];
        init = ''
          ;; Align company-mode tooltips to the right hand side
          (setq company-tooltip-align-annotations t)
          ;; Display number of completions before and after current suggestions
          ;; in company-mode
          (setq company-tooltip-offset-display 'lines)
          ;; Display text icon of type in company popup
          (setq company-format-margin-function #'company-text-icons-margin)
        '';
        hook =
          [ "(sh-mode . company-mode)" "(emacs-lisp-mode . company-mode)" ];
      };

      company-math = {
        enable = true;
        after = [ "company" ];
        init = ''
                                                  ; -*-emacs-lisp-*-
          (add-to-list 'company-backends 'company-math-symbols-unicode)
        '';
      };

      counsel = {
        enable = true;
        bind = {
          "M-x" = "counsel-M-x";
          "C-x C-f" = "counsel-find-file";
          "<f1> f" = "counsel-describe-function";
          "<f1> v" = "counsel-describe-variable";
          "<f1> o" = "counsel-describe-symbol";
          "<f1> l" = "counsel-find-library";
          "<f2> i" = "counsel-info-lookup-symbol";
          "<f2> u" = "counsel-unicode-char";
          "C-c g" = "counsel-git";
          "C-c j" = "counsel-git-grep";
          "C-c k" = "counsel-ag";
          "C-x l" = "counsel-locate";
          "C-S-o" = "counsel-rhythmbox";
        };
        bindLocal = {
          minibuffer-local-map = { "C-r" = "counsel-minibuffer-history"; };
        };
      };

      doom-modeline = {
        enable = true;
        hook = [ "(after-init . doom-modeline-mode)" ];
        config = ''
          (setq doom-modeline-icon t)
        '';
      };

      edit-indirect.enable = true;

      edit-server = {
        enable = true;
        command = [ "edit-server-start" ];
        config = ''
          (setq edit-server-new-frame nil)
        '';
        hook = [ "(after-init . edit-server-start)" ];
      };

      editorconfig = {
        enable = true;
        init = ''
          (editorconfig-mode 1)
        '';
      };

      async = {
        enable = true;
        init = ''
          (require 'smtpmail-async)

          (setq send-mail-function 'async-smtpmail-send-it
                message-send-mail-function 'async-smtpmail-send-it)
        '';
      };

      flycheck = {
        enable = true;
        hook = [ "(after-init . global-flycheck-mode)" ];
        config = ''
          (setq flycheck-disabled-checkers '(emacs-lisp-checkdoc))
        '';
      };

      yafolding.enable = true;

      format-all = {
        enable = true;
        command = [ "format-all-buffer" ];
        config = ''
          (setq-default format-all-formatters format-all-default-formatters)
        '';
      };

      gnuplot = {
        enable = true;
        init = ''
          (require 'gnuplot)
          (autoload 'gnuplot-mode "gnuplot" "Gnuplot major mode" t)
          (autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t)
          (setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode)) auto-mode-alist))
          (require 'gnuplot-context)
        '';
      };

      graphviz-dot-mode = {
        enable = true;
        bindLocal.graphviz-dot-mode-map = {
          "C-c C-y" = "graphviz-dot-indent-graph";
        };
      };

      htmlize.enable = true;

      ivy = {
        enable = true;
        command = [ "ivy-mode" ];
        init = ''
          (setq ivy-use-virtual-buffers t)
          (setq ivy-use-selectable-prompt t)
          (setq enable-recursive-minibuffers t)
        '';
        bind = { "C-c C-r" = "ivy-resume"; };
        hook = [ "(after-init . ivy-mode)" ];
      };

      ivy-bibtex = {
        enable = true;
        after = [ "ivy" ];
        init = ''
                                                  ; -*-emacs-lisp-*-
          ;; ivy-bibtex requires ivy's `ivy--regex-ignore-order` regex builder, which
          ;; ignores the order of regexp tokens when searching for matching candidates.
          (require 'ivy-bibtex)
          (setq ivy-re-builders-alist
                '((ivy-bibtex . ivy--regex-ignore-order)
                  (t . ivy--regex-plus)))
          (setq ivy-bibtex-bibliography '("~/Documents/org/zotero.bib"))
          (setq reftex-default-bibliography '("~/Documents/org/zotero.bib"))
          (setq bibtex-completion-pdf-field "file")
        '';
      };

      latex = {
        enable = true;
        package = epkgs: epkgs.auctex;
        hook = [
          ''
            (LaTeX-mode
             . (lambda ()
                 (turn-on-reftex)))
          ''
        ];
        init = ''
          (setq TeX-PDF-mode t
                TeX-auto-save t
                TeX-parse-self t)
        '';
      };

      lsp-ivy = {
        enable = true;
        command = [ "lsp-ivy-workspace-symbol" ];
      };

      lsp-java = {
        enable = true;
        init = ''
                                        ; -*-emacs-lisp-*-
          (setq lsp-java-format-settings-url
           "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml")
          (setq lsp-java-format-settings-profile
           "GoogleStyle")
          (setq lsp-java-jdt-download-url
           "https://download.eclipse.org/jdtls/milestones/1.16.0/jdt-language-server-1.16.0-202209291445.tar.gz")
        '';
        hook = [ "(java-mode . lsp)" ];
      };

      lsp-mode = {
        enable = true;
        after = [ "format-all" ];
        command = [ "lsp-format-buffer" ];
        extraConfig = ''
            :preface
            (defun my/format-document ()
          	"Formats the buffer using 'lsp-format-buffer'.
          Falls back to 'format-all-buffer' if LSP does not support formatting."
          	(interactive)
              (cond ((fboundp 'lsp-feature?)
          	       (cond ((lsp-feature? "textDocument/formatting")
          		          (lsp-format-buffer))
          		         ((lsp-feature? "textDocument/rangeFormatting")
          		          (lsp-format-buffer))
          		         (t (format-all-buffer))))
                    (t 
                       (format-all-buffer))))
        '';
        functions = [ "lsp-deferred" "lsp-feature" "lsp-register-client" ];
        init = ''
          (setq lsp-log-io nil)
          (setq lsp-keymap-prefix "C-c l")
        '';
        config = ''
            (lsp-treemacs-sync-mode 1)
            (add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
            (lsp-register-client
             (make-lsp-client :new-connection (lsp-stdio-connection '("rnix-lsp"))
          					:major-modes '(nix-mode)
          					:server-id 'nix))
        '';
        hook = [
          "(lsp-mode . company-mode)"
          "(rust-mode . lsp)"
          "(c-mode . lsp)"
          "(javascript-mode . lsp)"
          "(nix-mode . lsp)"
        ];
        bind = { "C-c C-y" = "my/format-document"; };
      };

      lsp-treemacs = {
        enable = true;
        command = [ "lsp-treemacs-errors-lisp" ];
      };

      lsp-ui = {
        enable = true;
        command = [ "lsp-ui-mode" ];
      };

      magit = {
        enable = true;
      };

      meow = {
        enable = true;
        init = ''
                                                  ; -*-emacs-lisp-*-
          (defun meow-setup ()
            (setq meow-cheatsheet-layout meow-cheatsheet-layout-colemak)
            (meow-motion-overwrite-define-key
             ;; Use e to move up, n to move down.
             ;; Since special modes usually use n to move down, we only overwrite e here.
             '("e" . meow-prev)
             '("<escape>" . ignore))
            (meow-leader-define-key
             '("?" . meow-cheatsheet)
             ;; To execute the originally e in MOTION state, use SPC e.
             '("e" . "H-e")
             '("1" . meow-digit-argument)
             '("2" . meow-digit-argument)
             '("3" . meow-digit-argument)
             '("4" . meow-digit-argument)
             '("5" . meow-digit-argument)
             '("6" . meow-digit-argument)
             '("7" . meow-digit-argument)
             '("8" . meow-digit-argument)
             '("9" . meow-digit-argument)
             '("0" . meow-digit-argument))
            (meow-normal-define-key
             '("0" . meow-expand-0)
             '("1" . meow-expand-1)
             '("2" . meow-expand-2)
             '("3" . meow-expand-3)
             '("4" . meow-expand-4)
             '("5" . meow-expand-5)
             '("6" . meow-expand-6)
             '("7" . meow-expand-7)
             '("8" . meow-expand-8)
             '("9" . meow-expand-9)
             '("-" . negative-argument)
             '(";" . meow-reverse)
             '("," . meow-inner-of-thing)
             '("." . meow-bounds-of-thing)
             '("[" . meow-beginning-of-thing)
             '("]" . meow-end-of-thing)
             '("/" . meow-visit)
             '("a" . meow-append)
             '("A" . meow-open-below)
             '("b" . meow-back-word)
             '("B" . meow-back-symbol)
             '("c" . meow-change)
             '("d" . meow-delete)
             '("e" . meow-prev)
             '("E" . meow-prev-expand)
             '("f" . meow-find)
             '("g" . meow-cancel-selection)
             '("G" . meow-grab)
             '("h" . meow-left)
             '("H" . meow-left-expand)
             '("i" . meow-right)
             '("I" . meow-right-expand)
             '("j" . meow-join)
             '("k" . meow-kill)
             '("l" . meow-line)
             '("L" . meow-goto-line)
             '("m" . meow-mark-word)
             '("M" . meow-mark-symbol)
             '("n" . meow-next)
             '("N" . meow-next-expand)
             '("o" . meow-block)
             '("O" . meow-to-block)
             '("p" . meow-yank)
             '("q" . meow-quit)
             '("r" . meow-replace)
             '("s" . meow-insert)
             '("S" . meow-open-above)
             '("t" . meow-till)
             '("u" . meow-undo)
             '("U" . meow-undo-in-selection)
             '("v" . meow-search)
             '("w" . meow-next-word)
             '("W" . meow-next-symbol)
             '("x" . meow-delete)
             '("X" . meow-backward-delete)
             '("y" . meow-save)
             '("z" . meow-pop-selection)
             '("'" . repeat)
             '("<escape>" . ignore)))
          (require 'meow)
          (meow-setup)
          (meow-global-mode 1)
        '';
      };

      mu4e =
        let
          smtpConfig = name:
            (
              let
                account = config.accounts.email.accounts.${name};
                port = builtins.toString account.smtp.port;
                host = account.smtp.host;
              in
              ''
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
                     (smtpmail-smtp-user "${account.userName}")
                     (user-mail-address "${account.address}"))
              ''
            );
          smtpAccounts = ''
            '( ${(smtpConfig "leitso")}
               ${(smtpConfig "gmail")} 
               ${(smtpConfig "wnuke9")} )
          '';
        in
        {
          enable = true;
          after = [ "async" ];
          package = epkgs: pkgs.mu;
          demand = true;
          extraPackages = [ pkgs.gnutls pkgs.mu ];
          init = ''
                                                    ;-*-emacs-lisp-*-

            (add-to-list 'load-path "${pkgs.mu}/share/emacs/site-lisp/mu4e")

            (require 'mu4e)

            (setq starttls-use-gnutls t
                  message-kill-buffer-on-exit t
                  mail-user-agent 'mu4e-user-agent)

            (set-variable 'read-mail-command 'mu4e)

            (defvar my-mu4e-account-alist ${smtpAccounts} )

            (mapc #'(lambda (var)
                      (set (car var) (cadr var)))
                  (cdr (assoc "leitso" my-mu4e-account-alist)))

            (defun my-mu4e-set-account ()
              "Set the account for composing a message."
              (let* ((account
                      (if mu4e-compose-parent-message
                          (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
                            (string-match "/\\(.*?\\)/" maildir)
                            (match-string 1 maildir))
                        (completing-read (format "Compose with account: (%s) "
                                                 (mapconcat #'(lambda (var) (car var))
                                                            my-mu4e-account-alist "/"))
                                         (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
                                         nil t nil nil (caar my-mu4e-account-alist))))
                     (account-vars (cdr (assoc account my-mu4e-account-alist))))
                (if account-vars
                    (mapc #'(lambda (var)
                              (set (car var) (cadr var)))
                          account-vars)
                  (error "No email account found"))))

            (add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

          '';

          bind = {
            "C-c C-u" = "my-mu4e-set-account";
          };

          hook = [ "(mu4e-compose-pre-hook . my-mu4e-set-account)" ];
        };

      nix-mode = {
        enable = true;
        extraConfig = ''
          :mode "\\.nix\\'"
        '';
        config = ''
          (setq nix-nixfmt-bin "${pkgs.nixfmt}/bin/nixfmt")
          (setq nix-executable "/nix/var/nix/profiles/default/bin/nix")
        '';
      };

      nix-update = {
        enable = true;
        command = [ "nix-update-fetch" ];
        bindLocal.nix-mode-map."C-c C-u" = "nix-update-fetch";
      };

      ob-calc = {
        enable = true;
        after = [ "org" ];
      };

      ob-dot = {
        enable = true;
        after = [ "org" ];
      };

      ob-emacs-lisp = {
        enable = true;
        after = [ "org" ];
      };

      ob-gnuplot = {
        enable = true;
        after = [ "org" ];
      };

      ob-matlab = {
        enable = true;
        after = [ "org" ];
        init = ''
          (setq org-babel-octave-shell-command "${pkgs.octave}/bin/octave -q")
        '';
      };

      ob-python = {
        enable = true;
        after = [ "org" ];
        init = ''
                                        ; -*-emacs-lisp-*-
          (setq org-babel-python-command "${pkgs.python310}/bin/python3.10")
          (setq-default python-indent-guess-indent-offset-verbose nil)
          (defun my/org-babel-execute:python-session (body params)
            (let ((session-name (cdr (assq :session params))))
              (when (not (eq session-name "none"))
                (org-babel-python-initiate-session session-name))))
          (advice-add #'org-babel-execute:python :before #'my/org-babel-execute:python-session)
        '';
      };

      ob-shell = {
        enable = true;
        after = [ "org" ];
      };

      org = {
        enable = true;
        extraConfig = ''
                                        ; -*-emacs-lisp-*-
          :preface
          (defun my/indent-org-block-automatically ()
            "Indent the current org code block."
            (interactive)
            (when (org-in-src-block-p)
          	(org-edit-special)
              (indent-region (point-min) (point-max))
              (org-edit-src-exit)))
          (defun my/org-force-open-current-window ()
            "Open a link using 'org-open-at-point' in current window."
            (interactive)
            (let ((org-link-frame-setup
          		 (quote
          		  ((vm . vm-visit-folder)
          		   (vm-imap . vm-visit-imap-folder)
          		   (gnus . gnus)
          		   (file . find-file)
          		   (wl . wl)))
          		 ))
          	(org-open-at-point)))
          (defun my/follow-org-link (arg)
            "Follow a link in orgmode If ARG is given.
          Opens in new window otherwise opens in current window."
            (interactive "P")
            (if arg
          	  (org-open-at-point)
          	(my/org-force-open-current-window)))
          (defun krofna-hack ()
            (when (looking-back (rx "$ "))
              (save-excursion
                (backward-char 1)
                (org-toggle-latex-fragment))))
        '';

        init = ''
                                                  ; -*-emacs-lisp-*-
          (require 'oc)
          (require 'oc-basic)
          (require 'oc-csl)
          (require 'oc-natbib)
          (require 'ox-latex)

          (add-hook 'org-mode-hook
                    (lambda ()
                      (add-hook 'post-self-insert-hook #'krofna-hack 'append 'local)))

          (add-to-list 'exec-path "${config.home.profileDirectory}/bin")
          (add-to-list 'org-latex-classes
                       '("apa6"
                         "\\documentclass{apa6}"
                         ("\\section{%s}" . "\\section*{%s}")
                         ("\\subsection{%s}" . "\\subsection*{%s}")
                         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                         ("\\paragraph{%s}" . "\\paragraph*{%s}")
                         ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
          (add-to-list 'org-latex-classes
                       '("mla"
                         "\\documentclass{mla}"
                         ("\\section{%s}" . "\\section*{%s}")
                         ("\\subsection{%s}" . "\\subsection*{%s}")
                         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                         ("\\paragraph{%s}" . "\\paragraph*{%s}")
                         ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

          (plist-put org-format-latex-options :scale 3)

          (setq org-agenda-block-separator ?─)
          (setq org-agenda-current-time-string "⭠ now ─────────────────────────────────────────────────")
          (setq org-agenda-files '("${config.home.sessionVariables.ORGDIR}" "${config.home.sessionVariables.UBCDIR}"))
          (setq org-agenda-tags-column 0)
          (setq org-auto-align-tags nil)
          (setq org-catch-invisible-edits 'show-and-error)
          (setq org-cite-csl-styles-dir "~/Zotero/styles")
          (setq org-cite-export-processors '((t basic)))
          (setq org-cite-global-bibliography '("${config.home.sessionVariables.ORGDIR}/zotero.bib"))
          (setq org-confirm-babel-evaluate nil)
          (setq org-ellipsis "…")
          (setq org-export-with-tags nil)
          (setq org-hide-emphasis-markers t)
          (setq org-highlight-latex-and-related '(latex))
          (setq org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")
          (setq org-html-head-include-default-style nil)
          (setq org-html-head-include-scripts nil)
          (setq org-html-validation-link nil)
          (setq org-image-actual-width 300)
          (setq org-insert-heading-respect-content t)
          (setq org-latex-pdf-process '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))
          (setq org-pretty-entities t)
          (setq org-preview-latex-default-process 'dvisvgm)
          (setq org-special-ctrl-a/e t)
          (setq org-src-fontify-natively t)
          (setq org-src-preserve-indentation t)
          (setq org-src-tab-acts-natively t)
          (setq org-src-window-setup 'current-window)
          (setq org-tags-column 0)

          (setq org-agenda-time-grid
                '((daily today require-timed)
                  (800 1000 1200 1400 1600 1800 2000)
                  " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"))

          (setq org-publish-project-alist
                '(("html"
                   :base-directory "${config.home.sessionVariables.ORGDIR}"
                   :base-extension "org"
                   :htmlized-source t
                   :recursive t
                   :publishing-directory "${config.home.sessionVariables.ORGDIR}/exports"
                   :publishing-function org-html-publish-to-html)
                  ("pdf"
                   :base-directory "${config.home.sessionVariables.ORGDIR}"
                   :base-extension "org"
                   :recursive t
                   :publishing-directory "${config.home.sessionVariables.ORGDIR}/exports"
                   :publishing-function org-latex-publish-to-pdf)
                  ("all" :components ("html" "pdf"))
                  ))
        '';
        hook = [
          "(org-babel-after-execute . org-redisplay-inline-images)"
          "(org-mode . visual-line-mode)"
          "(org-mode . org-cdlatex-mode)"
        ];
        bind = {
          "C-c n c" = "org-id-get-create";
          "C-c n a" = "org-agenda";
        };
        bindLocal.org-mode-map = {
          "C-c C-o" = "my/follow-org-link";
          "C-c C-y" = "my/indent-org-block-automatically";

          "C-c ]" = "org-cite-insert";
        };
      };

      org-auctex = {
        enable = true;
        package = epkgs: epkgs.trivialBuild {
          pname = "org-auctex";
          version = "e1271557b9f36ca94cabcbac816748e7d0dc989c";

          packageRequires = [ epkgs.auctex ];

          src = pkgs.fetchFromGitHub {
            owner = "karthink";
            repo = "org-auctex";
            rev = "e1271557b9f36ca94cabcbac816748e7d0dc989c";
            sha256 = "sha256-cMAhwybnq5HA1wOaUqDPML3nnh5m1iwEETTPWqPbAvw=";
          };
        };
        hook = [ "(org-mode . org-auctex-mode)" ];
      };

      org-contrib.enable = true;

      org-download = {
        enable = true;
        after = [ "org" ];
        init = ''
          (require 'org-download)
          (setq-default org-download-image-dir "${config.home.sessionVariables.ORGDIR}/images")
        '';
        hook = [ "(dired-mode . org-download-enable)" ];
      };

      org-modern = {
        enable = true;
        after = [ "org" ];
        hook = [ "(org-mode . org-modern-mode)" ];
      };

      pdf-tools = {
        enable = true;
        init = ''
                                                  ; -*-emacs-lisp-*-
          (setq-default pdf-view-display-size 'fit-width)
          (setq pdf-annot-activate-created-annotations t)
        '';
      };

      #
      plantuml-mode = {
        enable = true;
        init = ''
          (setq plantuml-executable-path "${pkgs.plantuml}/bin/plantuml")
          (setq plantuml-default-exec-mode 'executable)
        '';
      };
      #

      rust-mode = {
        enable = true;
        bindLocal.rust-mode-map = {
          "C-c C-y" = "lsp-format-buffer";
          "C-c C-c" = "rust-run-clippy";
          "C-c C-r" = "rust-run";
          "C-c C-t" = "rust-test";
          "C-c C-o" = "rust-compile";
        };
      };

      separedit = {
        enable = true;
        bind = { "C-c '" = "separedit"; };
        hook = [ "(separedit-buffer-creation . normal-mode)" ];
        init = ''
                                                  ; -*-emacs-lisp-*-
          (setq separedit-preserve-string-indentation t)
        '';
      };

      solarized-theme = {
        enable = true;
        init = "(load-theme 'solarized-gruvbox-dark t)";
      };

      swiper = {
        enable = true;
        bind = { "C-s" = "swiper"; };
      };

      tree-sitter = {
        enable = true;
        package = epkgs: epkgs.tsc;
        init = ''
          (setq tree-sitter-major-mode-language-alist '((arduino-mode . c)))
        '';
        hook = [
          "(rust-mode . tree-sitter-hl-mode)"
          "(python-mode . tree-sitter-hl-mode)"
          "(c-mode . tree-sitter-hl-mode)"
          "(shell-mode . tree-sitter-hl-mode)"
          "(javascript-mode . tree-sitter-hl-mode)"
        ];
      };

      tree-sitter-langs = {
        enable = true;
        package = epkgs: epkgs.tree-sitter-langs;
      };

      yasnippet = {
        enable = true;
        init = ''
          (setq yas-snippet-dirs '("${config.home.sessionVariables.ORGDIR}/snippets"))
          (yas-global-mode 1)
        '';
      };

      yasnippet-snippets = {
        enable = true;
        init = ''
          (yas-reload-all)
        '';
      };

      arduino-mode = {
        enable = true;
        hook = [ "(arduino-mode . flycheck-arduino-setup)" ];
        init = ''
          (require 'flycheck-arduino)
          (setq arduino-executable "/Applications/Arduino.app/Contents/MacOS/Arduino")
        '';
      };
    };
  };
}
