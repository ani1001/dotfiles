(in-package :stumpwm)

;; Autostart applications in the background
(run-shell-command "nitrogen --restore")
(run-shell-command "picom")
(run-shell-command "lxpolkit")
(run-shell-command "xsetroot -cursor_name left_ptr")

;; Interactive commands
(defun show-kernel ()
  (let ((ip (run-shell-command "uname -r" t)))
    (substitute #\Space #\Newline ip)))

(defun show-hostname ()
  (let ((host-name (run-shell-command "cat /etc/hostname" t)))
    (substitute #\Space #\Newline host-name)))

;; Bugfix for scrolling doesn't work with an external mouse in GTK+3 apps
(setf (getenv "GDK_CORE_DEVICE_EVENTS") "1")
