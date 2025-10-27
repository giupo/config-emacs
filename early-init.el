;;; early-init.el --- Early initialization -*- lexical-binding: t -*-

;; Impedisci a package.el di caricare i pacchetti prima di init.el
(setq package-enable-at-startup nil)

;; Evita che Emacs ridimensioni il frame in base al font o alle impostazioni
(setq frame-inhibit-implied-resize t)

;; Disattiva UI elements *prima* che vengano creati i frame
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

;; Evita di mostrare messaggi inutili all’avvio
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t
      inhibit-startup-screen t)

;; Imposta il garbage collector più permissivo durante l’avvio
(setq gc-cons-threshold most-positive-fixnum)
(setq gc-cons-percentage 0.6)

;; Disattiva la ridistribuzione temporanea dei font all’avvio
(setq inhibit-compacting-font-caches t)

;; Rende il frame iniziale più pulito
(setq frame-title-format nil)

;; Non creare file di backup (~)
(setq make-backup-files nil)

;; Non creare file di auto-salvataggio (#file#)
(setq auto-save-default nil)


(provide 'early-init)

;;; early-init.el ends here
