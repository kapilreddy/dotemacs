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

(setq org-agenda-capture-targets (list (concat org-base-directory "work/rt.org")
                                       (concat org-base-directory "personal/projects.org")
                                       (concat org-base-directory "personal/learn.org")
                                       (concat org-base-directory "personal/payal.org")))

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
(global-set-key (kbd "C-M-r") 'org-capture)
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
      (quote ((sequence "TODO(t)" "NEXT(n)" "PROJECT(p)" "DELEGATED(D@/!)"  "FOLLOWUP(f@/!)" "WAITING(w@/!)" "HOLD(h@/!)" "|" "DONE(d!/!)" "CANCELLED(c@/!)"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("DELEGATED" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("FOLLOWUP" :foreground "green" :weight bold)
              ("PROJECT" :foreground "green" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold))))

(setq org-use-fast-todo-selection t)

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("FOLLOWUP" ("FOLLOWUP" . t))
              ("DELEGATED" ("DELEGATED" . t))
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

;; Add a logline when something is done
(setq org-log-done (quote time))

;; Add a logline when things change in timeline
(setq org-log-reschedule (quote time))
(setq org-log-redeadline (quote time))


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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Refile config
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Refile configuration.
; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-capture-targets :maxlevel . 5))))


; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))
; Use the current window when visiting files and buffers with ido
(setq ido-default-file-method 'selected-window)
(setq ido-default-buffer-method 'selected-window)
; Use the current window for indirect buffer display
(setq org-indirect-buffer-display 'current-window)

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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

(setq org-columns-default-format "%PRIORITY %80ITEM(Task) %DEADLINE  %10CLOCKSUM {:} %10Effort(Effort) %30CREATED(CREATED) 100%TAGS")

(setq org-agenda-overriding-columns-format nil)

;; Custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("a" "Work Agenda"
               agenda
               (progn (setq org-super-agenda-mode t)
                      (setq org-agenda-log-mode t)
                      (setq org-agenda-clockreport-mode t))

               ((org-agenda-files (list org-work-directory))
                (org-agenda-ndays 1)
                (org-agenda-sorting-strategy '(deadline-up priority-down))
                (org-super-agenda-groups '((:name "Worked on today"
                                                  :log t)
                                           (:name "Oncall"
                                                  :tag "oncall")
                                           (:name "Followup"
                                                  :and (:todo ("TODO" "WAITING")
                                                              :tag ("FOLLOWUP")))
                                           (:name "Delegated"
                                                  :todo ("DELEGATED"))
                                           (:name "Review"
                                                  :and (:todo ("TODO" "WAITING")
                                                              :tag ("review")))
                                           (:name "Waiting TODOs"
                                                  :and (:todo "WAITING"
                                                              :not (:tag ("oncall"
                                                                          "review"))))
                                           (:name "TODO"
                                                  :log t
                                                  :todo ("TODO"))
                                           (:name "Projects"
                                                  :todo ("PROJECT"))
                                           (:name "Done today"
                                                  :todo ("DONE"))
                                           (:name "On hold"
                                                  :todo ("HOLD"))
                                           (:name "Next items"
                                                  :todo ("NEXT"))))))

              ("r" "Week work Agenda"
               ((agenda ""
                        ((org-agenda-files (list org-work-directory))
                         (org-agenda-ndays 7)
                         (org-agenda-sorting-strategy '(deadline-up priority-down))
                         (org-super-agenda-groups '())))))


              ("b" "Work Agenda"
               ((tags-todo "+oncall"
                           ((org-agenda-overriding-header "Oncall!!!")
                            (org-agenda-files (list org-work-directory))
                            (org-agenda-sorting-strategy '(deadline-up priority-down))
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("TODO" "WAITING")))))
                (todo "FOLLOWUP"
                      ((org-agenda-files (list org-work-directory))
                       (org-deadline-warning-days 0)

                       (org-agenda-overriding-header "Followups")
                       (org-agenda-sorting-strategy '(deadline-up priority-down))))
                (tags-todo "review"
                           ((org-agenda-files (list org-work-directory))
                            (org-agenda-overriding-header "Review Tasks")
                            (org-agenda-sorting-strategy '(deadline-up priority-down))

                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("TODO")))))
                (agenda ""
                        ((org-agenda-files (list org-work-directory))
                         (org-agenda-ndays 1)
                         (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("WAITING")
                                                                              'regexp '(":oncall:")))
                         (org-agenda-sorting-strategy '(deadline-up priority-down))))
                (todo "DELEGATED"
                      ((org-agenda-files (list org-work-directory))
                       (org-agenda-overriding-header "Delegated Tasks")
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
                            (org-agenda-sorting-strategy '(deadline-up))
                            (org-agenda-show-all-dates nil)
                            (org-agenda-overriding-columns-format "%20ITEM %DEADLINE")
                            (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("PROJECT" "HOLD" "NEXT")))))
                (todo "REVIEW"
                      ((org-agenda-files (list org-work-directory))
                       (org-agenda-overriding-header
                        "Review Tasks")
                       (org-agenda-sorting-strategy '(deadline-up))))

                (todo "NEXT"
                      ((org-agenda-files (list org-work-directory))
                       (org-agenda-overriding-header
                        "Next Tasks")
                       (org-agenda-sorting-strategy '(priority-down))))

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Keeping track of when the todo was added
;; https://stackoverflow.com/questions/12262220/add-created-date-property-to-todos-in-org-mode
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; Allow automatically handing of created/expired meta data.
;;
(require 'org-expiry)
;; Configure it a bit to my liking
(setq
  org-expiry-created-property-name "CREATED" ; Name of property when an item is created
  org-expiry-inactive-timestamps   t         ; Don't have everything in the agenda view
)

(defun mrb/insert-created-timestamp()
  "Insert a CREATED property using org-expiry.el for TODO entries"
  (org-expiry-insert-created)
  (org-back-to-heading)
  (org-end-of-line)
  (insert " ")
)

;; Whenever a TODO entry is created, I want a timestamp
;; Advice org-insert-todo-heading to insert a created timestamp using org-expiry
(defadvice org-insert-todo-heading (after mrb/created-timestamp-advice activate)
  "Insert a CREATED property using org-expiry.el for TODO entries"
  (mrb/insert-created-timestamp)
)
;; Make it active
(ad-activate 'org-insert-todo-heading)

(require 'org-capture)

(defadvice org-capture (after mrb/created-timestamp-advice activate)
  "Insert a CREATED property using org-expiry.el for TODO entries"
  ; Test if the captured entry is a TODO, if so insert the created
  ; timestamp property, otherwise ignore
  (when (member (org-get-todo-state) org-todo-keywords-1)
    (mrb/insert-created-timestamp)))
(ad-activate 'org-capture)

;; Add feature to allow easy adding of tags in a capture window
(defun mrb/add-tags-in-capture()
  (interactive)
  "Insert tags in a capture window without losing the point"
  (save-excursion
    (org-back-to-heading)
    (org-set-tags)))
;; Bind this to a reasonable key
(define-key org-capture-mode-map "\C-c\C-t" 'mrb/add-tags-in-capture)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Use helm-org-rifle to search through an org buffer
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(require 'helm-org-rifle)

(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key "\M-n" 'outline-next-visible-heading)
            (local-set-key "\M-p" 'outline-previous-visible-heading)
            (local-set-key "\M-s" 'helm-org-rifle-current-buffer)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(define-key org-mode-map "\M-q" 'org-fill-paragraph)



(provide 'org-mode-config)
