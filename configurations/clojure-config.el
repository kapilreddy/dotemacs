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

;;auto-complete mode
(add-path "packages/auto-complete/")
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(ac-flyspell-workaround)


(setq ac-comphist-file (concat *tempfiles-dir* "ac-comphist.dat"))

(global-auto-complete-mode t)
(setq ac-auto-show-menu t)
(setq ac-dwim t)
(setq ac-use-menu-map t)
(setq ac-quick-help-delay 1)
(setq ac-quick-help-height 60)

(set-default 'ac-sources
             '(ac-source-dictionary
               ac-source-words-in-buffer
               ac-source-words-in-same-mode-buffers
               ac-source-words-in-all-buffer))

(dolist (mode '(magit-log-edit-mode
                log-edit-mode
                org-mode
                text-mode
                sass-mode
                yaml-mode
                csv-mode
                espresso-mode
                haskell-mode
                html-mode
                nxml-mode
                sh-mode
                clojure-mode
                lisp-mode
                textile-mode
                markdown-mode
                nrepl-mode))
  (add-to-list 'ac-modes mode))


;;ac-slime auto-complete plugin
;; (require 'ac-nrepl)

;; (add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
;; (add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
;; (eval-after-load "auto-complete"
;;   '(add-to-list 'ac-modes 'nrepl-mode))

;; (define-key nrepl-interaction-mode-map (kbd "C-c C-d") 'ac-nrepl-popup-doc)

;; (require 'durendal)
;; (add-hook 'slime-compilation-finished-hook 'durendal-hide-successful-compile)
;; (add-hook 'sldb-mode-hook 'durendal-dim-sldb-font-lock)

;; highlight expression on eval
;; (require 'highlight)
;; (require 'eval-sexp-fu)
;; (setq eval-sexp-fu-flash-duration 0.5)


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

(require 'clojure-mode)

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

(require 'nrepl)
(add-hook 'nrepl-interaction-mode-hook
          'nrepl-turn-on-eldoc-mode)

(setq nrepl-hide-special-buffers t)
(setq nrepl-tab-command 'indent-for-tab-command)
(setq nrepl-popup-stacktraces-in-repl t)
(add-to-list 'same-window-buffer-names "*nrepl*")
(add-hook 'nrepl-mode-hook 'enable-paredit-mode)
(add-hook 'nrepl-mode-hook (lambda ()
                                  (define-key nrepl-mode-map
                                    (kbd "DEL") 'paredit-backward-delete)
                                  (define-key nrepl-mode-map
                                    (kbd "{") 'paredit-open-curly)
                                  (define-key nrepl-mode-map
                                    (kbd "}") 'paredit-close-curly)
                                  (modify-syntax-entry ?\{ "(}")
                                  (modify-syntax-entry ?\} "){")
                                  (modify-syntax-entry ?\[ "(]")
                                  (modify-syntax-entry ?\] ")[")))


(remove-hook 'clojure-mode-hook 'clojure-test-maybe-enable)

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

(setq nrepl-port "4005")

(provide 'clojure-config)
