;;; key-bindings.el --- general keybindings -*- lexical-binding: t; -*-

;;; Code:

(provide 'key-bindings)

;; Esempio: bind su F5 per compilare
(global-set-key (kbd "<f5>") #'compile)

;; Esempio: bind su F8 per ibuffer
(global-set-key (kbd "<f8>") #'ibuffer)

;; Esempio: bind su F9 per switchare file
(global-set-key (kbd "<f9>") #'other-window)

;;; key-bindings.el ends here
