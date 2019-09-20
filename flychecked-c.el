;;; flychecked-c.el --- description -*- lexical-binding: t; -*-

;;; Code:

;; Load this file after emacs has initialized

; Set this var to your clang path
(defvar checked-c-clang "/media/aeline/Extra/checkedc/llvm.obj/bin/clang-8")

(flycheck-define-checker checked-c
  "Checker using the checked c compiler"
  :command (
            checked-c-clang
            "-fsyntax-only"
            source)
  :error-patterns
  ((error line-start (file-name) ":" line ":" column ": error: " (message) line-end))
  :modes c-mode)


(add-to-list 'flycheck-checkers 'checked-c)
(flycheck-add-next-checker 'c/c++-clang 'checked-c)
