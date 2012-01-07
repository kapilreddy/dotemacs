;; Configuring Python, pymacs, ropemacs
(add-path "packages/python/")
(require 'pymacs)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(pymacs-load "ropemacs" "rope-")

(setq ropemacs-enable-autoimport t)
(require 'flymake)
(provide 'python-mode-config)
