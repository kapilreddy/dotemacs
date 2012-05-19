;; All the key-bindings that I need to use
;; Copied from starter-kit

;; Font size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

;; Align your code in a pretty way.
(global-set-key (kbd "C-x \\") 'align-regexp)

;; Use regex searches by default.
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "\C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; Window switching. (C-x o goes to the next window)
(windmove-default-keybindings) ;; Shift+direction
(global-set-key (kbd "C-x O") (lambda () (interactive) (other-window -1))) ;; back one
(global-set-key (kbd "C-x C-o") (lambda () (interactive) (other-window 2))) ;; forward two

;; Start eshell or switch to it if it's active.
(global-set-key (kbd "C-x m") 'eshell)

;; Start a new eshell even if one is active.
(global-set-key (kbd "C-x M") (lambda () (interactive) (eshell t)))

;; Start a regular shell if you prefer that.
(global-set-key (kbd "C-x M-m") 'shell)

;; File finding
(global-set-key (kbd "C-x M-f") 'ido-find-file-other-window)
(if (fboundp 'find-file-in-project)(global-set-key (kbd "C-x C-M-f") 'find-file-in-project))
(if (fboundp 'recentf-ido-find-file) (global-set-key (kbd "C-x f") 'recentf-ido-find-file))
(global-set-key (kbd "C-c y") 'bury-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "M-`") 'file-cache-minibuffer-complete)
(global-set-key (kbd "C-x C-b") 'ibuffer)


;; magit
(global-set-key (kbd "C-x g") 'magit-status)

;; pop mark
(global-set-key (kbd "M-j") 'pop-to-mark-command)


;; Use 'Y' or 'N' to answer Yes/No
(defalias 'yes-or-no-p 'y-or-n-p)


;; End of key-bindings
(provide 'key-bindings)
