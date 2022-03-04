if status is-interactive
    # Commands to run in interactive sessions can go here
end

## Set values
# Hide welcome message
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"

## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
  source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

####   USER SETTINGS   ####

### EXPORT ###

export PATH="$HOME/.cabal/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export MICRO_TRUECOLOR=1

# Make nano the default editor

export EDITOR='nano'
export VISUAL='nano'

### ALIASES ###

# Vim and Emacs
alias vim="nvim"
alias em="/usr/bin/emacs -nw"
alias emacs="emacsclient -c -a 'emacs'"
alias doom-sc="~/.emacs.d/bin/doom sync"
alias doom-dr="~/.emacs.d/bin/doom doctor"
alias doom-up="~/.emacs.d/bin/doom upgrade"
alias doom-pg="~/.emacs.d/bin/doom purge"

# List
# alias ls='ls --color=auto'
# alias la='ls -a'
# alias ll='ls -alFh'
# alias l='ls'
# alias l.="ls -A | egrep '^\.'"

# Changing "ls" to "exa"
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

# Continue download
alias wget='wget -c '

# Grub update
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

# Add new fonts
alias update-fc='sudo fc-cache -fv'

# Common use
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

## Colorize the grep command output for ease of use (good for log files) ##

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Hardware info --short
alias hw='hwinfo --short'

