(require 'clojure-mode)

(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))

(defun clojurescript-repl ()
 (interactive)
 (run-lisp "/Users/kapil/.bin/lein2 trampoline cljsbuild repl-listen"))

(provide 'cljs-config)
