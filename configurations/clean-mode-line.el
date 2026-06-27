;;; clean-mode-line.el --- Compact mode-line indicators -*- lexical-binding: t; -*-

(require 'cl-lib)

(defvar mode-line-cleaner-alist
  '(;; Minor modes
    (yas-minor-mode      . " γ")
    (paredit-mode        . " Φ")
    (eldoc-mode          . "")
    (abbrev-mode         . "")
    (company-mode        . " ©")
    (helm-mode           . "")
    (which-key-mode      . "")
    (flymake-mode        . " ✓")
    (apheleia-mode       . " ⚒")
    (eglot--managed-mode . " eglot")
    ;; Major modes
    (clojure-mode        . "λ")
    (clojurescript-mode  . "λs")
    (python-mode         . "Py")
    (python-ts-mode      . "Py")
    (emacs-lisp-mode     . "EL")
    (markdown-mode       . "md"))
  "Alist mapping modes to compact mode-line strings for `clean-mode-line'.

Add a (mode . string) pair to shorten how MODE is shown in the
mode line *in lieu of* its default name.")

(defun clean-mode-line ()
  "Replace verbose mode names with compact ones from `mode-line-cleaner-alist'."
  (interactive)
  (cl-loop for (mode . mode-str) in mode-line-cleaner-alist
           do (let ((old (cdr (assq mode minor-mode-alist))))
                (when old (setcar old mode-str))
                (when (eq mode major-mode)
                  (setq mode-name mode-str)))))

(add-hook 'after-change-major-mode-hook #'clean-mode-line)

;;; Greek letters - C-u C-\ greek ;; C-\ to revert to default
;;; ς ε ρ τ υ θ ι ο π α σ δ φ γ η ξ κ λ ζ χ ψ ω β ν μ
(provide 'clean-mode-line)
;;; clean-mode-line.el ends here
