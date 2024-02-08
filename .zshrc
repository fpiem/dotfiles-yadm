zmodload zsh/zprof

alias intel="env /usr/bin/arch -x86_64 /bin/zsh --login"
alias arm="env /usr/bin/arch -arm64 /bin/zsh --login"

alias ibrew='arch -x86_64 /usr/local/bin/brew'
alias mbrew='arch -arm64 /opt/homebrew/bin/brew'
bindkey -M vicmd 'V' edit-command-line # this remaps `vv` to `V` (but overrides `visual-mode`)
if [ "$(arch)" = "i386" ]
then
  echo "Using i386 architecture"
  eval "$(/usr/local/bin/brew shellenv)"
  export PYENV_ROOT="$HOME/.pyenv/x86"
elif [ "$(arch)" = "arm64" ]
then
  echo "Using arm64 architecture"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PYENV_ROOT="$HOME/.pyenv/arm"
fi

eval "$(pyenv init -)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

export KEYTIMEOUT=1  # reduce timeout in switching to vim mode

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true

# Initialize modules
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# zsh-history-substring-search
zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key

export XDG_CONFIG_HOME="${HOME}/.config"

# Personal aliases
alias lg="lazygit"
alias ld="lazydocker"
alias cl="clear"
alias cb="cargo build"
alias cr="cargo run"
alias rr="ranger"
alias da="direnv allow"
alias gsw="git switch"
alias "gcp"="git cherry-pick"
alias 'FUCK'='fuck --yeah'
alias idea='open -a "IntelliJ IDEA.app"'
alias lgy="lazygit -ucd ~/.local/share/yadm/lazygit -w ~ -g ~/.local/share/yadm/repo.git"
eval $(thefuck --alias)

source ${HOME}/.dkurc

# Finalize p10k to avoid error prompt when starting a new terminal.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
(( ! ${+functions[p10k]} )) || p10k finalize

# Direnv
# export DIRENV_LOG_FORMAT=
eval "$(direnv hook zsh)"

# FZF
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse'
# disable sort when completing `git checkout`
zstyle ':completion:*:git:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# Created by `pipx` on 2023-06-13 08:21:00
export PATH="$PATH:/Users/francescopiemontese/.local/bin"

export HISTFILESIZE=1000000
export HISTSIZE=1000000

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/francescopiemontese/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/francescopiemontese/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/francescopiemontese/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/francescopiemontese/google-cloud-sdk/completion.zsh.inc'; fi

export CLOUDSDK_PYTHON="/Users/francescopiemontese/.pyenv/x86/shims/python3.8"

# zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=/Users/francescopiemontese/.local/share/bob/nvim-bin:$PATH
export PATH=/Users/francescopiemontese/.local/share/nvim-macos:$PATH

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

fpath+=~/.zfunc

