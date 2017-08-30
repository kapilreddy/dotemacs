;; From URL: http://www.emacswiki.org/cgi-bin/wiki/Prelude
(require 'package)

(url-retrieve
 "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el"
 (lambda (s)
   (goto-char (point-max))
   (eval-print-last-sexp)))
(defvar required-packages
  '(magit paredit clojure-mode hippie-expand-slime
          yasnippet ac-slime rainbow-delimiters cljsbuild-mode
          nrepl durendal))

(dolist (p required-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(provide 'packages)
