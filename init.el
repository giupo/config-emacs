;;; init.el --- Giuseppe's modular Emacs config -*- lexical-binding: t; -*-

;; Determina la directory base della configurazione

;;; Code:
(defvar giu/config-dir
  (file-name-directory (or load-file-name buffer-file-name))
  "Percorso principale della configurazione di Giuseppe.")

;; Aggiungi la directory lisp/ al load-path
(add-to-list 'load-path (expand-file-name "config" giu/config-dir))

(require 'key-bindings)
(require 'ui)
(require 'ide)

;;; init.el ends here
