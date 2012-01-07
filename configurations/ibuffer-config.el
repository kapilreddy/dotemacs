;;; Settings for ibuffer

(autoload 'ibuffer "ibuffer" "List buffers." t)

;; Switch to specified buffer groups
(add-hook 'ibuffer-mode-hook
              (lambda ()
                (ibuffer-switch-to-saved-filter-groups "default")))

(global-set-key (kbd "C-z") 'ibuffer-do-occur)

;; Hide empty buffer groups
(setq ibuffer-show-empty-filter-groups nil)

(setq ibuffer-default-sorting-mode 'major-mode
      ibuffer-always-show-last-buffer t)

(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("Zulu"
                (filename . "zulu"))
               ("Noein"
                (filename . "cobrowser"))
               ("Programming"
                (or
                 (mode . c-mode)
                 (mode . c++-mode)
                 (mode . erlang-mode)
                 (mode . perl-mode)
                 (mode . python-mode)
                 (mode . emacs-lisp-mode)
                 (mode . clojure-mode)
                 (mode . makefile-gmake-mode)))
               ("Org"
                (or
                 (mode . org-mode)
                 (mode . markdown-mode)))
               ("Magit"
                (mode . magit-mode))
               ("Documents"
                (or
                 (mode . LaTeX-mode)
                 (mode . fundamental-mode)))))))

(provide 'ibuffer-config)
