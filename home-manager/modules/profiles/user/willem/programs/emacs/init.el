;;; init.el -- willemm's Emacs configuration.
;;
;;; Commentary:
;;
;; My Emacs configuration, uses nix-community's emacs-overlay for package installation.
;; Originally generated by home-manager, taken apart and reassembled by me.
;;
;;; Code:

(setenv "PATH" (concat "/Users/willem/.nix-profile/bin:" (getenv "PATH")))
(add-to-list 'exec-path "/Users/willem/.nix-profile/bin")

(setq inhibit-default-init t)

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

;; Don't warn when cannot guess python indent level
(setq-default python-indent-guess-indent-offset-verbose nil)

;; Disable scroll + C to zoom
(global-unset-key (kbd "C-<wheel-down>"))
(global-unset-key (kbd "C-<wheel-up>"))

(require 'all-the-icons)
(require 'all-the-icons-dired)
(require 'arduino-mode)
(require 'async)
(require 'calibredb)
(require 'cdlatex)
(require 'citeproc)
(require 'company)
(require 'counsel)
(require 'edit-indirect)
(require 'editorconfig)
(require 'eglot)
(require 'format-all)
(require 'gnuplot)
(require 'gnuplot-context)
(require 'graphviz-dot-mode)
(require 'htmlize)
(require 'ivy)
(require 'ivy-bibtex)
(require 'magit)
(require 'meow)
(require 'mu4e)
(require 'mu4e-accounts)
(require 'nix-mode)
(require 'nix-update)
(require 'ob-dot)
(require 'ob-emacs-lisp)
(require 'ob-gnuplot)
(require 'ob-matlab)
(require 'ob-python)
(require 'ob-shell)
(require 'oc)
(require 'oc-basic)
(require 'oc-csl)
(require 'oc-natbib)
(require 'org)
(require 'org-auctex)
(require 'org-contrib)
(require 'org-download)
(require 'org-modern)
(require 'ox-latex)
(require 'ox-publish)
(require 'pdf-tools)
(require 'plantuml-mode)
(require 'polymode)
(require 'rustic)
(require 'smtpmail-async)
(require 'swiper)
(require 'tex)
(require 'yasnippet)

(setq org-directory (expand-file-name "~/Documents/org"))

(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(setq arduino-executable "/Applications/Arduino.app/Contents/MacOS/Arduino")

(setq send-mail-function 'async-smtpmail-send-it
      message-send-mail-function 'async-smtpmail-send-it)

(setq calibredb-root-dir (expand-file-name "~/Documents/calibre-library"))
(setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
(setq calibredb-library-alist '(("~/Documents/calibre-library")))

(setq company-format-margin-function 'company-text-icons-margin)
(setq company-text-icons-add-background t)

(add-hook 'after-init-hook 'global-company-mode)

(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(editorconfig-mode 1)

(global-set-key (kbd "C-c C-y") 'format-all-buffer)

(add-to-list 'format-all-default-formatters '("Nix" alejandra))
(setq-default format-all-formatters format-all-default-formatters)

(autoload 'gnuplot-mode "gnuplot" "Gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t)
(setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode)) auto-mode-alist))

(define-key graphviz-dot-mode-map (kbd "C-c C-y") 'graphviz-dot-indent-graph)

(global-set-key (kbd "C-c C-r") 'ivy-resume)
(add-hook 'after-init-hook 'ivy-mode)

(setq ivy-use-virtual-buffers t)
(setq ivy-use-selectable-prompt t)
(setq enable-recursive-minibuffers t)

;; ivy-bibtex requires ivy's `ivy--regex-ignore-order` regex builder, which
;; ignores the order of regexp tokens when searching for matching candidates.
(setq ivy-re-builders-alist
      '((ivy-bibtex . ivy--regex-ignore-order)
        (t . ivy--regex-plus)))

(defvar zotero-bibliography (expand-file-name "zotero.bib" org-directory))

(defvar ivy-bibtex-bibliography (list zotero-bibliography))
(setq reftex-default-bibliography (list zotero-bibliography))
(setq bibtex-completion-pdf-field "file")

(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)
(add-hook 'LaTeX-mode (lambda ()
                        (turn-on-reftex)))
(setq TeX-PDF-mode t
      TeX-auto-save t
      TeX-parse-self t)



(defun meow-setup ()
  "Initialize meow-edit for colemak."
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

(meow-setup)
(meow-global-mode 1)

(define-key mu4e-main-mode-map (kbd "C-c C-u") 'my-mu4e-set-account)
(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

(defvar starttls-use-gnutls t)
(setq message-kill-buffer-on-exit t
      mail-user-agent 'mu4e-user-agent)

(set-variable 'read-mail-command 'mu4e)

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

(setq mu4e-bookmarks
      '((:name "Unread messages" :query "flag:unread AND NOT (flag:trashed OR maildir:/feeds)" :key ?u)
        (:name "Today's messages" :query "date:today..now AND NOT maildir:/feeds" :key ?t)
        (:name "Last 7 days" :query "date:7d..now AND NOT maildir:/feeds" :key ?w)
        (:name "Feed" :query "maildir:/feeds" :key ?f)
        (:name "XKCD" :query "list:xkcd.localhost" :key ?x)))

(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

(define-hostmode poly-nix-hostmode :mode 'nix-mode)

(define-auto-innermode poly-any-expr-nix-innermode
  :head-matcher (rx (* blank) "/*" (* blank) bow (+ (or word punct)) eow (* blank) "*/" (* blank) "''\n")
  :mode-matcher (cons (rx "/*" (* blank) (submatch bow (+ (or word punct)) eow) (* blank) "*/") 1)
  :tail-matcher (rx bol (* blank) "'';" (* blank) eol)
  :head-mode 'host
  :tail-mode 'host
  :fallback-mode 'text-mode)

(define-polymode poly-nix-mode
  :hostmode 'poly-nix-hostmode
  :innermodes '(poly-any-expr-nix-innermode))

(add-to-list 'auto-mode-alist '("\\.nix$" . poly-nix-mode))

(define-key nix-mode-map (kbd "C-c C-u") 'nix-update-fetch)

(setq org-babel-octave-shell-command "octave -q")

(setq org-babel-python-command "python3.10")
(setq-default python-indent-guess-indent-offset-verbose nil)
(defun my/org-babel-execute:python-session (body params)
  "Initiate a python session before executing org babel blocks that use sessions.
BODY is the content of the org-babel block and PARAMS are any parameters specified."
  (let ((session-name (cdr (assq :session params))))
    (when (not (eq session-name "none"))
      (org-babel-python-initiate-session session-name))))
(advice-add #'org-babel-execute:python :before #'my/org-babel-execute:python-session)

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
  "Toggle latex fragments after exiting closing them."
  (when (looking-back (rx "$ "))
    (save-excursion
      (backward-char 1)
      (org-latex-preview))))


(global-set-key (kbd "C-c n a") 'org-agenda)

(setq org-agenda-start-on-weekday nil)

(define-key org-mode-map (kbd "C-c C-o") 'my/follow-org-link)
(define-key org-mode-map (kbd "C-c C-y") 'my/indent-org-block-automatically)
(define-key org-mode-map (kbd "C-c ]") 'org-cite-insert)

(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'org-cdlatex-mode)
(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'post-self-insert-hook #'krofna-hack 'append 'local)))

(add-to-list 'org-latex-classes
             '("mla"
               "\\documentclass{mla}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
(add-to-list 'org-latex-classes
             '("letter"
               "\\documentclass{letter}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

(plist-put org-format-latex-options :scale 3)

(setq org-agenda-files (list org-directory (expand-file-name "ubc" org-directory)))
(setq org-agenda-tags-column 0)
(setq org-auto-align-tags nil)
(setq org-fold-catch-invisible-edits 'show-and-error)
(setq org-cite-export-processors '((t basic)))
(setq org-cite-global-bibliography (list zotero-bibliography))
(setq org-confirm-babel-evaluate nil)
(setq org-ellipsis "…")
(setq org-export-with-tags nil)
(setq org-hide-emphasis-markers t)
(setq org-highlight-latex-and-related '(latex))
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

(setq org-exports-dir (expand-file-name "exports" org-directory))

(setq org-publish-project-alist
      (list (cons "html"
                  (list :base-directory org-directory
                        :base-extension "org"
                        :htmlized-source t
                        :recursive t
                        :publishing-directory org-exports-dir
                        :publishing-function 'org-html-publish-to-html))
            (cons "pdf"
                  (list :base-directory org-directory
                        :base-extension "org"
                        :recursive t
                        :publishing-directory org-exports-dir
                        :publishing-function 'org-latex-publish-to-pdf))
            (cons "all" '(:components ("html" "pdf")))))

(add-hook 'org-mode-hook 'org-auctex-mode)

(add-hook 'dired-mode-hook 'org-download-enable)
(setq-default org-download-image-dir (expand-file-name "images" org-directory))

(add-hook 'org-mode-hook 'org-modern-mode)

(setq-default pdf-view-display-size 'fit-width)
(defvar pdf-annot-activate-created-annotations t)

(setq plantuml-default-exec-mode 'executable)

(define-key rustic-mode-map (kbd "C-c C-y") 'eglot-format-buffer)
(setq rustic-lsp-client 'eglot)

(defvar separedit-preserve-string-indentation t)
(global-set-key (kbd "C-c '") 'separedit)
(add-hook 'separedit-buffer-creation-hook 'normal-mode)

(load-theme 'solarized-gruvbox-dark t)

(global-set-key (kbd "C-s") 'swiper)

(setq yas-snippet-dirs (list (expand-file-name "snippets" org-directory)))

;; Accept 'y' and 'n' rather than 'yes' and 'no'.
(defalias 'yes-or-no-p 'y-or-n-p)

(provide 'init)
;;; init.el ends here
