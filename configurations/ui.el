(add-path "packages/color-theme-6.6.0")
(add-path "packages/color-theme-tangotango-0.0.2")

(require 'color-theme-tangotango)
(color-theme-tangotango)

(setq uniquify-buffer-name-style 'post-forward)

(require 'smooth-scroll)
;; scroll one line at a time (less "jumpy" than defaults)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling

(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

(setq scroll-step 1) ;; keyboard scroll one line at a time


(provide 'ui)
