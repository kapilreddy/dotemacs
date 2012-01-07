;; Configuration for ido-mode

;; Setting ido 
(setq 
  ido-save-directory-list-file "~/.emacs.d/cache/ido.last"
  ido-case-fold  t
  ido-enable-last-directory-history t
  ido-max-work-directory-list 30
  ido-max-work-file-list      50
  ido-use-filename-at-point nil
  ido-use-url-at-point nil
  ido-enable-flex-matching t
  ido-max-prospects 8
  ido-confirm-unique-completion t
  ido-create-new-buffer 'always
  ido-enable-tramp-completion t
  ;; do not ask for confirmation
  confirm-nonexistent-file-or-buffer nil)

;; Copied from CDK emacs config
(ido-mode t)
(ido-everywhere t)


;; Copied from Vedang's emacs config
(global-set-key (kbd "C-x M-f") 'ido-find-file-other-window)

;; This tab override shouldn't be necessary given ido's default
;; configuration, but minibuffer-complete otherwise dominates the
;; tab binding because of my custom tab-completion-everywhere
;; configuration. - from M-x All things emacs
(add-hook 'ido-setup-hook
          (lambda ()
            (define-key ido-completion-map [tab] 'ido-complete)))

;;; ido on steroids :D from EmacsWiki
(defadvice completing-read
  (around foo activate)
  (if (boundp 'ido-cur-list)
      ad-do-it
    (setq ad-return-value
          (ido-completing-read
           prompt
           (all-completions "" collection predicate)
           nil require-match initial-input hist def))))

(global-set-key
 "\M-x"
 (lambda ()
   (interactive)
   (call-interactively
    (intern
     (ido-completing-read
      "M-x "
      (all-completions "" obarray 'commandp))))))

(provide 'ido-config)
