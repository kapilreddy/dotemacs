;; el-get itself lives in the tracked submodule at <config>/el-get.
;; (`add-path' / `config-basedir' are defined in init.el before this loads.)
(add-path "el-get")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(el-get-dir "/Users/kapil/.emacs.d/el-get-packages"))

(require 'el-get)
;; el-get-bundle is a macro in its own file; in a raw git checkout the
;; autoload isn't generated, so require it explicitly.
(require 'el-get-bundle)

(el-get-bundle sesman :type :git :url "https://github.com/vspinu/sesman" :checkout "v0.3.3")

(el-get-bundle clojure-semantic :type git :url "https://github.com/kototama/clojure-semantic")
(el-get-bundle seq :type git :url "https://github.com/NicolasPetton/seq.el.git")
;; Updated 2026-06 to latest for Emacs 30 (old 5.9.0 / 2017 cider pins were
;; incompatible — failed eager macro-expansion). Modern CIDER keeps its source
;; in lisp/, which el-get's stock recipe forgets to add to the load-path.
(el-get-bundle clojure-mode :type git :url "https://github.com/clojure-emacs/clojure-mode/")
(el-get-bundle cider
  :type github :pkgname "clojure-emacs/cider"
  :load-path ("lisp")
  :depends (seq queue clojure-mode pkg-info spinner sesman parseedn parseclj))
;; clj-refactor depends on inflections, which has no built-in el-get recipe.
(el-get-bundle inflections :type git :url "https://github.com/eschulte/jump.el")
(el-get-bundle clj-refactor
  :git "https://github.com/clojure-emacs/clj-refactor.el")
(el-get-bundle clojure-snippets :git "https://github.com/mpenet/clojure-snippets")
(el-get-bundle exec-path-from-shell)
(el-get-bundle rainbow-delimiters)
(el-get-bundle paredit)
(el-get-bundle yasnippet)
(el-get-bundle magit)
;; espresso.el is dead upstream (404) and unused; JS now uses built-in
;; js-ts-mode. Bundle removed.
(el-get-bundle fountain-mode :type git :url "https://github.com/rnkn/fountain-mode")
(el-get-bundle yaml-mode)
(el-get-bundle highlight)
(el-get-bundle tide)

;; tangotango is now vendored as a self-contained deftheme in <config>/themes
;; and loaded via load-theme (see ui.el). The old color-theme-tangotango bundle
;; pulled in the deprecated `color-theme'/`cl' packages, so it's removed.

;; org-expiry: fetch just the single contrib file. org itself is built into
;; Emacs 30 (9.7), so we avoid cloning all of org-mode from the slow/flaky
;; git.savannah.gnu.org host (the old orgmode.org blob URL is also dead).
(el-get-bundle org-expiry
  :type http
  :url "https://raw.githubusercontent.com/emacsmirror/org-contrib/master/lisp/org-expiry.el")


(el-get-bundle cl-lib)
(el-get-bundle dash)
(el-get-bundle f)
(el-get-bundle helm)
(el-get-bundle s)

(el-get-bundle helm-org-rifle :type git :url "https://github.com/alphapapa/helm-org-rifle/")

(el-get-bundle ht)
;; org is built into Emacs 30 (9.7); satisfy the org-super-agenda dependency
;; with the builtin instead of cloning/building org from savannah.
(el-get-bundle org-mode :type builtin)
(el-get-bundle org-super-agenda :type git :url "https://github.com/alphapapa/org-super-agenda")

(el-get-bundle org-agenda-property :type git :url "https://github.com/Malabarba/org-agenda-property")

(el-get-bundle cljr-helm :type git :url "https://github.com/philjackson/cljr-helm")

(el-get-bundle ledger-mode :type git :url "https://github.com/ledger/ledger-mode/" :version "v3.1.1")

;; github-modern-theme repo is gone (404) and unused. Bundle removed.

(el-get-bundle helm-ag)
(el-get-bundle company-mode)

;; Markdown: pleasant reading + editing.
(el-get-bundle markdown-mode)
(el-get-bundle visual-fill-column
  :type git :url "https://codeberg.org/joostkremers/visual-fill-column.git")

;; Python (modern setup): async formatting via ruff + virtualenv switching.
;; eglot, flymake, tree-sitter and python-ts-mode are built into Emacs 30.
(el-get-bundle pyvenv)
(el-get-bundle apheleia
  :type git :url "https://github.com/radian-software/apheleia")

(provide 'el-get-config)
