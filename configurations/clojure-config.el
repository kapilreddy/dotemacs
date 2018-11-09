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
            ;; (add-to-list 'ac-sources 'ac-source-yasnippet)
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


(require 'cider)
(setq cider-font-lock-dynamically '(macro core function var))
(setq nrepl-log-messages t)
(setq cider-auto-mode t)
(setq cider-prompt-for-symbol nil)
(setq nrepl-hide-special-buffers t)
(setq cider-prefer-local-resources t)
(setq cider-save-file-on-load nil)
(setq cider-save-file-on-load t)
(setq cider-eval-result-prefix "")

(add-hook 'cider-repl-mode-hook 'paredit-mode)
;; Clojur refactor config
(require 'clj-refactor)
(add-hook 'clojure-mode-hook (lambda ()
                               (clj-refactor-mode 1)
                               ;; insert keybinding setup here
                               ))
(cljr-add-keybindings-with-prefix "C-c C-m")

(require 'cljr-helm)
(setq clj-add-ns-to-blank-clj-files nil)
(define-key clojure-mode-map (kbd "C-c C-r") 'cljr-helm)

(defun jump-to-prev-comment ()
  (interactive)
  (search-backward-regexp "^;; \\([-+[:digit:]]+\\)")
  (let ((text-scale-mode-amount (string-to-number (match-string 1))))
    (text-scale-mode +1)
    (recenter-top-bottom 'recenter-tb-top)))

(defun jump-to-next-comment ()
  (interactive)
  (search-forward-regexp "^;; \\([-+[:digit:]]+\\)")
  (let ((text-scale-mode-amount (string-to-number (match-string 1))))
    (text-scale-mode +1)
    (recenter-top-bottom 'recenter-tb-top)))

(define-key clojure-mode-map (kbd "M-1") 'jump-to-prev-comment)
(define-key clojure-mode-map (kbd "M-2") 'jump-to-next-comment)

(require 'smooth-scrolling)
;; scroll one line at a time (less "jumpy" than defaults)
(smooth-scrolling-mode 1)

(custom-set-variables
 '(scroll-conservatively 1000)
 '(scroll-margin 3)
 )

(define-key clojure-mode-map (kbd "C-c M-h") 'hlt-highlight-region)
(define-key clojure-mode-map (kbd "C-c M-x") 'hlt-unhighlight-region)

(require 'sesman)
(setq sesman-use-friendly-sessions t)


(global-company-mode)

(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'eldoc-mode)
(add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
(add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)

(setq company-idle-delay nil) ; never start completions automatically

(global-set-key (kbd "M-TAB") #'company-complete)
(setq cider-jdk-src-paths '("/Users/kapil/Work/moby/java-sources/"))
(setq cider-special-mode-truncate-lines nil)
(provide 'clojure-config)
