# # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# # Initialization code that may require console input (password prompts, [y/n]
# # confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

PS1="%F{242} %~  %F{40} %F{231}"


# Lines configured by zsh-newuser-install
HISTSIZE=40000
SAVEHIST=40000
setopt SHARE_HISTORY
setopt beep
setopt extended_glob
bindkey -v
bindkey '^R' history-incremental-search-backward
set shellopts "-euy"
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/j03y/.zshrc'

autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

autoload -Uz compinit
compinit
### End of lines added by compinstall

HISTFILE="$XDG_STATE_HOME"/zsh/history
# Completion files: Use XDG dirs
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION


set-long-prompt() {
    eval "$(starship init zsh)"  2>/dev/null
    # starship init zsh
}

precmd_functions=(set-long-prompt)

set-short-prompt() {
  if [[ $PROMPT != '%# ' ]]; then
    PROMPT='$(starship module character)'
    RPROMPT=""
    zle .reset-prompt
  fi
}

zle-line-finish() { set-short-prompt }
zle -N zle-line-finish

trap 'set-short-prompt 2>/dev/null; return 130' INT


source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=0
ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS=0
ZSH_FZF_HISTORY_SEARCH_END_OF_LINE="true"
source $HOME/.config/zsh/zsh-fzf-history-search.zsh
AUTO_NOTIFY_THRESHOLD=10
AUTO_NOTIFY_WHITELIST+=("nmap" "pacman" "yay" "feroxbuster" "nikto" "wpscan")
source $HOME/.config/zsh/zsh-auto-notify.zsh
source $HOME/.config/zsh/zsh-should-use.zsh



function stitle() {
  echo -en "\e]2;$@\a"
}

stitle 'Terminal'

alias startx="startx $HOME/.config/xinitrc &>/dev/null"
# alias startplasma="startx $HOME/.config/xinitrc-plasma &>/dev/null"

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
	dbus-launch Hyprland &>/dev/null
fi

mark-as-target () {

    TITLE="󰚌"
    TITLE="$TITLE‎ ‎"
    if test -z "$1"
    then
        CURRENT=$(hyprctl activewindow -j | jq '.title' -r)
        TITLE="$TITLE $CURRENT"
    else
        TITLE="$TITLE $1"
    fi
    stitle "$TITLE"
}


lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1' HUP INT QUIT TERM PWR EXIT
    lfub -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

fzfcd () {
    cd "$(fzf | perl -pe 's/(.*)\/.*/$1/g')" && lfub
}

fzf-histsearch () {
	$(cat .config/zsh/histfile | tac | fzf)
}

app () {
    echo "whence -pm '*' | sed 's/.*\///' | fzf --reverse --prompt '  ' | zsh" | zsh
}

ssh () {
    if [[ $@ == "" ]]
    then
        TERM=xterm-256color /usr/bin/ssh $(grep "Host " ~/.ssh/config | perl -pe "s/Host //; s/#.*\n//" | fzf --reverse)
    else
        TERM=xterm-256color /usr/bin/ssh $@
    fi
}

# yay () {
#     if [[ $1 == "-Ss" ]]
#     then
#         shift 1
#         echo $@
#     else
#         /usr/bin/yay $@
#     fi
# }

# sftp () {
#     if [[ $@ == "" ]]
#     then
#         /usr/bin/sftp $(grep "Host " ~/.ssh/config | perl -pe "s/Host //; s/#.*\n//" | fzf --reverse)
#     else
#         /usr/bin/sftp $@
#     fi
# }

k () {
    case $1 in
        ns) kubectl config set-context --current --namespace="$(kubectl get namespaces | grep -v "NAME" | awk '{print $1}' | fzf --reverse --prompt "Select namespace: ")";;
        af) shift 1 && kubectl apply -f $@;;
        sh) kubectl exec --stdin --tty $( kubectl get pods | grep Running | fzf --reverse --prompt "Choose pod: ") -- /bin/sh;;
        *) kubectl $@
    esac
}

ya() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}



# source /home/j03y/Tech/Hacking/hackingAliases.sh

# bindkey -s '^r' '^ufzf-histsearch\n'


# If NumLock is off, translate keys to make them appear the same as with NumLock on.
# bindkey -s '^[OM' '^M'  # enter
# bindkey -s '^[Ok' '+'
# bindkey -s '^[Om' '-'
# bindkey -s '^[Oj' '*'
# bindkey -s '^[Oo' '/'
# bindkey -s '^[OX' '='

# # If someone switches our terminal to application mode (smkx), translate keys to make
# # them appear the same as in raw mode (rmkx).
# bindkey -s '^[OH' '^[[H'  # home
# bindkey -s '^[OF' '^[[F'  # end
# bindkey -s '^[OA' '^[[A'  # up
# bindkey -s '^[OB' '^[[B'  # down
# bindkey -s '^[OD' '^[[D'  # left
# bindkey -s '^[OC' '^[[C'  # right

# # TTY sends different key codes. Translate them to regular.
# bindkey -s '^[[1~' '^[[H'  # home
# bindkey -s '^[[4~' '^[[F'  # end

# autoload -Uz up-line-or-beginning-search
# autoload -Uz down-line-or-beginning-search
# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search
# bindkey  "^[[H"   beginning-of-line
# bindkey  "^[[F"   end-of-line
# bindkey  "^[[3~"  delete-char


# bindkey '^?'      backward-delete-char          # bs         delete one char backward
# bindkey '^[[3~'   delete-char                   # delete     delete one char forward
# bindkey '^[[H'    beginning-of-line             # home       go to the beginning of line
# bindkey '^[[F'    end-of-line                   # end        go to the end of line
# bindkey '^[[1;5C' forward-word                  # ctrl+right go forward one word
# bindkey '^[[1;5D' backward-word                 # ctrl+left  go backward one word
# bindkey '^H'      backward-kill-word            # ctrl+bs    delete previous word
# bindkey '^[[3;5~' kill-word                     # ctrl+del   delete next word
# bindkey '^J'      backward-kill-line            # ctrl+j     delete everything before cursor
# bindkey '^[[D'    backward-char                 # left       move cursor one char backward
# bindkey '^[[C'    forward-char                  # right      move cursor one char forward
# bindkey '^[[A'    up-line-or-beginning-search   # up         prev command in history
# bindkey '^[[B'    down-line-or-beginning-search # down       next command in history

bindkey -s '^o' '^uya\n'
bindkey -s '^k' '^ufzfcd\n'
bindkey -s '^h' '^uapp\n'


#cat ~/.config/zsh/aliases | sed 's/^/alias /; s/\t/="/; s/$/"/' | perl -pe 's/alias \"//' > /tmp/alias
#source /tmp/alias &>/dev/null


# grep -v "#" $HOME/.config/zsh/aliases | perl -pe 's/(.*)\t(.*)/alias $1="$2"/' > /tmp/alias && source /tmp/alias      # Old
# perl -pe 's/\s*#.*//; s/ *\t\t* */>:D/; s/(.*)>:D(.*)/alias $1="$2"/' $HOME/.config/zsh/aliases > /tmp/alias && source /tmp/alias
perl -pe 's/\s*#.*//; s/"/\\"/g; s/(.*) = (.*)/alias $1="$2"/' $HOME/.config/zsh/aliases > /tmp/alias && source /tmp/alias
# perl -pe 's/\s*#.*//; s/ *\t\t* */>:D/' $HOME/.config/zsh/aliases
#tmux source-file ~/.config/tmux/tmux.conf

#sudo -n loadkeys ~/.config/system/rebind.kmap 2>/dev/null

# $(cat $HOME/.local/state/allssh)
