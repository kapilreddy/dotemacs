;; From URL: http://www.emacswiki.org/cgi-bin/wiki/Prelude
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(package-refresh-contents)

(defvar required-packages
  '(magit paredit clojure-mode hippie-expand-slime
          yasnippet ac-slime))

(dolist (p required-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(provide 'packages)
