;; Slime config
(add-path "packages/slime")
(require 'slime)
(require 'clojure-mode)
(slime-setup '(slime-repl))
(add-to-list 'slime-lisp-implementations '(sbcl ("sbcl")))

;;; Slime/Lisp/Paredit
(define-key slime-mode-map (kbd "C-c w") 'paredit-wrap-sexp)
(define-key slime-repl-mode-map (kbd "C-c w") 'paredit-wrap-sexp)
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))
(add-hook 'slime-repl-mode-hook 'clojure-mode-font-lock-setup)
(setq slime-net-coding-system 'utf-8-unix)

;; auto-complete and hippie expand
;; http://stackoverflow.com/questions/4289480/how-to-do-automatic-expansion-or-autocomplete


;; https://github.com/purcell/ac-slime
;; needs auto-complete.el

(add-path "plugins/ac-slime")
(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)

;; https://github.com/purcell/emacs.d/blob/master/site-lisp/hippie-expand-slime/hippie-expand-slime.el

(add-path "plugins/hippie-expand-slime")
(require 'hippie-expand-slime)
(add-hook 'slime-mode-hook 'set-up-slime-hippie-expand)


(provide 'clojure-config)
