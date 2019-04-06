# vim: ft=zsh sw=4 ts=4

fpath=(
	"${HOME}/.zsh/completions"
	"${HOME}/.zsh/prompts"
	$fpath
)

ZCOMPDUMP="${HOME}/.cache/zsh/.zcompdump"

# Debugging (You might want to turn these off)
# zmodload zsh/zprof
# setopt SOURCE_TRACE
# setopt WARN_CREATE_GLOBAL
# setopt WARN_NESTED_VAR
# setopt PRINT_EXIT_VALUE
# setopt EVAL_LINENO

# Enable ZLE
setopt ZLE

# Enable vim-like line-editing
setopt VI

# Output hexadecimal in the standard C format of `0xFF` instead of `16#FF`
setopt C_BASES

# Allow Multiple pipes, sounds like something we'd like
setopt MULTIOS

# Allow comments in interactive shells
setopt INTERACTIVE_COMMENTS
setopt AUTO_NAME_DIRS

# Completion behaviour options
setopt BASH_AUTO_LIST
setopt CHASE_DOTS
setopt CHASE_LINKS
#setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt MAGIC_EQUAL_SUBST
setopt MULTIBYTE
setopt NUMERIC_GLOB_SORT


# Globbing options
#setopt GLOB_COMPLETE
setopt NUMERIC_GLOB_SORT
#setopt NO_CASE_GLOB
setopt EXTENDEDGLOB

setopt AUTO_PUSHD

## History wrapper
function omz_history {
  local clear list
  zparseopts -E c=clear l=list

  if [[ -n "$clear" ]]; then
    # if -c provided, clobber the history file
    echo -n >| "$HISTFILE"
    echo >&2 History file deleted. Reload the session to see its effects.
  elif [[ -n "$list" ]]; then
    # if -l provided, run as if calling `fc' directly
    builtin fc "$@"
  else
    # unless a number is provided, show all history events (starting from 1)
    [[ ${@[-1]} = *[0-9]* ]] && builtin fc -l "$@" || builtin fc -l "$@" 1
  fi
}

# Timestamp format
case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='omz_history -f' ;;
  "dd.mm.yyyy") alias history='omz_history -E' ;;
  "yyyy-mm-dd") alias history='omz_history -i' ;;
  "") alias history='omz_history' ;;
  *) alias history="omz_history -t '$HIST_STAMPS'" ;;
esac

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*' list-separator 'fREW'

# Unset annoying things
unsetopt BEEP
unsetopt AUTOCD

# Source functions
[[ -r "${HOME}/.funcs" ]] && source "${HOME}/.funcs"

# Using gpg as ssh agent
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

# Enable fzf (pacman -S fzf)
[[ -r /usr/share/fzf/key-bindings.zsh ]] && \
	source "/usr/share/fzf/key-bindings.zsh"
[[ -r "/usr/share/fzf/completion.zsh" ]] && \
	source "/usr/share/fzf/completion.zsh"

bindkey -v
bindkey '^e' end-of-line
bindkey '^a' beginning-of-line
bindkey '^r' history-incremental-search-backward
bindkey -M vicmd "/" history-incremental-search-backward
bindkey -M vicmd "?" history-incremental-search-forward
bindkey -M vicmd "//" history-beginning-search-backward
bindkey -M vicmd "??" history-beginning-search-forward
bindkey -M vicmd "q" push-line
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M vicmd 'u' undo

# bindkey '^p'

# commandline completion
if hash pandoc 2>/dev/null; then
	eval $(pandoc --bash-completion)
fi
#autoload -U +X bashcompinit && bashcompinit

ZLS_COLORS=""; zmodload -i zsh/complist

setopt COMPLETE_ALIASES
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${_ZSH_CACHE}
zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' file-sort name
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]} l:|=* r:|=*' 'm:{[:lower:]}={[:upper:]} l:|=* r:|=*' 'm:{[:lower:]}={[:upper:]} l:|=* r:|=*' 'm:{[:lower:]}={[:upper:]} l:|=* r:|=*'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

autoload -Uz compinit
compinit -C -d "${ZCOMPDUMP}"

# easy to use zsh hooks that does nothing at the moment
[[ -r "${HOME}/.zsh/hooks" ]] && source "${HOME}/.zsh/hooks"
autoload -Uz promptinit; promptinit

# PURE_GIT_DELAY_DIRTY_CHECK=1800
PURE_GIT_DOWN_ARROW="⇣"
PURE_GIT_UP_ARROW="⇡"
PURE_CMD_MAX_EXEC_TIME=5
PURE_PROMPT_SYMBOL="♕"
PURE_PROMPT_VICMD_SYMBOL="♔"
PURE_GIT_PULL=0
prompt pure

# Source ~/.alias
[[ -r "${HOME}/.alias" ]] && source "${HOME}/.alias"

# No delay for normal mode
# KEYTIMEOUT=1

# Set space as the 'leader' key
bindkey -a -r ' '
# Open man-page on current command (Leaves command untouched) (Esc+space+m)
# bindkey -a ' 'm run-help

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export BROWSER=firefox
export EDITOR=vim
export SYSTEMD_EDITOR=vim
export PAGER=less
export MANPAGER=less
export TERMINAL=xfce4-terminal

base16-manager set ocean

eval "$(pyenv init -)"
