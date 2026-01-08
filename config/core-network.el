;;; core-network.el --- Configurazione proxy -*- lexical-binding: t; -*-


(defun ga/on-home-network-p ()
  "Ritorna t se l'IP locale indica la rete di casa."
  (let ((ip (shell-command-to-string "hostname -i 2>/dev/null")))
    (string-match-p "10\\.17\\.17\\." ip)))

(defun ga/setup-proxy-if-needed ()
  (unless (ga/on-home-network-p)
    (setq url-proxy-services
          '(("http"  . "127.0.0.1:3128")
            ("https" . "127.0.0.1:3128")
            ("no_proxy" . "localhost\\|127\\.0\\.0\\.1\\|::1")))))

(ga/setup-proxy-if-needed)

(defun ga/toggle-proxy ()
  (interactive)
  (if url-proxy-services
      (setq url-proxy-services nil)
    (setq url-proxy-services
          '(("http"  . "127.0.0.1:3128")
            ("https" . "127.0.0.1:3128"))))
  (message "Proxy %s" (if url-proxy-services "ON" "OFF")))


(provide 'core-network)
