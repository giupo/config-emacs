;;; ide.el --- IDE setup for C/C++, Python, R -*- lexical-binding: t; -*-

;;; Tree-sitter
(use-package treesit
  :ensure nil  ;; integrato in Emacs 29+
  :custom
  (treesit-language-source-alist
   '((c . ("https://github.com/tree-sitter/tree-sitter-c"))
     (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
     (python . ("https://github.com/tree-sitter/tree-sitter-python"))
     (r . ("https://github.com/r-lib/tree-sitter-r"))))
  :config
  (dolist (lang '(c cpp python r))
    (unless (treesit-language-available-p lang)
      (treesit-install-language-grammar lang))))

;;; LSP-mode
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((c-mode c++-mode python-mode ess-r-mode) . lsp-deferred)
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-enable-snippet t)
  (lsp-enable-indentation t)
  (lsp-prefer-flymake nil)
  (lsp-idle-delay 0.2))

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-delay 0.3)
  (lsp-ui-sideline-enable t))

;;; Debugging
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-auto-configure-mode)
  (require 'dap-python)
  (require 'dap-lldb)
  (require 'dap-gdb-lldb))

;;; Completamento (usa Corfu, più moderno di company)
(use-package corfu
  :ensure t
  :init (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-cycle t))

(use-package kind-icon
  :ensure t
  :after corfu
  :custom (kind-icon-default-face 'corfu-default)
  :config (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;;; Python + Poetry
(use-package pyvenv
  :ensure t
  :hook (python-mode . pyvenv-tracking-mode))

(use-package poetry
  :ensure t
  :after python
  :config
  (poetry-tracking-mode)
  (setq poetry-tracking-strategy 'switch-buffer))

;;; R (ESS + LSP)
(use-package ess
  :ensure t
  :commands R
  :config
  (require 'ess-r-mode))

(use-package lsp-r
  :ensure nil
  :after (lsp-mode ess)
  :hook (ess-r-mode . lsp-deferred))

;;; Flycheck (linting)
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))


(provide 'ide)

;;; ide.el ends here
