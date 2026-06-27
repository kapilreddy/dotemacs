;;; python-mode-config.el --- Modern Python development -*- lexical-binding: t; -*-

;; Replaces the old pymacs/ropemacs/pyflakes setup (abandoned upstream).
;;
;; Stack (Emacs 30, mostly built-in):
;;   - python-ts-mode  : tree-sitter syntax/indent              (built-in)
;;   - eglot           : LSP client, basedpyright server        (built-in)
;;   - flymake         : diagnostics, fed by eglot              (built-in)
;;   - company         : in-buffer completion via capf          (already global)
;;   - ruff (apheleia) : format + import-sort + autofix on save (external)
;;   - pyvenv          : virtualenv switching                   (external)
;;
;; External binaries (installed via `uv tool install`):
;;   ruff, basedpyright-langserver

(require 'python)

;;; ------------------------------------------------------------------ ;;;
;;; Tree-sitter: prefer python-ts-mode when the grammar is available.
;;; ------------------------------------------------------------------ ;;;
(add-to-list 'treesit-language-source-alist
             '(python "https://github.com/tree-sitter/tree-sitter-python"))

(when (and (fboundp 'treesit-available-p) (treesit-available-p))
  (unless (treesit-language-available-p 'python)
    ;; Needs a C compiler (Xcode CLT). Silently skip if it fails so we
    ;; fall back to the classic python-mode.
    (ignore-errors (treesit-install-language-grammar 'python)))
  (when (treesit-language-available-p 'python)
    (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))))

;;; ------------------------------------------------------------------ ;;;
;;; Indentation
;;; ------------------------------------------------------------------ ;;;
(setq python-indent-offset 4
      python-indent-guess-indent-offset nil)

;;; ------------------------------------------------------------------ ;;;
;;; Eglot + basedpyright
;;; ------------------------------------------------------------------ ;;;
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode)
                 . ("basedpyright-langserver" "--stdio"))))

;; basedpyright workspace settings: "basic" type checking is a sane default
;; (use "standard"/"strict" per-project via .dir-locals.el if you want more).
(setq-default eglot-workspace-configuration
              '(:basedpyright
                (:analysis (:typeCheckingMode "basic"
                            :useLibraryCodeForTypes t
                            :autoImportCompletions t))))

;; Start the language server automatically.
(dolist (hook '(python-mode-hook python-ts-mode-hook))
  (add-hook hook #'eglot-ensure))

;;; ------------------------------------------------------------------ ;;;
;;; Ruff: format + import sort + autofix on save (via apheleia, async)
;;; Replaces black + isort + flake8 + pyflakes in one tool.
;;; ------------------------------------------------------------------ ;;;
(when (require 'apheleia nil t)
  (with-eval-after-load 'apheleia
    ;; Define the formatters defensively (apheleia ships these in recent
    ;; versions, but this keeps us working on older copies too).
    (setf (alist-get 'ruff apheleia-formatters)
          '("ruff" "format" "--stdin-filename" filepath "-"))
    (setf (alist-get 'ruff-isort apheleia-formatters)
          '("ruff" "check" "-n" "--select" "I" "--fix" "--stdin-filename" filepath "-"))
    ;; isort first, then format.
    (setf (alist-get 'python-mode apheleia-mode-alist) '(ruff-isort ruff))
    (setf (alist-get 'python-ts-mode apheleia-mode-alist) '(ruff-isort ruff)))
  (apheleia-global-mode +1))

;;; ------------------------------------------------------------------ ;;;
;;; Virtualenv switching (basedpyright also auto-detects ./.venv)
;;; ------------------------------------------------------------------ ;;;
(when (require 'pyvenv nil t)
  (pyvenv-mode 1))

;;; ------------------------------------------------------------------ ;;;
;;; Per-buffer setup
;;; ------------------------------------------------------------------ ;;;
(defun kr/python-setup ()
  "Buffer-local tweaks for Python."
  (setq-local fill-column 88)            ; ruff/black default line length
  (when (fboundp 'company-mode) (company-mode 1)))

(dolist (hook '(python-mode-hook python-ts-mode-hook))
  (add-hook hook #'kr/python-setup))

;; Diagnostics navigation (eglot routes everything through flymake).
(with-eval-after-load 'python
  (define-key python-mode-map (kbd "<f2>") #'flymake-goto-next-error)
  (define-key python-mode-map (kbd "<f3>") #'flymake-goto-prev-error))
(with-eval-after-load 'python
  (when (boundp 'python-ts-mode-map)
    (define-key python-ts-mode-map (kbd "<f2>") #'flymake-goto-next-error)
    (define-key python-ts-mode-map (kbd "<f3>") #'flymake-goto-prev-error)))

(provide 'python-mode-config)
;;; python-mode-config.el ends here
