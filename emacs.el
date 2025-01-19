;; Start in fullscreen by default
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Package Initialization

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; Ensure use-package is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Ensure that the use-package is always used
(eval-when-compile
  (require 'use-package))

;; Package setup

(use-package kanagawa-themes
  :ensure t)

;; (use-package dracula-theme :ensure t)

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))

(use-package smex
  :ensure t)

(use-package treemacs
  :ensure t)

(use-package eat
  :ensure t)

(use-package go-mode
  :ensure t)

(use-package nix-mode
  :ensure t)

(use-package sudo-edit
  :ensure t)

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-use-childframe t
        lsp-ui-doc-position 'top
        lsp-ui-doc-include-signature t
        lsp-ui-sideline-enable t
        lsp-ui-flycheck-enable t
        lsp-ui-sideline-ignore-duplicate t))

(use-package rust-mode
  :hook (rust-mode . lsp-deferred))

(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default standard-indent 2)

(setq explicit-shell-file-name "bash")

;; Wraps words instead of letters
(global-visual-line-mode 1)

(menu-bar-mode 0)
(tool-bar-mode 0)
(ido-mode 1)

;; C-mode indentation does align a function arg after a line-break
;; at the end of the above statement -> This hook changes this behavior
(defun c-mode-indentation-deretard-hook ()
  (setq c-basic-offset 2)

  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-cont-nonempty '(+ . 2))
  (c-set-offset 'arglist-close 0)
)

(add-hook 'c-mode-common-hook 'c-mode-indentation-deretard-hook)


(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; Set compile command to ""
(setq compile-command "")

;; Keybinds

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-r") 'redo)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-d") 'goto-line)
(global-set-key (kbd "C-x j") 'undo-tree-visualize)
(global-set-key (kbd "C-x c") 'comment-dwim)
(global-set-key (kbd "C-t") 'treemacs)
(global-set-key (kbd "C-<") 'treemacs-switch-workspace)
;; Use system clipboard instead of emacs kill ring
(global-set-key (kbd "M-w") 'clipboard-kill-ring-save)
(global-set-key (kbd "C-w") 'clipboard-kill-region)
(global-set-key (kbd "C-y") 'clipboard-yank)
(global-set-key (kbd "C-v") 'clipboard-yank)
;; C-q is catched before it is passed to any subprocess
;; no terminal fucks with my window switching keybinds
(define-key input-decode-map (kbd "C-q") [override-window-switch])
(global-set-key [override-window-switch] 'other-window)
;; C-b is also inevitable
;; switches to the last buffer in that window
(define-key input-decode-map (kbd "C-b") [override-buffer-switch])
(global-set-key [override-buffer-switch]
                (lambda ()
                  (interactive)
                  (switch-to-buffer (other-buffer))
                  ))
;; Find definition
(global-set-key (kbd "C-<return>") 'xref-find-definitions)

(defun mark-fullword ()
  "Mark the whole word selected by cursor"
  (interactive)
  (backward-word)
  (mark-word))

(global-set-key (kbd "C-c C-x") 'mark-fullword)
(global-set-key (kbd "C-c C-f") 'mark-defun)
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)

(defun force-kill-buffer ()
  (interactive)
  (let ((process (get-buffer-process (current-buffer))))
    (when process
      (set-process-query-on-exit-flag process nil)
      (kill-process process))
    (kill-buffer (current-buffer))))

(global-set-key (kbd "C-x C-k") 'force-kill-buffer)

(with-eval-after-load 'lsp-mode
  (define-key lsp-mode-map (kbd "C-c d") 'lsp-ui-doc-show)
  (define-key lsp-mode-map (kbd "C-c f") 'lsp-describe-thing-at-point)
  (define-key lsp-mode-map (kbd "C-f") 'company-complete)
  (define-key lsp-mode-map (kbd "C-c m") 'flymake-show-buffer-diagnostics))


(global-set-key (kbd "C-c t") 'start-terminal)

(defun start-terminal ()
  (interactive)
  (let ((new-window (split-window nil -10 'below))
        (default-directory (or (buffer-local-value 'default-directory (current-buffer))
                               default-directory)))
    (select-window new-window)
    (eat "bash")))

(add-hook 'eat-mode-hook (lambda () (display-line-numbers-mode -1)))


(add-hook 'treemacs-mode-hook (lambda () (display-line-numbers-mode -1)))

;; Visual configuration

(set-frame-font "Iosevka Medium-12" nil t)
(set-fontset-font t 'unicode "Nerd Font Mono" nil 'prepend)
(scroll-bar-mode -1)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(load-theme 'kanagawa-wave t)
;; This one is cool aswell
;;(load-theme 'misterioso)
;; Or this
;;(load-theme 'tango-dark)

;; Additional configuration

;; Add gopath
(setenv "PATH" (concat "~/go/bin:" (getenv "PATH")))
(add-to-list 'exec-path "~/go/bin")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(treemacs yaml-mode vterm undo-tree smex protobuf-mode lsp-ui kanagawa-themes go-mode flylisp dracula-theme company bazel)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
