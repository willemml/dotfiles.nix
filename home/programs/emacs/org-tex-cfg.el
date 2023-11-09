(require 'cdlatex)
(require 'citeproc)
(require 'gnuplot)
(require 'gnuplot-context)
(require 'graphviz-dot-mode)
(require 'htmlize)
(require 'ivy-bibtex)
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
(require 'org-auctex)
(require 'org-contrib)
(require 'org-download)
(require 'ox-latex)
(require 'ox-publish)
(require 'pdf-tools)
(require 'plantuml-mode)
(require 'tex)

(autoload 'gnuplot-mode "gnuplot" "Gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t)
(setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode)) auto-mode-alist))

(define-key graphviz-dot-mode-map (kbd "C-c C-y") 'graphviz-dot-indent-graph)

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
