;;; ui.el --- UI config -*- lexical-binding: t; -*-

(require 'use-package-config)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(use-package all-the-icons)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-mode)
  )

(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  )

;; installa e configura dashboard
(use-package dashboard
  :ensure t
  :diminish
  :hook (after-init . dashboard-setup-startup-hook)
  :config
  ;; percorso immagine header (opzionale)
  (setq dashboard-startup-banner 'official) ;; logo Emacs ufficiale
  ;; oppure un file locale: (setq dashboard-startup-banner "~/.emacs.d/logo.png")

  ;; mostra 5 file recenti
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)
                          (bookmarks . 5)))

  ;; titolo del buffer
  (setq dashboard-banner-logo-title "Benvenuto in Emacs!")
  
  ;; centra header
  (setq dashboard-center-content t)
  
  ;; abbreviazioni dei simboli dei minor mode
  (setq dashboard-set-navigator t)
  
  )

(use-package doom-modeline
  :ensure t
  :init
  ;; Mostra subito la modeline anche se Emacs parte in demone
  (doom-modeline-mode 1)
  :custom
  ;; Numero di caratteri del nome del buffer (0 = intero)
  (doom-modeline-buffer-file-name-style 'truncate-except-project)
  ;; Mostra l’icona (richiede all-the-icons)
  (doom-modeline-icon t)
  ;; Mostra la percentuale nel buffer
  (doom-modeline-percent-position t)
  ;; Mostra il numero di linee totali
  (doom-modeline-total-line-number t)
  ;; Mostra l’ambiente di coding (UTF-8, ecc.)
  (doom-modeline-buffer-encoding t)
  ;; Mostra la posizione del cursore
  (doom-modeline-position-line-format '("%l:%c"))
  ;; Mostra il nome del progetto (projectile, ecc.)
  (doom-modeline-project-detection 'auto)
  ;; Mostra VCS branch
  (doom-modeline-vcs-max-length 20)
  ;; Aggiorna la modeline meno spesso (migliora performance)
  (doom-modeline-refresh-rate 2)
  )



(use-package vertico
  :ensure t
  :init (vertico-mode))

(use-package savehist
  :init (savehist-mode)) ;; ricorda la cronologia

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :init (marginalia-mode))

(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("C-x C-r" . consult-recent-file)
         ("C-x p" . consult-project-buffer)))

(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))




(provide 'ui)

;;; ui.el ends here
