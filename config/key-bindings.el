;;; key-bindings.el --- general keybindings -*- lexical-binding: t; -*-

;;; Code:

(provide 'key-bindings)

;; Esempio: bind su F8 per ibuffer
(global-set-key (kbd "<f8>") #'ibuffer)

;; Bind su F9 per switchare tra header e implementation (C/C++)
(global-set-key (kbd "<f9>") #'ff-find-other-file)

;; Dove cercare l'altro file: oltre a "." gestisce layout tipo
;; src/core/foo.c <-> src/core/include/core/foo.h
(setq cc-search-directories
      '("." "./include/*" "../.." "/usr/include" "/usr/local/include/*"))

;;; key-bindings.el ends here
