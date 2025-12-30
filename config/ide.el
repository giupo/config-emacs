;;; ide.el --- IDE setup for C/C++, Python, R -*- lexical-binding: t; -*-

;;; Code:

;;; Tree-sitter

;; --- tree-sitter recipes (EMACS 30 SAFE) -----------------
(setq treesit-language-source-alist
      '((c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (bash "https://github.com/tree-sitter/tree-sitter-bash")
        (cmake "https://github.com/uyha/tree-sitter-cmake")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (elisp "https://github.com/Wilfred/tree-sitter-elisp")))


(use-package treesit
  :ensure nil  ;; integrato in Emacs 29+
  :config
  (dolist (lang '(c cpp python r))
    (unless (treesit-language-available-p lang)
      (treesit-install-language-grammar lang))))

;;; LSP-mode
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((c-mode c++-mode python-mode ess-r-mode go-mode) . lsp-deferred)
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-enable-snippet t)
  (lsp-enable-indentation t)
  (lsp-prefer-flymake nil)
  (lsp-idle-delay 0.2))

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-delay 0.3)
  (lsp-ui-sideline-enable t))


;;; Go mode

(use-package go-mode
  :mode "\\.go\\'"
  :config
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  )

;;; Python + Poetry
(use-package pyvenv
  :hook (python-mode . pyvenv-tracking-mode))

(use-package poetry
  :after python
  :config
  (poetry-tracking-mode)
  (setq poetry-tracking-strategy 'switch-buffer))

;;; R (ESS + LSP)
(use-package ess
  :commands R
  :config
  (require 'ess-r-mode))

(use-package lsp-r
  :ensure nil
  :after (lsp-mode ess)
  :hook (ess-r-mode . lsp-deferred))

;;; Flycheck (linting)
(use-package flycheck
  :init (global-flycheck-mode))


(use-package magit
  :ensure t
  :commands (magit-status magit-blame)
  :bind (("C-x g" . magit-status)          ;; apri il buffer di status
         ("C-x M-g" . magit-dispatch)))    ;; menu completo

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))


(use-package company
  :diminish company-mode
  :hook
  (after-init . global-company-mode)
  (go-mode . company-mode)
  :custom
  (company-idle-delay 0.1)       ;; tempo prima che appaia il popup
  (company-minimum-prefix-length 1) ;; inizia a completare dopo 1 carattere
  (company-tooltip-align-annotations t) ;; allinea annotazioni
  (company-selection-wrap-around t))     ;; ciclare tra gli elementi


(provide 'ide)

;;; ide.el ends here
