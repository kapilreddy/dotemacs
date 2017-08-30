(add-to-list 'load-path "~/.emacs.d/el-get")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(el-get-dir "/Users/kapil/.emacs.d/el-get-packages"))

(require 'el-get)

(el-get-bundle seq :type git :url "https://github.com/NicolasPetton/seq.el.git")
(el-get-bundle cider :version "v0.15.0")
(el-get-bundle clj-refactor :version "2.3.1")
(el-get-bundle smooth-scroll)
(el-get-bundle exec-path-from-shell)
(el-get-bundle rainbow-delimiters)
(el-get-bundle paredit)
(el-get-bundle yasnippet)
(el-get-bundle magit)

(el-get-bundle color-theme-tangotango)


(provide 'el-get-config)
