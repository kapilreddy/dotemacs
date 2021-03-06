(add-to-list 'load-path "~/.emacs.d/el-get")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(el-get-dir "/Users/kapil/.emacs.d/el-get-packages"))

(require 'el-get)

(el-get-bundle sesman :type :git :url "https://github.com/vspinu/sesman" :checkout "v0.3.3")

(el-get-bundle clojure-semantic :type git :url "https://github.com/kototama/clojure-semantic")
(el-get-bundle seq :type git :url "https://github.com/NicolasPetton/seq.el.git")
(el-get-bundle clojure-mode :type git :url "https://github.com/clojure-emacs/clojure-mode/" :checkout "5.9.0")
(el-get-bundle cider :git "https://github.com/clojure-emacs/cider/" :checkout "23de90cf771a236b424eb3fa8a4403041bed2e40")
(el-get-bundle clj-refactor
  :git "https://github.com/clojure-emacs/clj-refactor.el")
(el-get-bundle clojure-snippets :git "https://github.com/mpenet/clojure-snippets")
(el-get-bundle smooth-scroll)
(el-get-bundle exec-path-from-shell)
(el-get-bundle rainbow-delimiters)
(el-get-bundle paredit)
(el-get-bundle yasnippet)
(el-get-bundle magit)
(el-get-bundle espresso :url "https://raw.githubusercontent.com/Unitech/.emacs.d/master/espresso.el")
(el-get-bundle fountain-mode :type git :url "https://github.com/rnkn/fountain-mode")
(el-get-bundle yaml-mode)
(el-get-bundle highlight)
(el-get-bundle tide)

(el-get-bundle color-theme-tangotango)

(el-get-bundle org-expiry :url "http://orgmode.org/w/?p=org-mode.git;a=blob_plain;f=contrib/lisp/org-expiry.el")


(el-get-bundle cl-lib)
(el-get-bundle dash)
(el-get-bundle f)
(el-get-bundle helm)
(el-get-bundle s)

(el-get-bundle helm-org-rifle :type git :url "https://github.com/alphapapa/helm-org-rifle/")

(el-get-bundle ht)
(el-get-bundle org-super-agenda :type git :url "https://github.com/alphapapa/org-super-agenda")

(el-get-bundle org-agenda-property :type git :url "https://github.com/Malabarba/org-agenda-property")

(el-get-bundle cljr-helm :type git :url "https://github.com/philjackson/cljr-helm")

(el-get-bundle ledger-mode :type git :url "https://github.com/ledger/ledger-mode/" :version "v3.1.1")

(el-get-bundle github-modern-theme :type git :url "https://github.com/philiparvidsson/GitHub-Modern-Theme-for-Emacs")
(el-get-bundle smooth-scrolling-mode :type git :url "https://github.com/aspiers/smooth-scrolling")

(el-get-bundle helm-ag)
(el-get-bundle company-mode)

(provide 'el-get-config)
