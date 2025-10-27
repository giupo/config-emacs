;;; init.el --- Giuseppe's modular Emacs config -*- lexical-binding: t; -*-

;; Determina la directory base della configurazione
(defvar giu/config-dir
  (file-name-directory (or load-file-name buffer-file-name))
  "Percorso principale della configurazione di Giuseppe.")

;; Aggiungi la directory lisp/ al load-path
(add-to-list 'load-path (expand-file-name "config" giu/config-dir))

(require 'key-bindings)
(require 'ui)
(require 'ide)

;;; init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
