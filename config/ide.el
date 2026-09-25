;;; ide.el --- IDE setup for C/C++, Python, R -*- lexical-binding: t; -*-
;;; Commentary:

;;; Contents:
;; Stuff for IDE

;;; Code:

;;; Tree-sitter

;; --- tree-sitter recipes (EMACS 30 SAFE) -----------------

(add-to-list 'load-path "~/.config/emacs/vendor/spinner") ;; aggiorna il path
(require 'spinner)

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
)


;;; LSP-mode
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((c-mode c++-mode ess-r-mode go-mode csharp-ts-mode csharp-mode) . lsp-deferred)
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-enable-snippet t)
  (lsp-enable-indentation t)
  (lsp-diagnostics-provider :flycheck)
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
  (defun my-go-mode-setup ()
    (setq tab-width 2)
    (setq indent-tabs-mode t)) ;; usa TAB, non spazi
  
  (add-hook 'go-mode-hook #'my-go-mode-setup)
  )

;;; Python + Poetry
(use-package pyvenv
  :hook (python-mode . pyvenv-tracking-mode))

(use-package poetry
  :after python
  :config
  (poetry-tracking-mode)
  (setq poetry-tracking-strategy 'switch-buffer))

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred))))  ; or lsp-deferred
;;; R (ESS + LSP)
(use-package ess
  :commands R
  :config
  (require 'ess-r-mode))

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
  (company-selection-wrap-around t) ;; ciclare tra gli elementi
  )

;;; Projectile
(use-package projectile
  :diminish projectile-mode
  :init
  (projectile-mode +1)
  :custom
  (projectile-switch-project-action 'projectile-commander)
  (projectile-cache-file "~/.config/emacs/.cache/projectile.cache")
  (projectile-known-projects-file "~/.config/emacs/.cache/projectile-bookmarks.eld")
  (projectile-enable-caching t)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  )

;;; DAP Mode (Debug Adapter Protocol)
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :commands dap-debug
  :hook (dap-session-created . (lambda (&_rest) (dap-hydra)))
  :config
  (dap-auto-configure-mode)
  (require 'dap-python)
  (require 'dap-gdb-lldb)
  (setq dap-python-debugger 'debugpy)
  (dap-register-debug-template
   "C++ GDB"
   (list :type "gdb"
         :request "launch"
         :name "GDB"
         :gdbpath "gdb"
         :target nil
         :cwd "${workspaceFolder}"
         :args ""
         :stopAtEntry nil))
  (dap-ui-mode 1)
  ;; (dap-ui-locals-mode 1)
  :bind
  (("C-c d d" . dap-debug)
   ("C-c d b" . dap-breakpoint-toggle)
   ("C-c d r" . dap-debug-restart)
   ("C-c d l" . dap-debug-last)))

;;; Compilation buffer auto-close
(defun compilation-close-on-success (buffer string)
  "Close compilation buffer after 2 seconds if compilation was successful."
  (when (string-match "^finished" string)
    (run-with-timer 2 nil (lambda () 
                             (when (buffer-live-p buffer)
                               (delete-windows-on buffer)
                               (kill-buffer buffer))))))

; (add-hook 'compilation-finish-functions 'compilation-close-on-success)


;; C#

(defun my/find-dotnet-solution ()
  "Trova il file .slnx o .sln risalendo l'albero delle directory."
  (let* ((has-sln (lambda (dir)
                    (directory-files dir nil "\\.slnx?\\'" t 1)))
         (root (or (locate-dominating-file default-directory has-sln)
                   (locate-dominating-file default-directory ".git"))))
    (unless root
      (error "Non trovo la root del progetto .NET"))

    (or
     (car (directory-files root t "\\.slnx$"))
     (car (directory-files root t "\\.sln$"))
     (error "Trovata la root ma nessun file .slnx o .sln"))))

(defun my/dotnet-format-old ()
  (interactive)
  (let* ((solution (my/find-dotnet-solution))
         (default-directory (file-name-directory solution)))
    (async-shell-command
     (format "dotnet format \"%s\"" solution))))



(defun my/dotnet-format ()
  (interactive)
  (let* ((solution (my/find-dotnet-solution))
         (default-directory (file-name-directory solution))
         (cmd (format "dotnet format \"%s\" --exclude ./Legacy ./DontCare" solution))
         (buffer-name "*dotnet-format*")
         (buffer (get-buffer-create buffer-name)))
    (with-current-buffer buffer
      (erase-buffer))
    (let ((proc (start-process-shell-command
                 "dotnet-format"
                 buffer
                 cmd)))
      (set-process-sentinel
       proc
       (lambda (p _event)
         (when (and (eq (process-status p) 'exit)
                    (= (process-exit-status p) 0))
           ;; exit 0 → chiudi tutto
           (when-let* ((win (get-buffer-window buffer)))
             (delete-window win))
           (kill-buffer buffer)))))))




(use-package schlau-compile
  :ensure t
  :init
  
  ;; C/C++: CMake + Ninja se c'è un CMakeLists.txt nella root, altrimenti make
  (defconst ga/cppninja "cd %G && if [ -f CMakeLists.txt ]; then mkdir -p build && cd build && echo \"Entering directory '%G/build'\" && cmake -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DENABLE_CODE_ANALYSIS=ON .. && ninja -k3 -j8; else make -k; fi")
  (defconst ga/rustmake "cd %G && RUST_BACKTRACE=1 ~/.cargo/bin/cargo build && ~/.cargo/bin/cargo test -- --nocapture")
  (defconst ga/rubymake "cd %G && rake build")
  (defconst ga/gomake  "cd %G && export GOPATH=/development/go ; go install ./... && go test -v && go vet")
  (defconst ga/hackage "cd %G && stack build --allow-different-user && stack test")
  (defconst ga/pythonmake "cd %G && uv run pytest -v -x --cov")

  (setq schlau-compile-alist
        `((haskell-mode   . ,ga/hackage)
          (yaml-mode      . ,ga/hackage)
          (go-mode        . ,ga/gomake)
          (go-ts-mode     . ,ga/gomake)
          (c-mode         . ,ga/cppninja)
          (c-ts-mode      . ,ga/cppninja)
          (c++-mode       . ,ga/cppninja)
          (c++-ts-mode    . ,ga/cppninja)
          (cmake-mode     . ,ga/cppninja)
          (cmake-ts-mode  . ,ga/cppninja)
          ("CMakeLists\\.txt\\'" . ,ga/cppninja)
          (rust-mode      . ,ga/rustmake)
          (rust-ts-mode   . ,ga/rustmake)
          (toml-mode      . ,ga/rustmake)
          (ruby-mode      . ,ga/rubymake)
          (python-mode    . ,ga/pythonmake)
          (python-ts-mode . ,ga/pythonmake)))

  ;; %G è nil fuori da un repo git (e schlau-compile va in errore):
  ;; ripiega sulla root projectile o sulla directory del file
  (advice-add 'schlau-compile-git-root-path :filter-return
              (lambda (root)
                (or root
                    (and (fboundp 'projectile-project-root)
                         (projectile-project-root))
                    default-directory)))

  (global-set-key [f5] 'schlau-compile-compile)
  (global-set-key [f6] 'schlau-compile-query)
  (global-set-key [C-f6] 'kill-compilation)
  )

(with-eval-after-load 'compile
  (add-to-list 'compilation-error-regexp-alist 'pytest-nodeid)
  (add-to-list 'compilation-error-regexp-alist-alist
               '(pytest-nodeid
                 "^\\([^:\n]+\\.py\\)::[^[:space:]]+\\s-+FAILED"
                 1 nil)))
(setq compilation-scroll-output t)


(defun my-compilation-close-on-success (buffer status)
  "Close BUFFER after success, but only for real compilation buffers.
Grep/rgrep buffers (and other compilation-mode derivatives meant
to be browsed, like occur) are left alone so they stay open for
navigation and editing."
  (when (and (string-match-p "\\`finished" status)
             (with-current-buffer buffer
               (not (derived-mode-p 'grep-mode))))
    (run-at-time
     5 nil
     (lambda (buffer)
       (when (buffer-live-p buffer)
         (let ((window (get-buffer-window buffer)))
           (when window
             (delete-window window))
           (kill-buffer buffer))))
     buffer)))

(add-hook 'compilation-finish-functions #'my-compilation-close-on-success)


(provide 'ide)

;;; ide.el ends here
