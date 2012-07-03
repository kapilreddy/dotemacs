;; Slime config
(add-path "packages/slime")
(add-path "packages/clojure-mode")
(require 'slime)
(require 'clojure-mode)
(slime-setup '(slime-repl))
(add-to-list 'slime-lisp-implementations '(sbcl ("sbcl")))

;;; Slime/Lisp/Paredit
(defun clojure-paredit-hook ()
  (require 'paredit)
  (paredit-mode 1)
  (define-key slime-mode-map (kbd "C-c w") 'paredit-wrap-sexp)
  (define-key slime-repl-mode-map (kbd "C-c w") 'paredit-wrap-sexp)
  (add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1))))

(add-hook 'clojure-mode-hook 'clojure-paredit-hook)
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

(add-hook 'slime-repl-mode-hook (lambda ()
				  (paredit-mode +1)))

(defun clojure-in-tests-p ()
  (or (string-match-p "test\." (clojure-find-ns))
      (string-match-p "/test" (buffer-file-name))))


(defun midje-test-for (namespace)
  (let* ((namespace (clojure-underscores-for-hyphens namespace))
         (segments (split-string namespace "\\."))
         (test-segments (append (list "test") segments)))
    (mapconcat 'identity test-segments "/")))


(defun midje-jump-to-test ()
  "Jump from implementation file to test."
  (interactive)
  (find-file (format "%s/%s_test.clj"
                     (file-name-as-directory
                      (locate-dominating-file buffer-file-name "src/"))
                     (midje-test-for (clojure-find-ns)))))


(defun midje-implementation-for (namespace)
  (let* ((namespace (clojure-underscores-for-hyphens namespace))
         (segments (split-string (replace-regexp-in-string "_test" "" namespace) "\\.")))
    (mapconcat 'identity segments "/")))


(defun midje-jump-to-implementation ()
  "Jump from midje test file to implementation."
  (interactive)
  (find-file (format "%s/src/%s.clj"
                     (locate-dominating-file buffer-file-name "src/")
                     (midje-implementation-for (clojure-find-package)))))


(defun midje-jump-between-tests-and-code ()
  (interactive)
  (if (clojure-in-tests-p)
      (midje-jump-to-implementation)
    (midje-jump-to-test)))


(define-key clojure-mode-map (kbd "C-c t") 'midje-jump-between-tests-and-code)

(provide 'clojure-config)
