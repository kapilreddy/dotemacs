;; https://github.com/technomancy/emacs-starter-kit
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (mouse-wheel-mode t)
  (blink-cursor-mode -1))

(add-hook 'before-make-frame-hook 'turn-off-tool-bar)

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq inhibit-startup-message t)
;; make emacs use the clipboard
(setq x-select-enable-clipboard t)

(setq require-final-newline t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq-default indent-tabs-mode nil)

(desktop-save-mode 1)

;;; hooks
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'before-save-hook 'time-stamp)

;; Don't clutter up directories with files~
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat *tempfiles-dir* "backups"))))
      auto-save-list-file-prefix
      (concat *tempfiles-dir* "auto-save-list/.auto-saves-")
      auto-save-file-name-transforms
      `((".*" ,(concat *tempfiles-dir* "auto-save-list/") t)))


(add-path "packages/exec-path-from-shell")
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))


(provide 'misc)
