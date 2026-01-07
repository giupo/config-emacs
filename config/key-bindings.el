;;; key-bindings.el --- general keybindings -*- lexical-binding: t; -*-

;;; Code:

(provide 'key-bindings)

;; Esempio: bind su F5 per compilare
(global-set-key (kbd "<f5>") #'compile)

;; Esempio: bind su F8 per ibuffer
(global-set-key (kbd "<f8>") #'ibuffer)

;; Bind su F9 per switchare tra header e implementation (C/C++)
(global-set-key (kbd "<f9>") #'ff-find-other-file)

;;; key-bindings.el ends here
