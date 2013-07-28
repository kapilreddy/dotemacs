(require 'clojure-mode)

(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))

(require 'nrepl)

(defun piggie-back-brepl-cljs ()
  (interactive)
  (nrepl-send-string "(do  (require 'cljs.repl.browser) (cemerick.piggieback/cljs-repl :repl-env (doto (cljs.repl.browser/repl-env :port 9000) cljs.repl/-setup)))"
                     (nrepl-handler (current-buffer))))

(defun piggie-back-cljs ()
  (interactive)
  (nrepl-send-string "(cemerick.piggieback/cljs-repl)"
                     (nrepl-handler (current-buffer))))

(define-key clojure-mode-map (kbd "C-c p b r") 'piggie-back-brepl-cljs)
(define-key clojure-mode-map (kbd "C-c p r") 'piggie-back-cljs)

(provide 'cljs-config)
