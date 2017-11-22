;; The config is created by reading this awesome tutorial
;; http://doc.norang.ca/org-mode.html#CustomAgendaViewSetup


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Directory config
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-directory "~/Google Drive/org-files/")
(setq org-base-directory "~/Google Drive/org-files/")
(setq org-work-directory "~/Google Drive/org-files/work/")
(setq org-personal-directory "~/Google Drive/org-files/personal/")
(setq org-agenda-files (list (concat org-base-directory "work")
                             (concat org-base-directory "personal")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Global Keybindings
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Disable C-c [ and C-c ] and C-c ; in org-mode
(add-hook 'org-mode-hook
          '(lambda ()
             ;; Undefine C-c [ and C-c ] since this breaks my
             ;; org-agenda files when directories are include It
             ;; expands the files in the directories individually
             (org-defkey org-mode-map "\C-c["    'undefined)
             (org-defkey org-mode-map "\C-c]"    'undefined)
             (org-defkey org-mode-map "\C-c;"    'undefined))
          'append)


(global-set-key "\C-ca" 'org-agenda)

;; Switch to org specific buffers
(global-set-key "\C-cb" 'org-iswitchb)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; TODO related changes
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Separate drawers for clocking and logbook
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "PROJECT(p)" "|" "DONE(d!/!)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "|" "FOLLOWUP(f@/!)"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("FOLLOWUP" :foreground "green" :weight bold)
              ("PROJECT" :foreground "green" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold))))

(setq org-use-fast-todo-selection t)

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("FOLLOWUP" ("FOLLOWUP" . t))
              ("PROJECT" ("project" . t))
              ("HOLD" ("WAITING" . t) ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

;; Remove empty LOGBOOK drawers on clock out
(defun bh/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "LOGBOOK" (point))))

(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Capture related changes
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file 'capture-file-path)
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("m" "Meeting" entry (file+headline (concat org-work-directory "meetings.org") "Meetings")
               "* %? %U\n" :clock-in t :clock-resume t)
              ("n" "note" entry (file 'capture-file-path)
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree (concat org-base-directory "diary.org"))
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file 'capture-file-path)
               "* NEXT %?\n%U\n%a\nSCHEDULED: %t .+1d/3d\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

(setq capture-file-path (concat org-base-directory "capture.org"))

(setq org-default-notes-file capture-file-path)

(setq meetings-file-path (concat org-work-directory "meetings.org"))


;; Refile configuration.
; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; IDO related config
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Agenda config
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Dim blocked tasks
(setq org-agenda-dim-blocked-tasks t)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

(setq org-agenda-sorting-strategy
      (quote ((agenda time-up effort-up category-keep))))


(setq org-agenda-skip-scheduled-if-deadline-is-shown t)

;; Custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("a" "Work Agenda"
               ((todo "FOLLOWUP"
                      ((org-agenda-files (list org-work-directory))
                       (org-agenda-overriding-header
                        "Followups")
                       (org-agenda-overriding-columns-format "%20ITEM %DEADLINE")

                       (org-agenda-sorting-strategy '(deadline-up priority-down))))
                (tags-todo "review"
                           ((org-agenda-files (list org-work-directory))
                            (org-agenda-overriding-header
                             "Review Tasks")
                            (org-agenda-sorting-strategy '(deadline-up priority-down))
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("TODO")))))
                (tags-todo "WAITING"
                           ((org-agenda-files (list org-work-directory))
                            (org-agenda-overriding-header
                             "Waiting Tasks")
                            (org-agenda-sorting-strategy '(deadline-up priority-down))
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("HOLD" "PROJECT" "NEXT")))))
                (agenda "" ((org-agenda-files (list org-work-directory))
                            (org-agenda-ndays 7)
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("TODO")
                                                                                 'regexp '(":review:")))
                            (org-agenda-sorting-strategy '(deadline-up priority-down))))
                (tags-todo "project"
                           ((org-agenda-files (list org-work-directory))
                            (org-agenda-overriding-header
                             "Projects")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("PROJECT" "HOLD")))))
                (todo "REVIEW"
                      ((org-agenda-files (list org-work-directory))
                       (org-agenda-overriding-header
                        "Review Tasks")
                       (org-agenda-sorting-strategy '(deadline-up))))

                (todo "NEXT"
                      ((org-agenda-files (list org-work-directory))
                       (org-agenda-overriding-header
                        "Next Tasks")
                       (org-agenda-sorting-strategy '(deadline-up))))

                (tags "REFILE"
                      ((org-agenda-overriding-header
                        "Notes and Tasks to Refile")))
                nil))
              ("p" "Personal Agenda"
               ((todo "FOLLOWUP"
                      ((org-agenda-files (list org-personal-directory))
                       (org-agenda-overriding-header
                        "Followups")
                       (org-agenda-sorting-strategy '(deadline-up))))
                (tags-todo "review"
                           ((org-agenda-files (list org-personal-directory))
                            (org-agenda-overriding-header
                             "Review Tasks")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("TODO")))))
                (tags-todo "WAITING"
                           ((org-agenda-files (list org-personal-directory))
                            (org-agenda-overriding-header
                             "Waiting Tasks")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("HOLD" "PROJECT" "NEXT")))))
                (agenda "" ((org-agenda-files (list org-personal-directory))
                            (org-agenda-ndays 7)
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("TODO" "PROJECT")
                                                                                 'regexp '(":review:")))
                            (org-agenda-sorting-strategy '(deadline-up))))
                (tags-todo "project"
                           ((org-agenda-files (list org-personal-directory))
                            (org-agenda-overriding-header
                             "Projects")
                            (org-agenda-entry-types '(:deadline))
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("PROJECT" "HOLD")))))
                (todo "REVIEW"
                      ((org-agenda-files (list org-personal-directory))
                       (org-agenda-overriding-header
                        "Review Tasks")
                       (org-agenda-sorting-strategy '(deadline-up))))

                (todo "NEXT"
                      ((org-agenda-files (list org-personal-directory))
                       (org-agenda-overriding-header
                        "Next Tasks")
                       (org-agenda-sorting-strategy '(deadline-up))))

                (tags "REFILE"
                      ((org-agenda-overriding-header
                        "Notes and Tasks to Refile")))
                nil))
              ("l" "Work done so far..."
               ((agenda "" ((org-agenda-span 'week)
                            (org-agenda-start-on-weekday 0)
                            (org-agenda-start-with-log-mode t)
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("DONE"))))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Custom agenda sorting function
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-agenda-cmp-user-defined 'bh/agenda-sort)

(defun bh/agenda-sort (a b)
  "Sorting strategy for agenda items.
Late deadlines first, then scheduled, then non-late deadlines"
  (let (result num-a num-b)
    (cond
     ; time specific items are already sorted first by org-agenda-sorting-strategy

     ; non-deadline and non-scheduled items next
     ((bh/agenda-sort-test 'bh/is-not-scheduled-or-deadline a b))

     ; deadlines for today next
     ((bh/agenda-sort-test 'bh/is-due-deadline a b))

     ; late deadlines next
     ((bh/agenda-sort-test-num 'bh/is-late-deadline '< a b))

     ; scheduled items for today next
     ((bh/agenda-sort-test 'bh/is-scheduled-today a b))

     ; late scheduled items next
     ((bh/agenda-sort-test-num 'bh/is-scheduled-late '> a b))

     ; pending deadlines last
     ((bh/agenda-sort-test-num 'bh/is-pending-deadline '< a b))

     ; finally default to unsorted
     (t (setq result nil)))
    result))

(defmacro bh/agenda-sort-test-num (fn compfn a b)
  `(cond
    ((apply ,fn (list ,a))
     (setq num-a (string-to-number (match-string 1 ,a)))
     (if (apply ,fn (list ,b))
         (progn
           (setq num-b (string-to-number (match-string 1 ,b)))
           (setq result (if (apply ,compfn (list num-a num-b))
                            -1
                          1)))
       (setq result -1)))
    ((apply ,fn (list ,b))
     (setq result 1))
    (t nil)))

(defun bh/is-not-scheduled-or-deadline (date-str)
  (and (not (bh/is-deadline date-str))
       (not (bh/is-scheduled date-str))))

(defun bh/is-due-deadline (date-str)
  (string-match "Deadline:" date-str))

(defun bh/is-late-deadline (date-str)
  (string-match "In *\\(-.*\\)d\.:" date-str))

(defun bh/is-pending-deadline (date-str)
  (string-match "In \\([^-]*\\)d\.:" date-str))

(defun bh/is-deadline (date-str)
  (or (bh/is-due-deadline date-str)
      (bh/is-late-deadline date-str)
      (bh/is-pending-deadline date-str)))

(defun bh/is-scheduled (date-str)
  (or (bh/is-scheduled-today date-str)
      (bh/is-scheduled-late date-str)))

(defun bh/is-scheduled-today (date-str)
  (string-match "Scheduled:" date-str))

(defun bh/is-scheduled-late (date-str)
  (string-match "Sched\.\\(.*\\)x:" date-str))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Tag config
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
                            ("@errand" . ?e)
                            ("@office" . ?o)
                            ("@home" . ?H)
                            (:endgroup)
                            ("review" . ?R)
                            ("release" . ?r)
                            ("future" . ?f)
                            ("PHONE" . ?p)
                            ("WAITING" . ?w)
                            ("HOLD" . ?h)
                            ("PERSONAL" . ?P)
                            ("WORK" . ?W)
                            ("CANCELLED" . ?c))))

; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

; For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Effort related config
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                    ("STYLE_ALL" . "habit"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Better naviation using narrow and widen
;; http://doc.norang.ca/org-mode.html#NarrowToSubtree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable speedy commands. Active only on stars at org headings
(setq org-use-speed-commands t)

(global-set-key (kbd "C-c C-g n") 'bh/org-todo)

(defun bh/org-todo (arg)
  (interactive "p")
  (if (equal arg 4)
      (save-restriction
        (bh/narrow-to-org-subtree)
        (org-show-todo-tree nil))
    (bh/narrow-to-org-subtree)
    (org-show-todo-tree nil)))

(global-set-key (kbd "C-c C-g w") 'bh/widen)

(defun bh/widen ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
        (org-agenda-remove-restriction-lock)
        (when org-agenda-sticky
          (org-agenda-redo)))
    (widen)))

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "W" (lambda () (interactive) (setq bh/hide-scheduled-and-waiting-next-tasks t) (bh/widen))))
          'append)



(defun bh/narrow-up-one-org-level ()
  (widen)
  (save-excursion
    (outline-up-heading 1 'invisible-ok)
    (bh/narrow-to-org-subtree)))

(defun bh/get-pom-from-agenda-restriction-or-point ()
  (or (and (marker-position org-agenda-restrict-begin) org-agenda-restrict-begin)
      (org-get-at-bol 'org-hd-marker)
      (and (equal major-mode 'org-mode) (point))
      org-clock-marker))

(defun bh/narrow-up-one-level ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
        (org-with-point-at (bh/get-pom-from-agenda-restriction-or-point)
          (bh/narrow-up-one-org-level))
        (org-agenda-redo))
    (bh/narrow-up-one-org-level)))

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "U" 'bh/narrow-up-one-level))
          'append)

(defun bh/narrow-to-org-project ()
  (widen)
  (save-excursion
    (bh/find-project-task)
    (bh/narrow-to-org-subtree)))

(defun bh/narrow-to-project ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
        (org-with-point-at (bh/get-pom-from-agenda-restriction-or-point)
          (bh/narrow-to-org-project)
          (save-excursion
            (bh/find-project-task)
            (org-agenda-set-restriction-lock)))
        (org-agenda-redo)
        (beginning-of-buffer))
    (bh/narrow-to-org-project)
    (save-restriction
      (org-agenda-set-restriction-lock))))

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "P" 'bh/narrow-to-project))
          'append)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; If all subtasks are done mark parent task as done
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
;; Parent task cannot be switched to done unless all subtasks are done
(setq org-enforce-todo-dependencies t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(provide 'org-mode-config)
