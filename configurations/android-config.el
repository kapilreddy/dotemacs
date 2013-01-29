(add-path "packages/android-mode/")
(require 'android-mode)
(require 'android)

(setq android-mode-sdk-dir "~/src/android-sdk-macosx/")

(define-key espresso-mode-map "{" 'paredit-open-curly)
          (define-key espresso-mode-map "}" 'paredit-close-curly-and-newline)


(defun android-man (dir)
  "Look for AndroidManifest.xml file to find project dir of android application."
  (message dir)
  (locate-dominating-file dir "AndroidManifest.xml"))

(defmacro android-in-dir (dir body)
  "Execute BODY form with project dir directory as
dir directory can be found."
  `(let ((android-root (android-man ,dir)))
     (message "Running android in root dir %s" android-root)
     (when android-root
       (let ((default-directory android-root))
         ,body))))

(defun install-run-android ()
  (interactive)
  (android-ant-installd)
  (android-start-app))

(eval-after-load "android-mode"
 '(progn
    (define-key android-mode-map
      (kbd "C-c C-c v")
      'install-run-android)))

(defun java-setup ()
  (highlight-lines-matching-regexp ".\\{96\\}")
  (setq espresso-indent-level 2)
  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92)
        c-basic-offset 2
        indent-tabs-mode nil
        tab-width 2
        fill-column 95
        c-comment-start-regexp "\\(@\\|/\\(/\\|[*][*]?\\)\\)"))

(add-hook 'android-mode-hook 'java-setup)

(provide 'android-config)
