# 1. PATH AND HOMEBREW COMPLETIONS SETUP
# Cache the Homebrew prefix to avoid calling $(brew --prefix) multiple times
if (( $+commands[brew] )); then
  BREW_PREFIX=$(brew --prefix)
  fpath=($BREW_PREFIX/share/zsh-completions $fpath)
fi

# 2. OH MY ZSH CORE CONFIGURATION
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 14

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"

# load zsh-completions

# autoload -U compinit && compinit

# 3. PLUGINS
plugins=(
  git
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Load Oh My Zsh (This handles compinit automatically for you)
source $ZSH/oh-my-zsh.sh

# 4. ENVIRONMENT & TOOLS
# Load NVM using the cached prefix
if [ -f "$BREW_PREFIX/opt/nvm/nvm.sh" ]; then
  source "$BREW_PREFIX/opt/nvm/nvm.sh"
fi

# Initialize Starship theme
eval "$(starship init zsh)"

# 5. FUNCTIONS

# Pushes the current branch, setting the upstream first if none exists.
gpush() {
  if git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
    git push "$@"
  else
    git push --set-upstream origin "$(git branch --show-current)" "$@"
  fi
}

# Creates a commit with the full message passed as one argument.
gitcommit() {
    git commit -m "$*"
}

# 6. ALIASES
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
alias gita="git add ."
alias gitp='gpush'
alias gitc='gitcommit'
alias c="clear"
alias ls="eza --long"
alias lg="cd ~/Code/luna-group"
alias lw="cd ~/Code/luna-group/luna-web"

# Fallback to standard ls if eza isn't installed
if (( $+commands[eza] )); then
  alias ls="eza --long"
else
  alias ls="ls -G"
fi
