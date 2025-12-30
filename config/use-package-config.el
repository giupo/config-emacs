;;; use-package-config.el --- Giuseppe's Emacs config -*- lexical-binding: t; -*-
;;; Commentary:
;;; Fuck it.


;;; Code:
;; Assicurati che package.el non abbia già fatto nulla in early-init.el

(require 'package)
(require 'core-network)

;; Aggiungi i repository
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

;; Inizializza il sistema di package se non lo è già
(unless package--initialized
  (package-initialize))

;; Aggiorna la lista dei pacchetti se mancante
(unless package-archive-contents
  (package-refresh-contents))

;; Installa use-package se non presente
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Carica use-package
(require 'use-package)

;; Imposta use-package per installare automaticamente i pacchetti mancanti
(setq use-package-always-ensure t)


(provide 'use-package-config)

;;; use-package-config.el ends here

