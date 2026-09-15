;;; myorg.el --- Org mode  config -*- lexical-binding: t; -*-
;;; Commentary:
;;; Some config for Org


;;; ---------------------------------------------------------------------------
;;; Org Mode
;;; ---------------------------------------------------------------------------

;;; Code:

(use-package org
  :ensure t

  :init
  ;; Directory principale di Org
  (setq org-directory "~/org/")

  ;; Crea la directory se non esiste
  (unless (file-directory-p org-directory)
    (make-directory org-directory t))

  ;; File principali
  (setq org-inbox-file    (expand-file-name "inbox.org" org-directory)
        org-tasks-file    (expand-file-name "tasks.org" org-directory)
        org-projects-file (expand-file-name "projects.org" org-directory)
        org-notes-file    (expand-file-name "notes.org" org-directory)
        org-journal-file  (expand-file-name "journal.org" org-directory))

  ;; Crea i file principali se non esistono
  (dolist (file (list org-inbox-file
                      org-tasks-file
                      org-projects-file
                      org-notes-file
                      org-journal-file))
    (unless (file-exists-p file)
      (write-region "" nil file)))

  :custom

  ;; -------------------------------------------------------------------------
  ;; Agenda
  ;; -------------------------------------------------------------------------

  (org-agenda-files
   (list org-inbox-file
         org-tasks-file
         org-projects-file))

  (org-agenda-span 14)
  (org-agenda-start-with-log-mode t)
  (org-agenda-start-on-weekday nil)

  ;; Mostra anche le attività scadute nei giorni precedenti
  (org-agenda-skip-scheduled-if-done t)
  (org-agenda-skip-deadline-if-done t)

  ;; Quanti giorni prima segnalare una deadline
  (org-deadline-warning-days 7)

  ;; -------------------------------------------------------------------------
  ;; TODO states
  ;; -------------------------------------------------------------------------

  (org-todo-keywords
   '((sequence
      "TODO(t)"
      "NEXT(n)"
      "WAIT(w@)"
      "|"
      "DONE(d!)"
      "CANCELLED(c@)")))

  ;; Colori dei TODO states
  (org-todo-keyword-faces
   '(("TODO"      . warning)
     ("NEXT"      . "goldenrod")
     ("WAIT"      . "magenta")
     ("DONE"      . "forest green")
     ("CANCELLED" . "gray50")))

  ;; -------------------------------------------------------------------------
  ;; Priorità
  ;; -------------------------------------------------------------------------

  (org-priority-default ?B)
  (org-priority-highest ?A)
  (org-priority-lowest ?C)

  ;; -------------------------------------------------------------------------
  ;; Logging
  ;; -------------------------------------------------------------------------

  ;; Quando faccio DONE registra automaticamente data/ora
  (org-log-done 'time)

  ;; WAIT / altri cambiamenti vengono registrati nel LOGBOOK
  (org-log-into-drawer t)

  ;; -------------------------------------------------------------------------
  ;; Archiviazione
  ;; -------------------------------------------------------------------------

  (org-archive-location
   (expand-file-name "archive/%s_archive::" org-directory))

  ;; -------------------------------------------------------------------------
  ;; Refile
  ;; -------------------------------------------------------------------------

  ;; C-c C-w permette di spostare un task in un'altra posizione
  (org-refile-targets
   '((org-agenda-files :maxlevel . 3)))

  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)

  ;; -------------------------------------------------------------------------
  ;; Visualizzazione
  ;; -------------------------------------------------------------------------

  (org-startup-indented t)
  (org-startup-folded 'content)

  ;; Nasconde i * iniziali
  (org-hide-leading-stars t)

  ;; Fontifica intere righe degli heading
  (org-fontify-whole-heading-line t)

  ;; Fontifica i blocchi quote/example
  (org-fontify-quote-and-verse-blocks t)

  ;; -------------------------------------------------------------------------
  ;; Editing
  ;; -------------------------------------------------------------------------

  ;; Tab dentro una tabella fa il comportamento corretto
  (org-return-follows-link t)

  ;; Enter dopo un heading crea il nuovo heading allo stesso livello
  (org-M-RET-may-split-line '((default . t)))

  ;; -------------------------------------------------------------------------
  ;; Checkbox
  ;; -------------------------------------------------------------------------

  (org-enforce-todo-dependencies t)

  ;; -------------------------------------------------------------------------
  ;; Links
  ;; -------------------------------------------------------------------------

  (org-return-follows-link t)

  ;; -------------------------------------------------------------------------
  ;; Babel
  ;; -------------------------------------------------------------------------

  ;; Linguaggi abilitati per source blocks
  (org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)
     (C . t)))

  ;; Non chiedere conferma ogni volta che eseguo un source block
  (org-confirm-babel-evaluate nil)

  ;; -------------------------------------------------------------------------
  ;; Export
  ;; -------------------------------------------------------------------------

  ;; Syntax highlighting nei blocchi esportati
  (org-src-fontify-natively t)

  ;; -------------------------------------------------------------------------
  ;; Clock
  ;; -------------------------------------------------------------------------

  (org-clock-persist 'history)
  (org-clock-in-resume t)
  (org-clock-out-remove-zero-time-clocks t)

  :bind
  (;; Agenda
   ("C-c a" . org-agenda)

   ;; Capture
   ("C-c c" . org-capture)

   ;; Store link
   ("C-c l" . org-store-link)

   ;; Open link
   ("C-c o" . org-open-at-point)

   ;; Clock
   ("C-c C-x i" . org-clock-in)
   ("C-c C-x o" . org-clock-out)
   ("C-c C-x C-x" . org-clock-in-last))

  :config

  ;; Assicura che la directory archive esista
  (let ((archive-dir (expand-file-name "archive" org-directory)))
    (unless (file-directory-p archive-dir)
      (make-directory archive-dir t)))

  ;; Ripristina il clock history
  (org-clock-persistence-insinuate))


;;; ---------------------------------------------------------------------------
;;; Org Capture
;;; ---------------------------------------------------------------------------

(use-package org-capture
  :ensure nil
  :after org

  :custom
  (org-capture-templates
   `(
     ;; -----------------------------------------------------------------------
     ;; Task
     ;; -----------------------------------------------------------------------

     ("t" "Task"
      entry
      (file+headline ,org-inbox-file "Inbox")
      "* TODO %?\n  %U\n")

     ;; -----------------------------------------------------------------------
     ;; Next action
     ;; -----------------------------------------------------------------------

     ("n" "Next action"
      entry
      (file+headline ,org-tasks-file "Tasks")
      "* NEXT %?\n  %U\n")

     ;; -----------------------------------------------------------------------
     ;; Nota
     ;; -----------------------------------------------------------------------

     ("N" "Note"
      entry
      (file+headline ,org-notes-file "Notes")
      "* %?\n  %U\n")

     ;; -----------------------------------------------------------------------
     ;; Progetto
     ;; -----------------------------------------------------------------------

     ("p" "Project"
      entry
      (file+headline ,org-projects-file "Projects")
      "* TODO %?\n  :project:\n  %U\n")

     ;; -----------------------------------------------------------------------
     ;; Waiting
     ;; -----------------------------------------------------------------------

     ("w" "Waiting"
      entry
      (file+headline ,org-tasks-file "Waiting")
      "* WAIT %?\n  :waiting:\n  %U\n")

     ;; -----------------------------------------------------------------------
     ;; Journal
     ;; -----------------------------------------------------------------------

     ("j" "Journal"
      entry
      (file+datetree ,org-journal-file)
      "* %U\n\n%?\n")
     )))


;;; ---------------------------------------------------------------------------
;;; Org Modern
;;; ---------------------------------------------------------------------------

(use-package org-modern
  :ensure t
  :after org

  :hook
  (org-mode . org-modern-mode)

  :custom
  ;; Stelle degli heading
  (org-modern-star 'replace)

  ;; Checkbox
  (org-modern-checkbox
   '((?X . "☑")
     (?- . "◐")
     (?\  . "☐")))

  ;; Liste
  (org-modern-list
   '((?+ . "•")
     (?- . "–")
     (?* . "◦")))

  ;; Tabelle
  (org-modern-table nil)

  ;; Tag
  (org-modern-tag t)

  ;; Priority
  (org-modern-priority t)

  ;; TODO keywords
  (org-modern-todo t))


;;; ---------------------------------------------------------------------------
;;; Org Super Agenda
;;; ---------------------------------------------------------------------------

(use-package org-super-agenda
  :ensure t
  :after org

  :config

  (org-super-agenda-mode 1)

  (setq org-super-agenda-groups
        '((:name "🔥 Important"
           :priority "A")

          (:name "➡️ Next"
           :todo "NEXT")

          (:name "📅 Today"
           :time-grid t)

          (:name "⏳ Waiting"
           :todo "WAIT")

          (:name "📌 Projects"
           :tag "project")

          (:name "📥 Inbox"
           :file-path "inbox\\.org")

          (:name "Other"
           :anything t))))


;;; ---------------------------------------------------------------------------
;;; Org ID
;;; ---------------------------------------------------------------------------

(use-package org-id
  :ensure nil
  :after org
  :custom
  (org-id-link-to-org-use-id 'create-if-interactive))


;;; ---------------------------------------------------------------------------
;;; Org Tempo
;;; ---------------------------------------------------------------------------

(use-package org-tempo
  :ensure nil
  :after org
  :config
  ;; Permette:
  ;;
  ;; <s TAB
  ;;
  ;; per creare:
  ;;
  ;; #+begin_src
  ;;
  ;; ecc.
  )

;;; ---------------------------------------------------------------------------
;;; Org appearance
;;; ---------------------------------------------------------------------------

(defun my/org-mode-setup ()
  "Personal setup for Org mode."
  (visual-line-mode 1)
  (variable-pitch-mode 1))

(add-hook 'org-mode-hook #'my/org-mode-setup)

(provide 'myorg)

;;; myorg.el ends here
