;;; key-bindings.el --- general keybindings -*- lexical-binding: t; -*-

;;; Code:

(provide 'key-bindings)

;; Bind su F5 per compilare (C/C++ smart, altrimenti fallback a compile)
(global-set-key (kbd "<f5>") #'projectile-compile-project)

;; Esempio: bind su F8 per ibuffer
(global-set-key (kbd "<f8>") #'ibuffer)

;; Bind su F9 per switchare tra header e implementation (C/C++)
(global-set-key (kbd "<f9>") #'ff-find-other-file)

;;; key-bindings.el ends here
