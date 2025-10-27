;;; core-network.el --- Configurazione proxy -*- lexical-binding: t; -*-

;; Imposta il proxy per HTTP e HTTPS
(setq url-proxy-services
      '(("http"  . "127.0.0.1:3128")   ; cambia la porta se diversa
        ("https" . "127.0.0.1:3128")))

;; Se vuoi bypassare alcuni host locali
(setq url-proxy-services
      (append url-proxy-services
              '(("no_proxy" . "localhost\\|127\\.0\\.0\\.1\\|::1"))))

(provide 'core-network)
