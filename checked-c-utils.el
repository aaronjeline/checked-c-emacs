;;; checked-c-utils.el --- description -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

;; Set this variable to your checked-c-convert
(defvar convert-path "/media/aeline/Extra/checkedc/llvm.obj/bin/checked-c-convert")

(defvar checked-libs
  '(("<stdio.h>" "<stdio_checked.h>")
    ("<stdlib.h>" "<stdlib_checked.h>")))

(defun convert ()
  "Convert a given region to checked-c."
  (interactive)
  (save-excursion
    (mapcar (lambda (pair)
              (goto-char 0)
              (replace-string (car pair) (cadr pair)))
            checked-libs))
  (save-buffer)
  (setf (buffer-string) (shell-command-to-string
                         (concat convert-path " "(buffer-file-name)
                                 " 2> /dev/null | sed -e \"s/\r//g\""))))



(provide 'checked-c-utils)
;;; checked-c-utils.el ends here
