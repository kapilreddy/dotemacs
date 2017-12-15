(add-path "packages/color-theme-6.6.0")
(add-path "packages/color-theme-tangotango-0.0.2")


(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode 0))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(highlight-lines-matching-regexp ".\{72\}")

(require 'color-theme-tangotango)
(color-theme-tangotango)

(setq uniquify-buffer-name-style 'post-forward)

(require 'smooth-scroll)
;; scroll one line at a time (less "jumpy" than defaults)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling

(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

(setq scroll-step 1) ;; keyboard scroll one line at a time

(set-default 'fill-column 72)
(setq auto-fill-mode 1)

;; Show line-number in the mode line
(line-number-mode 1)

;; Show column-number in the mode line
(column-number-mode 1)


(set-face-attribute 'default t :font "Input Mono Narrow")
(set-face-attribute 'default nil :font "Input Mono Narrow")
(set-frame-font "Input Mono Narrow" nil t)
(provide 'ui)
