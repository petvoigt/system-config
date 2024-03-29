#
# ~/.zshrc
#
# Last changes - Dr. Peter Voigt - 2021-01-04
#

# History settings.
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
# Useful commands for listing history:
# history -i 1   # List history from first to last command
# history -n 1   # Same as above without timestamps and numbers
# history -i -20 # List last 20 commands from history
# Or:
# fc -i -l 1     # List history from first to last command
# fc -l -n 1     # Same as above without timestamps and numbers
# fc -i -l -20   # List last 20 commands from history

# Enable emacs keymap.
bindkey -e

# Key bindings.
# Useful command to list current key bindings:
# bindkey
# Some key bindings for Linux and Tmux.
if [[ `uname` == "Linux" ]] ; then
  # Cursor block del key.
  bindkey "\e[3~" delete-char
  # Cursor block end key.
  bindkey "\e[H"  beginning-of-line
  # Cursor block home key.
  bindkey "\e[F"  end-of-line
fi
# Some key bindings for FreeBSD and Tmux.
if [[ `uname` == "FreeBSD" ]] ; then
  # Cursor block del key.
  bindkey "\e[3~" delete-char
  # Cursor block end key.
  bindkey '\e[1~' beginning-of-line
  bindkey "\e[H"  beginning-of-line
  # Cursor block home key.
  bindkey '\e[4~' end-of-line
  bindkey "\e[F"  end-of-line
fi
# History search with cursor up and cursor down keys.
# Cursor up key.
bindkey "^[[A" history-search-backward
# Cursor down key.
bindkey "^[[B" history-search-forward

# Do not put duplicates into the history.
setopt hist_ignore_all_dups

# Share history between sessions.
setopt share_history

# Do not save time stamps in history file.
unsetopt extended_history

# Autocompletion with an arrow-key driven interface.
zmodload -i zsh/complist
zstyle ":completion:*" menu select

# Use colored completions with LS_COLORS.
if [[ -x "$(which dircolors)" ]] ; then
  eval $(dircolors)
  zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}
fi

# More informative completion style.
zstyle ":completion:*:descriptions" format "%U%B%d%b%u"
zstyle ":completion:*:warnings" format "%BSorry, no matches for: %d%b"

# Complete aliases.
setopt completealiases

# Display types of completions.
setopt list_types

# When completing from the middle of a word, move the cursor to the
# end of the word.
setopt always_to_end

# Allow completion from within a word/phrase.
setopt complete_in_word

# Spelling correction for commands.
setopt correctall

# Complete as much of a completion until it gets ambiguous.
setopt list_ambiguous

# Load the completion module.
zstyle :compinstall filename "~/.zshrc"
autoload -Uz compinit
compinit
setopt always_last_prompt

# Use colors; this must be done before defining the prompt.
autoload -U colors && colors

# Load available prompt themes.
autoload -U promptinit && promptinit
# Useful commands for prompt themes:
# prompt -c # show currently selected theme
# prompt -l # show available themes

# Append ~/bin to PATH if not already done so.
echo "$PATH" |grep ~/bin > /dev/null
if [[ $? -eq 0 ]] ; then
  echo "INFO: PATH is already containing $HOME/bin."
elif [[ $? -eq 1 ]] ; then
  echo "INFO: Appending $HOME/bin to PATH."
  PATH=$PATH:~/bin; export PATH
fi

# Colors and aliases for ls and grep.
if [[ `uname` == "Linux" ]] ; then
  alias ls="ls --color=auto"
elif [[ `uname` == "FreeBSD" ]] ; then
  alias ls="ls -G"
  # export CLICOLOR=yes # Alternative for line above
  if [[ -x "$(which gnuls)" ]] ; then
    alias ls="gnuls --color"
  fi
fi
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"
alias grep="grep --color=auto"
alias l="ls -CF"
alias la="ls -AlF"
alias ll="ls -alF"
alias dir="ls -al"

# Locale settings.
if [[ "$USER" == "root" ]] ; then
  export LANG=POSIX
  export LANGUAGE=$LANG
  export LC_CTYPE=en_US.UTF-8
else
  export LANG=en_US.UTF-8
  export LANGUAGE=$LANG
fi

# Printer.
export PRINTER="laser"

# Python startup.
export PYTHONSTARTUP=~/python_startup.py

# Default prompt color.
prompt_color=blue
# User specific prompt colors.
if [[ -r ~/.prompt_colors ]] ; then
  echo "INFO: Reading user specific prompt colors."
  source ~/.prompt_colors
else
  echo "INFO: Using same default prompt color for all users."
fi
# Bold prompt with prompt color above.
PROMPT="%{$fg_bold[$prompt_color]%}[%n@%m %~]%#%{$reset_color%} "

# Lynx.
export LYNX_CFG=~/.lynx.cfg

# User specific aliases.
if [[ "$USER" == "pvoigt" ]] ; then
  alias reg.pl=~/ct-ix/reg.pl
  export HEISE=~/ct-ix/inhalt.frm
  alias gnus="emacs --geometry 80x40 -rv --no-splash -f gnus"
fi

# gpg-agent of GnuPG 2.1:
# Start gpg-agent to let SSH client use it.
# gpg-connect-agent /bye
# Make gpg-agent socket known to SSH client.
if [[ -x "$(which gpgconf)" ]] ; then
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi
# Set GPG TTY.
export GPG_TTY=$(tty)
# Refresh gpg-agent tty in case user switches into an X session.
# gpg-connect-agent updatestartuptty /bye

# Terminal title.
case $TERM in
  # Works for xterm* and rxct*
  *)
    # <user>@<host>: <current_directory>
    # precmd () {print -Pn "\e]0;%n@%m: %~\a"}
    # <user>@<host>
    precmd () {print -Pn "\e]0;%n@%m\a"}
    ;;
esac

# Show git and svn branch in shell.
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git cvs svn
# or use pre_cmd, see man zshcontrib.
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
RPROMPT=$'$(vcs_info_wrapper)'

# Greeting.
ls -al
echo
echo "Hello $USER, settings are: SHELL=$SHELL, TTY=$TTY, TERM=$TERM, LANG=$LANG."
echo
who -H -u
echo
if [[ -x "$(which tmux)" ]] ; then
  echo "Listing of tmux sessions:"
  tmux ls
fi
echo
if [[ "$USER" == "pvoigt" ]] ; then
  if [[ "$TERM" == "xterm" || "$TERM" == "rxvt" ]] ; then
    if [[ -x "$(which xhost)" ]] ; then
      xhost +
    fi
    echo
  fi
fi

