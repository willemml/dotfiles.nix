{ config, pkgs, inputs, nurNoPkgs, ... }:

let pcfg = config.programs.emacs.init.usePackage;
in {
  imports = [
    nurNoPkgs.repos.rycee.hmModules.emacs-init
    nurNoPkgs.repos.rycee.hmModules.emacs-notmuch
  ];

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

      (setq initial-major-mode 'fundamental-mode
            initial-scratch-message nil)

      ;; Accept 'y' and 'n' rather than 'yes' and 'no'.
      (defalias 'yes-or-no-p 'y-or-n-p)


      ;; Don't use tabs for indents
      (setq indent-tabs-mode nil)

      ;; Don't warn when cannot guess python indent level
      (setq python-indent-guess-indent-offset-verbose nil)

      ;; Set indent level to 4
      (setq-default tab-width 4)

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

      ;; Use one space to end sentences.
      (setq sentence-end-double-space nil)

      ;; I typically want to use UTF-8.
      (prefer-coding-system 'utf-8)

      ;; Enable highlighting of current line.
      (global-hl-line-mode 1)

      (setq custom-file (locate-user-emacs-file "custom.el"))
      (load custom-file)

      ;; When finding file in non-existing directory, offer to create the
      ;; parent directory.
      (defun with-buffer-name-prompt-and-make-subdirs ()
        (let ((parent-directory (file-name-directory buffer-file-name)))
          (when (and (not (file-exists-p parent-directory))
                     (y-or-n-p (format "Directory `%s' does not exist! Create it? " parent-directory)))
            (make-directory parent-directory t))))

      (add-to-list 'find-file-not-found-functions #'with-buffer-name-prompt-and-make-subdirs)
    '';

    usePackage = {
      dracula-theme = {
        enable = true;
        config = ''
          (load-theme 'dracula t)
        '';
      };
    };
  };
}
