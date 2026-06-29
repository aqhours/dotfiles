# ███████╗███████╗██╗  ██╗
# ╚══███╔╝██╔════╝██║  ██║
#   ███╔╝ ███████╗███████║
#  ███╔╝  ╚════██║██╔══██║
# ███████╗███████║██║  ██║
# ╚══════╝╚══════╝╚═╝  ╚═╝
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="robbyrussell"  # 使用 starship 时此项会被覆盖

plugins=(
    # --- 基础/系统 ---
    git
    command-not-found
    
    # --- 开发环境 ---
    brew
    nvm
    npm
    yarn
    bun
    poetry
    docker
    kubectl
    
    # --- 补全增强 ---
    zsh-autosuggestions
    zsh-completions
    zsh-interactive-cd
)

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# 环境变量
# ==============================================================================


export TIME_STYLE="+%Y-%m-%d %H:%M:%S"
export PATH="$PATH:$HOME/.local/bin"                            # pipx

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ==============================================================================
# 工具初始化
# ==============================================================================


# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# conda
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# vfox
eval "$(vfox activate zsh)"

# zoxide
eval "$(zoxide init zsh)"

#eza
# 检查 eza 是否存在，存在则设置别名
if (( $+commands[eza] )); then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lh --icons --group-directories-first'
  alias la='eza -a --icons --group-directories-first'
  alias tree='eza --tree --icons'
fi

# bun completions
[ -s "/Users/jiiong/.bun/_bun" ] && source "/Users/jiiong/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ==============================================================================
# 提示符 & 语法高亮（保持在文件末尾）
# ==============================================================================


eval "$(starship init zsh)"

# Added by Antigravity
export PATH="/Users/jiiong/.antigravity/antigravity/bin:$PATH"

# zsh-syntax-highlighting（必须在 .zshrc 最后加载）
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh




# Added by Antigravity CLI installer
export PATH="/Users/jiiong/.local/bin:$PATH"
