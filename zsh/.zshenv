export FG="#008888"
export MAIN_MONITOR="eDP-1"

CONF_DIR="$HOME/.config/system"

source $CONF_DIR/default-apps
source $CONF_DIR/clean-home

source $CONF_DIR/path


export DOCKER_HOST=unix:///run/user/1001/docker.sock



# source "$HOME/.local/share/cargo/env"
# ~/.config/zsh/export_home



# hacking-paths
export rockyou="$HOME/Tech/Hacking/rockyou.txt"
export linpeas="$HOME/Tech/Hacking/enumerators/linux/linpeas.sh"
export webwordlist="$HOME/Tech/Hacking/wordlists/dirbuster/directory-list-2.3-medium.txt"

# Ghidra fix
export _JAVA_AWT_WM_NONREPARENTING=1

# Rootless Docker
export DOCKER_HOST=unix:///run/user/1000/docker.sock
