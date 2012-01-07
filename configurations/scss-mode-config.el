(require 'derived)

(defconst scss-font-lock-keywords
  ;; Variables
  '(("\$[^\s:;]+" . font-lock-constant-face)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

;;;###autoload
(define-derived-mode scss-mode css-mode "Scss"
  "Major mode for editing Scss files, http://sass-lang.com/"
  (font-lock-add-keywords nil scss-font-lock-keywords))

(provide 'scss-mode-config)
