(in-package :stumpwm)

;; change the prefix key to something else
(set-prefix-key (kbd "C-z"))

;; Read some doc
(define-key *root-map* (kbd "d") "exec gv")
;; Browse somewhere
(define-key *root-map* (kbd "b") "colon1 exec firefox http://duckduckgo.com/?=")
;; Ssh somewhere
(define-key *root-map* (kbd "C-s") "colon1 exec xterm -e ssh ")
;; Lock screen
(define-key *root-map* (kbd "C-l") "exec slock")

;; Launch dmenu
(define-key *root-map* (kbd "C-d") "exec dmenu_run")

;; Launch xterm
(define-key *root-map* (kbd "c") "exec xterm")
;; Launch rxvt-unicode client
(define-key *root-map* (kbd "C-c") "exec urxvtc")
;; Launch terminal
(define-key *root-map* (kbd "RET") "exec alacritty")

;; Launch emacs
(define-key *root-map* (kbd "e") "exec emacs")
;; Launch emacsclient
(define-key *root-map* (kbd "C-e") "exec emacsclient -c -a 'emacs'")

;; Quit stumpwm
(define-key *root-map* (kbd "C-q") "quit")
;; Reload stumpwm
(define-key *root-map* (kbd "C-r") "reload")

;; C-t M-s is a terrble binding, but you get the idea.
(define-key *root-map* (kbd "M-s") "duckduckgo")
(define-key *root-map* (kbd "i") "imdb")
