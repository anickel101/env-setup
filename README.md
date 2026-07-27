# Zsh Setup Guide (macOS)

This guide installs the packages used by the current shell setup and shows the expected `.zshrc` configuration outcome.

## 1. Prerequisites

Install Homebrew (if needed):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 2. Install Relevant Packages

```bash
brew install zsh-completions zsh-autosuggestions zsh-syntax-highlighting
brew install starship zoxide fzf eza nvm
```

## 3. Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## 4. Enable fzf Keybindings + Completion

```bash
"$(brew --prefix)"/opt/fzf/install
```

Suggested answers during the prompt:

- Key bindings: `y`
- Fuzzy completion: `y`
- Shell history override: `n`

## 5. Use This `.zshrc` Template

Replace or align your `~/.zshrc` with the following:

```zsh
# Ensure non-login interactive shells also load login/profile exports.
# Login shells already source ~/.zprofile automatically, so guard this to avoid
# duplicates.
if [[ ! -o login && -f "$HOME/.zprofile" ]]; then
  source "$HOME/.zprofile"
fi

# 1. PATH AND HOMEBREW COMPLETIONS SETUP
# Cache the Homebrew prefix to avoid calling $(brew --prefix) multiple times
if (( $+commands[brew] )); then
  BREW_PREFIX="$(brew --prefix)"
  fpath=("$BREW_PREFIX/share/zsh-completions" $fpath)
fi

# 2. OH MY ZSH CORE CONFIGURATION
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 14

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"

# 3. PLUGINS
plugins=(
  git
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Load Oh My Zsh (This handles compinit automatically for you)
source "$ZSH/oh-my-zsh.sh"

# 4. ENVIRONMENT & TOOLS
# Load NVM using the cached prefix
if [[ -n "$BREW_PREFIX" && -f "$BREW_PREFIX/opt/nvm/nvm.sh" ]]; then
  source "$BREW_PREFIX/opt/nvm/nvm.sh"
fi

# Initialize Starship theme
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# Initialize zoxide (smart cd)
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# fzf
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# 5. FUNCTIONS

gpush() {
  if git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
    git push "$@"
  else
    git push --set-upstream origin "$(git branch --show-current)" "$@"
  fi
}

gitcommit() {
  if [ $# -eq 0 ]; then
    echo "Usage: gitc <commit message>"
    return 1
  fi

  git commit -m "$*"
}

# 6. ALIASES
alias cd="z"
alias cdi="zi"
alias ip="ipconfig getifaddr en0"
alias zshconfig="code ~/.zshrc"
alias zshprofile="code ~/.zprofile"
alias zshsource="source ~/.zshrc"
alias ohmyzsh="cd ~/.oh-my-zsh"
alias starshipconfig="code ~/.config/starship.toml"
alias gitconfig="vim ~/.gitconfig"
alias gits="git status"
alias gitd="git diff"
alias gitl="git lg"
alias gita="git add -A"
alias gitp='gpush'
alias gitc='gitcommit'
alias c="clear"
alias lg="cd ~/Code/luna-group"
alias lw="cd ~/Code/luna-group/luna-web"

# Fallback to standard ls if eza isn't installed
if (( $+commands[eza] )); then
  alias ls="eza --long"
else
  unalias ls 2>/dev/null
fi
```

## 6. Reload and Verify

```bash
source ~/.zshrc
zsh -n ~/.zshrc && echo "syntax-ok"
```

Optional checks:

```bash
command -v starship
command -v zoxide
command -v fzf
command -v eza
```

## 7. Starship Config (`starship.toml`) Note

The prompt initialization in `.zshrc` only enables Starship. Prompt appearance is controlled by:

- `~/.config/starship.toml`

If the file does not exist yet, create it:

```bash
mkdir -p ~/.config
touch ~/.config/starship.toml
```

Then apply prompt changes by reloading your shell:

```bash
source ~/.zshrc
```
