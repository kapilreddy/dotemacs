
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(defvar config-basedir (file-name-directory load-file-name))

(defun add-path (p)
  (add-to-list 'load-path (concat config-basedir p)))

(add-path "configurations")


(setq *tempfiles-dir* (concat config-basedir "temp-files/")
      *sess-dir* (concat config-basedir "session-files/"))

(setq session-files-dir (concat config-basedir "session-files/"))

(server-start)
(setq mac-command-modifier 'meta)

(global-hi-lock-mode 1)

(require 'el-get-config)
(require 'epl)
(require 'pkg-info)
(require 'uniquify)
(require 'misc)
(require 'ui)
(require 'key-bindings)
(require 'ibuffer-config)
(require 'ido-config)
;; (require 'auto-complete)
(require 'clojure-config)
(require 'yas)
(require 'org-mode-config)
(require 'emacslisp-config)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
