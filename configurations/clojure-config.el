;; Config taken from
;; https://github.com/ghoseb/dotemacs/tree/master/packs/clojure
(require 'rainbow-delimiters)
(require 'paredit)
(eval-after-load 'paredit
  '(progn
     (define-key paredit-mode-map (kbd "M-)") 'paredit-forward-slurp-sexp)
     (define-key paredit-mode-map (kbd "M-(") 'paredit-wrap-round)
     (define-key paredit-mode-map (kbd "M-[") 'paredit-wrap-square)
     (define-key paredit-mode-map (kbd "M-{") 'paredit-wrap-curly)))


(require 'clojure-mode)

(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("(\\(fn\\)[\[[:space:]]"
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "λ")
                               nil))))))

(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("\\(#\\)("
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "ƒ")
                               nil))))))

(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("\\(#\\){"
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "∈")
                               nil))))))

(eval-after-load 'find-file-in-project
  '(add-to-list 'ffip-patterns "*.clj"))

(add-hook 'clojure-mode-hook
          (lambda ()
            (enable-paredit-mode)
            (rainbow-delimiters-mode)
            (add-to-list 'ac-sources 'ac-source-yasnippet)
            (setq buffer-save-without-query t)))

;;Treat hyphens as a word character when transposing words
(defvar clojure-mode-with-hyphens-as-word-sep-syntax-table
  (let ((st (make-syntax-table clojure-mode-syntax-table)))
    (modify-syntax-entry ?- "w" st)
    st))

(defun transpose-words-with-hyphens (arg)
  "Treat hyphens as a word character when transposing words"
  (interactive "*p")
  (with-syntax-table clojure-mode-with-hyphens-as-word-sep-syntax-table
    (transpose-words arg)))

(define-key clojure-mode-map (kbd "M-t") 'transpose-words-with-hyphens)

(setq auto-mode-alist (append '(("\\.cljs$" . clojure-mode))
                              auto-mode-alist))


(remove-hook 'clojure-mode-hook 'clojure-test-maybe-enable)



;; Midje utility functions
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


(require 'cider)
(setq nrepl-log-messages t)
(setq cider-auto-mode nil)
(setq cider-prompt-for-symbol nil)
(setq nrepl-hide-special-buffers t)
(setq cider-prefer-local-resources t)
(setq cider-save-file-on-load nil)
(setq cider-save-file-on-load t)
(setq cider-eval-result-prefix "")


;; Clojur refactor config
;; (require 'clj-refactor)
;; (add-hook 'clojure-mode-hook (lambda ()
;;                                (clj-refactor-mode 1)
;;                                ;; insert keybinding setup here
;;                                ))
;; (cljr-add-keybindings-with-prefix "C-c C-m")


(provide 'clojure-config)
