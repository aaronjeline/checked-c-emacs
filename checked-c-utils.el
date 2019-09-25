;;; checked-c-utils.el --- description -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

;; Set this variable to your checked-c-convert
(defvar convert-path "/media/aeline/Extra/checkedc/llvm.obj/bin/checked-c-convert")

(defvar checked-libs
  ;; List of pairs containing orignal library names and checked names.
  '(("<stdio.h>" "<stdio_checked.h>")
    ("<stdlib.h>" "<stdlib_checked.h>")
    ("<string.h>" "<string_checked.h>")))


(defun convert ()
  "Convert a the current buffer to checked-c."
  (interactive)
  ;; Replace library names before calling the conversion tool
  (save-excursion
    (mapcar (lambda (pair)
              (goto-char 0)
              (replace-string (car pair) (cadr pair)))
            checked-libs))
  (save-buffer) ;; save changes
  ;; Call out to conversion tool and replace buffer contents
  ;; Pipe 2 sed to replace windows line endings
  (setf (buffer-string) (shell-command-to-string
                         (concat convert-path " "(buffer-file-name)
                                 " 2> /dev/null | sed -e \"s/\r//g\""))))


(defvar output '())

(defun proc-filter (proc string)
  "Example process filter for interactive command.
PROC is the process handle.
STRING is the input line."
  (cond
   ;; Match a boolean option
   ((string-match "^YESNO: \\(.*\\)$" string)
    (let ((result (y-or-n-p (substring string (match-beginning 1)))))
      (process-send-string proc (if result "yes\n" "no\n"))))
   ;; Match a prompt for arbitrary text
   ((string-match "^PROMPT: \\(.*\\)$" string)
    (let ((result (read-string (substring string (match-beginning 1)))))
      (process-send-string proc (concat result "\n"))))
   ;; Match a prompt for a menu selection
   ((string-match "^MENU: \\(.*\\)# \\(.*\\)$" string)
    (let* ((choices (mapcar #'symbol-name (read
                                          (substring string
                                                     (match-beginning 1)
                                                     (match-end 1)))))
           (result (ido-completing-read (substring string (match-beginning 2))
                                        choices)))
      (process-send-string proc (concat result "\n"))))
   ;; Add line to output
   ('else (setq output (cons string output)))))


(defun comm-test ()
  "Interactive command for launching the demo interactive command."
  (interactive)
  (setq output '())
  (start-process-shell-command
   "demo"
   nil
   "/home/aeline/git/flychecked-c/a.out 2> /dev/null")
  (set-process-filter (get-process "demo") #'proc-filter)
  (set-process-sentinel
   (get-process "demo")
   (lambda (p _)
     (when (= 0 (process-exit-status p))
       (message (apply #'concat output))))))


(provide 'checked-c-utils)
;;; checked-c-utils.el ends here
