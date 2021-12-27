(in-package :stumpwm)
(setf *default-package* :stumpwm)

(load "~/.stumpwm.d/colors.lisp")
(load "~/.stumpwm.d/commands.lisp")
(load "~/.stumpwm.d/custom.lisp")
(load "~/.stumpwm.d/fonts.lisp")
(load "~/.stumpwm.d/groups.lisp")
(load "~/.stumpwm.d/keys.lisp")
(load "~/.stumpwm.d/mode-line.lisp")
(load "~/.stumpwm.d/win-rules.lisp")
(load "~/.stumpwm.d/web-jump.lisp")

;; Window appearance
(setf *message-window-padding* 2
      *message-window-gravity* :bottom-left
      *timeout-wait* 3
      *input-window-gravity* :bottom-left
      *maxsize-border-width* 3
      *transient-border-width* 2
      *normal-border-width* 3
      *window-border-style* :thin
      ;; *float-window-border* 2
      ;; *float-window-title-height* 15
      *mouse-focus-policy* :click)

;; Message and input bar colors
(set-fg-color nord4)
(set-bg-color nord0)
(set-border-color nord13)

;; Message and input bar format
(set-msg-border-width 1)

;; Window color setup
(set-win-bg-color nord9)
(set-focus-color nord10)
(set-unfocus-color nord1)
(set-float-focus-color nord12)
(set-float-unfocus-color nord14)

;; Window gravity
(set-normal-gravity :center)
(set-maxsize-gravity :center)
(set-transient-gravity :center)
