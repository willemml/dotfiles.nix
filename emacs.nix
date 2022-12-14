{ config, pkgs, inputs, nurNoPkgs, ... }:

let pcfg = config.programs.emacs.init.usePackage;
in {
  imports = [ nurNoPkgs.repos.rycee.hmModules.emacs-init ];

  programs.emacs.enable = true;

  programs.emacs.init = {
    enable = true;
    packageQuickstart = false;
    recommendedGcSettings = true;
    usePackageVerbose = false;

    earlyInit = ''
      ;; Disable Toolbar
      (tool-bar-mode -1)
      ;; Disable scrollbar
      (scroll-bar-mode -1)
      ;; Disable menubar
      (menu-bar-mode -1)

      ;; Increase garbage collector threshold before load
      (setq gc-cons-threshold 640000000)

      (setq debug-on-error t)

      ;; Use UTF-8
      (set-terminal-coding-system 'utf-8)
      (set-keyboard-coding-system 'utf-8)
      (prefer-coding-system 'utf-8)

      ;; Minimize native-comp warnings
      (setq native-comp-async-report-warnings-errors nil)
      (setq warning-minimum-level 'error)
    '';
    prelude = ''
      ;; Disable startup message.
      (setq inhibit-startup-screen t
            inhibit-startup-echo-area-message (user-login-name))

      (setq package-archives '(("melpa"        . "https://melpa.org/packages/")
                               ("melpa-stable" . "https://stable.melpa.org/packages/")
                               ("gnu"          . "https://elpa.gnu.org/packages/")
                               ("nongnu"       . "https://elpa.nongnu.org/nongnu/")))

      ;; Empty initial scratch buffer.
      (setq initial-major-mode 'fundamental-mode
            initial-scratch-message nil)

      (setenv "PATH" (concat "${config.home.profileDirectory}/bin:" (getenv "PATH")))

      ;; Accept 'y' and 'n' rather than 'yes' and 'no'.
      (defalias 'yes-or-no-p 'y-or-n-p)

      ;; Typically, I only want spaces when pressing the TAB key. I also
      ;; want 4 of them.
      (setq-default indent-tabs-mode nil
                    tab-width 4
                    c-basic-offset 4)

      ;; Increase emacs data read limit (default too low for LSP)
      (setq read-process-output-max (* 1024 1024))

      ;; Reduce wrist pain
      (global-set-key (kbd "M-n") "~")
      (global-set-key (kbd "M-N") "`")

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

      ;; I typically want to use UTF-8.
      (prefer-coding-system 'utf-8)

      ;; Enable highlighting of current line.
      (global-hl-line-mode 1)

      ;; When finding file in non-existing directory, offer to create the
      ;; parent directory.
      (defun with-buffer-name-prompt-and-make-subdirs ()
        (let ((parent-directory (file-name-directory buffer-file-name)))
          (when (and (not (file-exists-p parent-directory))
      			   (y-or-n-p (format "Directory `%s' does not exist! Create it? " parent-directory)))
            (make-directory parent-directory t))))

      (add-to-list 'find-file-not-found-functions #'with-buffer-name-prompt-and-make-subdirs)

      ;; Bind Emacs built in completion using completion-at-point to "C-M-i"
      (global-set-key (kbd "C-M-i") 'completion-at-point)

      ;; Keybind to format/prettify document, uses either format-all or
      ;; lsp-mode depending on availability
      (global-set-key (kbd "C-c C-y")  'my/format-document)

      ;; Don't warn when cannot guess python indent level
      (setq-default python-indent-guess-indent-offset-verbose nil)

      (defun my/define-multiple-keys (map keys)
        "Define multiple KEYS in a keymap.
      Argument MAP keymap in which to bind the keys."
        (dolist (key keys nil)
          (define-key map (kbd (car key)) (nth 1 key))))

      (defun my/customize-set-variables (variables)
        "Set multiple Customize VARIABLES at once."
        (dolist (variable variables nil)
          (customize-set-variable (car variable) (nth 1 variable))))

      (defun my/find-file-in-folder-shortcut (folder)
        "Interactively call `find-file' after using 'cd' into 'FOLDER'."
        (cd (expand-file-name folder))
        (call-interactively #'find-file))

      (defun my/electric-mode ()
        "Enable some basic features for coding."
        (interactive)
        (electric-pair-local-mode)
        (electric-indent-local-mode))

      (defun dev ()
        "Shortcut to '~/dev' folder."
        (interactive)
        (my/find-file-in-folder-shortcut "~/dev"))
    '';

    usePackage = {
      dracula-theme = {
        enable = true;
        config = ''
          (load-theme 'dracula t)
        '';
      };

      yasnippet = {
        enable = true;
        config = ''
          (yas-global-mode 1)
        '';
      };

      yasnippet-snippets = {
        enable = true;
        config = ''
          (yas-reload-all)
        '';
      };

      ivy = {
        enable = true;
        command = [ "ivy-mode" ];
        extraConfig = ''
          :custom
          (ivy-use-virtual-buffers t)
          (enable-recursive-minibuffers t)
        '';
        bind = { "C-c C-r" = "ivy-resume"; };
        hook = [ "(after-init . ivy-mode)" ];
      };

      swiper = {
        enable = true;
        bind = { "C-s" = "swiper"; };
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

      format-all = {
        enable = true;
        command = [ "format-all-buffer" ];
        config = ''
          (setq-default format-all-formatters format-all-default-formatters)
        '';
        bindLocal.c-mode-map = { "C-c C-y" = "format-all-buffer"; };
        extraPackages = [ pkgs.black pkgs.shellcheck pkgs.clang-tools ];
      };

      tree-sitter = {
        enable = true;
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

      tree-sitter-langs.enable = true;

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
        ];
        bind = { "C-c C-y" = "my/format-document"; };

        extraPackages = [ pkgs.nodePackages.bash-language-server ];
      };

      lsp-ui = {
        enable = true;
        command = [ "lsp-ui-mode" ];
      };

      lsp-ivy = {
        enable = true;
        command = [ "lsp-ivy-workspace-symbol" ];
      };

      lsp-treemacs = {
        enable = true;
        command = [ "lsp-treemacs-errors-lisp" ];
      };

      lsp-java = {
        enable = true;
        init = ''
          (setq lsp-java-format-settings-url
           "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml")
          (setq lsp-java-format-settings-profile
           "GoogleStyle")
          (setq lsp-java-jdt-download-url
           "https://download.eclipse.org/jdtls/milestones/1.16.0/jdt-language-server-1.16.0-202209291445.tar.gz")
        '';
        hook = [ "(java-mode . lsp)" ];
      };

      flycheck = {
        enable = true;
        hook = [ "(after-init . global-flycheck-mode)" ];
        config = ''
          (setq flycheck-disabled-checkers '(emacs-lisp-checkdoc))
        '';
      };

      arduino-mode = {
        enable = true;
        config = ''
          (require 'flycheck-arduino)
          (add-hook 'arduino-mode-hook #'flycheck-arduino-setup)
        '';
        init = ''
          (setq arduino-executable "/Applications/Arduino.app/Contents/MacOS/Arduino")
        '';
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
        bindLocal.nix-mode-map = { "C-c C-y" = "nix-format-buffer"; };

        extraPackages = [ pkgs.nixfmt ];
      };

      edit-indirect.enable = true;

      org = {
        enable = true;
        extraConfig = ''
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
          		   (gnus. gnus)
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
        '';
        init = ''
            (setq org-src-window-setup 'current-window)
            (setq org-confirm-babel-evaluate nil)
            (setq org-src-fontify-natively t)
            (setq org-src-tab-acts-natively t)
            (setq org-src-preserve-indentation t)

            (setq org-export-with-tags nil)

            (setq org-publish-project-alist
             '(("Root"
          	  :base-directory "~/Documents/org/roam/"
          	  :publishing-function org-html-publish-to-html
          	  :publishing-directory "~/public_html"
          	  :section-numbers nil
          	  :with-author nil
          	  :with-creator t
          	  :with-toc t
          	  :time-stamp-file nil)))

            ;; Configure HTML export
            (setq org-html-validation-link nil)
            (setq org-html-head-include-scripts nil)
            (setq org-html-head-include-default-style nil)
            (setq org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")
            (setq org-html-section)
        '';
        hook = [ "(org-babel-after-execute . org-redisplay-inline-images)" ];

        bind = {
          "C-c n c" = "org-id-get-create";
          "C-c n a" = "org-agenda";
        };
        bindLocal.org-mode-map = {
          "C-c C-o" = "my/follow-org-link";
          "C-c C-y" = "my/indent-org-block-automatically";
          "<mouse-2>" = "my/follow-org-link";
        };

        extraPackages = [ pkgs.texlive.combined.scheme-full ];
      };

      htmlize.enable = true;
      emacsql-sqlite.enable = true;

      org-contrib.enable = true;

      plantuml-mode = {
        enable = true;
        init = ''
          (setq plantuml-executable-path "${pkgs.plantuml}/bin/plantuml")
          (setq plantuml-default-exec-mode 'executable)
        '';
        extraPackages = [ pkgs.plantuml ];
      };

      graphviz-dot-mode = {
        enable = true;
        bindLocal.graphviz-dot-mode-map = {
          "C-c C-y" = "graphviz-dot-indent-graph";
        };
        extraPackages = [ pkgs.graphviz ];
      };

      ob-dot = {
        enable = true;
        after = [ "org" ];
      };

      ob-shell = {
        enable = true;
        after = [ "org" ];
      };

      ob-calc = {
        enable = true;
        after = [ "org" ];
      };

      ob-emacs-lisp = {
        enable = true;
        after = [ "org" ];
      };

      ob-python = {
        enable = true;
        extraPackages = [
          (pkgs.python310.withPackages (p: with p; [ matplotlib latexify-py ]))
        ];
        after = [ "org" ];
        config = ''
          (setq org-babel-python-command "${pkgs.python310}/bin/python3.10")
          (setq-default python-indent-guess-indent-offset-verbose nil)
          (defun my/org-babel-execute:python-session (body params)
            (let ((session-name (cdr (assq :session params))))
              (when (not (eq session-name "none"))
                (org-babel-python-initiate-session session-name))))
          (advice-add #'org-babel-execute:python :before #'my/org-babel-execute:python-session)
        '';
      };

      org-ref = {
        enable = true;
        config = ''
          (setq org-ref-insert-cite-function
                (lambda ()
          	(org-cite-insert nil)))
        '';
      };

      calibredb = {
        enable = true;
        extraPackages = [ pkgs.sqlite ];
        config = ''
          (setq calibredb-root-dir "~/Documents/calibre-library")
          (setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
          (setq calibredb-library-alist '(("~/Documents/calibre-library")))
          (setq sql-sqlite-program "${pkgs.sqlite}/bin/sqlite3")
        '';
      };

      meow = {
        enable = true;
        config = ''
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
        '';
      };

      separedit = {
        enable = true;
        bind = { "C-c '" = "separedit"; };
      };

      editorconfig = {
        enable = true;
        config = ''
          (editorconfig-mode 1)
        '';
      };

      org-download = {
        enable = true;
        init = ''
          (require 'org-download)
          (setq-default org-download-image-dir "~/Documents/org/images")
        '';
        hook = [ "(dired-mode-hook . org-download-enable)" ];
        extraPackages = [ pkgs.pngpaste ];
      };

      exec-path-from-shell = {
        enable = true;

        init = ''
          (dolist (var '("SSH_AUTH_SOCK" "LANG" "LC_CTYPE" "LC_MESSAGES" "NIX_SSL_CERT_FILE" "NIX_PROFILES" "JAVA_HOME" "GNUPGHOME"))
            (add-to-list 'exec-path-from-shell-variables var))

          (when (memq window-system '(mac ns x))
            (exec-path-from-shell-initialize))

          (when (daemonp)
            (exec-path-from-shell-initialize))

          (add-to-list 'exec-path "/Users/willem/.nix-profile/bin")
        '';
      };
    };
  };
}
