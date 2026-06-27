;;; markdown-config.el --- Pleasant Markdown reading & editing -*- lexical-binding: t; -*-

(require 'markdown-mode)

;; --- Major mode -----------------------------------------------------------
;; Use GitHub-Flavored Markdown (tables, task lists, fenced code) for *all*
;; markdown files. markdown-mode's own autoloads register several patterns that
;; also match .md and can win the auto-mode race, so drop any markdown/gfm
;; entries first, then register a single gfm-mode entry that always wins.
(setq auto-mode-alist
      (seq-remove (lambda (e)
                    (and (consp e) (memq (cdr e) '(markdown-mode gfm-mode))))
                  auto-mode-alist))
(add-to-list 'auto-mode-alist
             '("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\|mdx\\)\\'"
               . gfm-mode))

;; --- Editor behaviour -----------------------------------------------------
(setq markdown-command
      (cond ((executable-find "pandoc")        "pandoc")
            ((executable-find "multimarkdown") "multimarkdown")
            (t "markdown")))

(setq markdown-fontify-code-blocks-natively t   ; syntax-highlight fenced code
      markdown-header-scaling t                  ; larger, hierarchical headings
      markdown-header-scaling-values '(1.6 1.4 1.25 1.15 1.05 1.0)
      markdown-enable-math t                     ; LaTeX fragments
      markdown-hide-urls t                       ; show link text, hide long URLs
      markdown-asymmetric-header t
      markdown-list-indent-width 2
      markdown-gfm-uppercase-checkbox t
      markdown-fontify-whole-heading-line t)

(defun kr/markdown-reading-setup ()
  "Reading-friendly defaults for Markdown buffers."
  (visual-line-mode 1)                  ; soft word-wrap at the window edge
  (setq-local line-spacing 0.15)        ; a little breathing room between lines
  (when (fboundp 'visual-fill-column-mode)
    (setq-local visual-fill-column-width 100
                visual-fill-column-center-text t)
    (visual-fill-column-mode 1))
  (markdown-toggle-markup-hiding 1))    ; clean prose; markup shown around point

(add-hook 'markdown-mode-hook #'kr/markdown-reading-setup)

;; --- Tables: clean in-buffer alignment ------------------------------------
;; `C-c |' aligns the table at point into neat monospace columns.
(with-eval-after-load 'markdown-mode
  (define-key markdown-mode-map (kbd "C-c |") #'markdown-table-align))

;; --- Tables/everything: true HTML rendering inside Emacs (xwidget) ---------
;; `C-c C-c w' renders the buffer to styled HTML and shows it in an Emacs
;; WebKit window, where tables become real bordered tables.
(defvar kr/markdown-preview-css "
body{font-family:-apple-system,'Segoe UI',Helvetica,Arial,sans-serif;
     max-width:860px;margin:40px auto;padding:0 24px;line-height:1.6;
     color:#1f2328;-webkit-font-smoothing:antialiased;}
h1,h2{border-bottom:1px solid #d0d7de;padding-bottom:.3em;}
a{color:#0969da;}
code{background:#afb8c133;padding:.2em .4em;border-radius:6px;font-size:85%;
     font-family:'Input Mono Narrow',ui-monospace,Menlo,monospace;}
pre{background:#f6f8fa;padding:16px;border-radius:6px;overflow:auto;}
pre code{background:none;padding:0;font-size:100%;}
table{border-collapse:collapse;margin:1em 0;}
th,td{border:1px solid #d0d7de;padding:6px 13px;}
th{background:#f6f8fa;font-weight:600;}
tr:nth-child(2n){background:#f6f8fa;}
blockquote{color:#59636e;border-left:.25em solid #d0d7de;padding:0 1em;margin:0;}
img{max-width:100%;}"
  "CSS used by `kr/markdown-preview-xwidget' (GitHub-like, real table borders).")

(defun kr/markdown-preview-xwidget ()
  "Render the current Markdown buffer to styled HTML in an xwidget WebKit window.
Tables, headings and code blocks render as real HTML (offline, via pandoc)."
  (interactive)
  (unless (fboundp 'xwidget-webkit-browse-url)
    (user-error "This Emacs was built without xwidget support"))
  (unless (executable-find "pandoc")
    (user-error "pandoc is not installed (brew install pandoc)"))
  (let* ((title (if buffer-file-name
                    (file-name-nondirectory buffer-file-name) "preview"))
         (header (make-temp-file "md-css-" nil ".html"
                                 (format "<style>%s</style>" kr/markdown-preview-css)))
         (html (make-temp-file "md-preview-" nil ".html"))
         (input (make-temp-file "md-src-" nil ".md" (buffer-string))))
    (if (zerop (call-process "pandoc" nil nil nil
                             input "-f" "gfm" "-t" "html5" "--standalone"
                             "--metadata" (concat "title=" title)
                             "-H" header "-o" html))
        (xwidget-webkit-browse-url (concat "file://" html))
      (user-error "pandoc failed to render the buffer"))))

(with-eval-after-load 'markdown-mode
  (define-key markdown-mode-map (kbd "C-c C-c w") #'kr/markdown-preview-xwidget))

(provide 'markdown-config)
;;; markdown-config.el ends here
