# arShell
A repo for my shell dotfiles

---

# Dependencies:
- zsh
- starship
- yazi
- nerd fonts

---

# Aliases
Append this to your `.*shrc`
```bash
perl -pe 's/\s*#.*//; s/"/\\"/g; s/(.*) = (.*)/alias $1="$2"/' $HOME/.local/src/arshell/aliases > /tmp/alias && source /tmp/alias

```
