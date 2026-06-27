;;; ui.el --- Visual configuration -*- lexical-binding: t; -*-

;;; Chrome: no menu / tool / scroll bars.
(when (fboundp 'menu-bar-mode)   (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)   (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(setq inhibit-startup-screen t
      ring-bell-function 'ignore
      use-short-answers t)

;;; Theme: tangotango, vendored as a self-contained deftheme in <config>/themes
;;; and loaded natively. This deliberately avoids the old `color-theme' package
;;; (pulled in by the el-get color-theme-tangotango bundle), which requires the
;;; deprecated `cl' library and warns on startup.
(add-to-list 'custom-theme-load-path
             (expand-file-name "themes" config-basedir))
(load-theme 'tangotango t)

;;; Buffer-name disambiguation.
(setq uniquify-buffer-name-style 'post-forward)

;;; Scrolling: native pixel-precise scrolling (Emacs 29+) replaces the old
;;; smooth-scroll / smooth-scrolling packages.
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))
(setq scroll-conservatively 1000
      scroll-margin 3
      scroll-step 1
      mouse-wheel-scroll-amount '(1 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse t)

;;; Line length: a real fill-column rule replaces the old
;;; `highlight-lines-matching-regexp' hack. It follows each buffer's
;;; fill-column (72 by default, 88 in Python).
(set-default 'fill-column 72)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;;; Line + column numbers (numbers shown in the fringe for code buffers).
(line-number-mode 1)
(column-number-mode 1)
(setq display-line-numbers-width 3)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;;; Keybinding discoverability (built into Emacs 30).
(when (fboundp 'which-key-mode)
  (which-key-mode 1))

;;; Font: use the first installed match from a preference list so a missing
;;; font never leaves you on an ugly default (Menlo always ships on macOS).
(defun kr/set-first-available-font (size &rest families)
  "Set the default font to the first of FAMILIES that is installed, at SIZE."
  (when (display-graphic-p)
    (catch 'done
      (dolist (family families)
        (when (find-font (font-spec :name family))
          (let ((spec (format "%s-%d" family size)))
            (set-face-attribute 'default nil :font spec)
            (add-to-list 'default-frame-alist (cons 'font spec)))
          (throw 'done family))))))

(kr/set-first-available-font 13
                             "Input Mono Narrow" "JetBrains Mono"
                             "Fira Code" "Menlo")

;;; Compact mode-line indicators.
(require 'clean-mode-line)

(provide 'ui)
