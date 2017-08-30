
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(defvar config-basedir (file-name-directory load-file-name))

(defun add-path (p)
  (add-to-list 'load-path (concat config-basedir p)))

(add-path "configurations")

(add-path "packages")

;; (add-path "packages/org-mode/lisp")


(setq *tempfiles-dir* (concat config-basedir "temp-files/")
      *sess-dir* (concat config-basedir "session-files/"))

(setq session-files-dir (concat config-basedir "session-files/"))

(server-start)
(setq mac-command-modifier 'meta)

(add-path "packages/epl/")
(add-path "packages/pkg-info/")

(require 'packages)
(require 'epl)
(require 'pkg-info)
(require 'uniquify)
(require 'init-ui)
(require 'misc)
(require 'ui)
(require 'key-bindings)
(require 'ibuffer-config)
(require 'ido-config)
(require 'auto-complete)
(require 'clojure-config)
(require 'js-mode-config)
(require 'yas)
;; (require 'python-mode-config)
;; (require 'java-config)
(require 'scss-mode-config)
(require 'org-mode-config)
(require 'android-config)
(require 'golang-config)
(require 'emacslisp-config)
(require 'cljs-config)
(require 'clean-mode-line)
