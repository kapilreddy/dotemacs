(require 'yasnippet)

(yas/initialize)

(setq yas/root-directory (concat config-basedir "etc/snippets"))

;; Load the snippets
(yas/load-directory yas/root-directory)

(provide 'yas)
