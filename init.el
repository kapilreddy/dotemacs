(defvar config-basedir (file-name-directory load-file-name))

(defun add-path (p)
  (add-to-list 'load-path (concat config-basedir p)))


(add-path "configurations")

(add-path "packages")

(add-path "elpa")

(setq *tempfiles-dir* (concat config-basedir "temp-files/")
      *sess-dir* (concat config-basedir "session-files/"))

(setq session-files-dir (concat config-basedir "session-files/"))

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
(require 'slime-config)
(require 'js-mode-config)
;; (require 'python-mode-config)
;; (require 'java-config)
(require 'scss-mode-config)
(require 'org-mode-config)
