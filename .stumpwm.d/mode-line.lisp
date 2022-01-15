(in-package :stumpwm)

;; Mode-line format
(setf *screen-mode-line-format* (list " ")
      *screen-mode-line-format* (list "%g | %v ^>^7 | " '(:eval (show-hostname)) "| " '(:eval (show-kernel)) "| %d ")
      *mode-line-position* :top
      *mode-line-border-width* 1
      *mode-line-pad-x* 6
      *mode-line-pad-y* 2
      *mode-line-background-color* nord0
      *mode-line-foreground-color* nord4
      *mode-line-border-color* nord13
      *mode-line-timeout* 2
      *group-format* "%n·%t%s"
      *window-format* "^b^(:fg \"#b48ead\")<%25t>"
      *time-modeline-string* "%a, %b %d, %Y (%l:%M%p )")

;; Starts the mode-line
(enable-mode-line (current-screen) (current-head) t)
