(require 'espresso)
(add-to-list 'auto-mode-alist '("\\.js$" . espresso-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . espresso-mode))
(setq espresso-indent-level 2)

(setq-default indent-tabs-mode nil)


(eval-after-load 'espresso-mode
  '(progn (define-key espresso-mode-map "{" 'paredit-open-curly)
          (define-key espresso-mode-map "}" 'paredit-close-curly-and-newline)
          ;; fixes problem with pretty function font-lock
          (define-key espresso-mode-map (kbd ",") 'self-insert-command)

          (font-lock-add-keywords
           'espresso `(("\\(function *\\)("
                             (0 (progn (compose-region (match-beginning 1)
                                                       (match-end 1) "ƒ")
                                       nil)))))))




(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)

(add-hook 'espresso-mode-hook 'espresso-custom-setup)
(defun espresso-custom-setup ()
  (moz-minor-mode 1)
  (paredit-mode t))

;; (require 'flymake-cursor)
;; (add-path "/packages/lintnode")
;; (require 'flymake-jslint)

;; ;; Make sure we can find the lintnode executable
;; (setq lintnode-location "~/.emacs.d/kapil/packages/lintnode")

;; ;; Start the server when we first open a js file and start checking
;; (add-hook 'javascript-mode-hook
;;           (lambda ()
;;             (lintnode-hook))) 

(provide 'js-mode-config)
