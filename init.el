(defvar config-basedir (file-name-directory load-file-name))

(defun add-path (p)
  (add-to-list 'load-path (concat config-basedir p)))

(add-path "configurations")

(add-path "packages")

(require 'uniquify)

(require 'init-ui)
(require 'packages)
(require 'misc)
(require 'ui)
(require 'key-bindings)
(require 'ibuffer-config)
(require 'ido-config)
(require 'auto-complete)
(require 'clojure-config)
(require 'js-mode-config)
(require 'python-mode-config)
(require 'scss-mode-config)
