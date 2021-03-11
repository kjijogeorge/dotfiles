(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

(custom-set-variables
 '(markdown-command "/usr/bin/markdown_py-3.6"))

(require 'ido)
(ido-mode)
(ido-everywhere 1)

(require 'helm)
(global-set-key (kbd "M-x") 'helm-M-x)

(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

(require 'py-autopep8)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

(setq inhibit-splash-screen t)

;; Enable transient mark mode
(transient-mark-mode 1)

;;;;Org mode configuration
;; Enable Org mode
(require 'org)
;; Make Org mode work with files ending in .org
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; The above is the default in recent emacsen

(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

;; Highlight tabs and trailing whitespace everywhere
;; (setq whitespace-style '(face trailing tabs))
;; (custom-set-faces
;;  '(whitespace-tab ((t (:background "red")))))
;; (global-whitespace-mode)(setq whitespace-style '(face tabs))
;; (whitespace-mode)

;; make whitespace-mode use just basic coloring
;;(setq whitespace-style (quote (spaces tabs newline space-mark tab-mark newline-mark)))
;; (setq whitespace-display-mappings
;;   ;; all numbers are Unicode codepoint in decimal. ⁖ (insert-char 182 1)
;;   '(
;;     (space-mark 32 [183] [46]) ; 32 SPACE 「 」, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
;;     (newline-mark 10 [182 10]) ; 10 LINE FEED
;;     (tab-mark 9 [9655 9] [92 9]) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」
;;     ))

(set-face-attribute 'whitespace-space nil :background nil :foreground "gray30")
