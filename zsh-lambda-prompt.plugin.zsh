autoload -Uz promptinit
promptinit
# Enable substitution in the prompt.
setopt prompt_subst

if [[ $GIT_STATUS == 1 ]]; then
    # Autoload zsh add-zsh-hook and vcs_info functions (-U autoload w/o substition, -z use zsh style)
    autoload -Uz add-zsh-hook vcs_info
    # Run vcs_info just before a prompt is displayed (precmd)
    add-zsh-hook precmd vcs_info
    # add ${vcs_info_msg_0} to the prompt
    # e.g. here we add the Git information in red  

    # Enable checking for (un)staged changes, enabling use of %u and %c
    zstyle ':vcs_info:*' check-for-changes true
    # Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
    zstyle ':vcs_info:*' unstagedstr ' *'
    zstyle ':vcs_info:*' stagedstr ' +'
    # Set the format of the Git information for vcs_info
    zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
    zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'
fi

if [[ $CURSOR_BEAM == 1 ]]; then
    cur() {
	echo -ne '\e[5 q'
    }

    # reset cursor before every command
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd cur
fi

# must be in the form 'prompt_{theme name}_setup'
prompt_lambda_setup() {
    [[ -z $PROMPT_CHAR ]] && PROMPT_CHAR=λ
    PROMPT="%U%~%u %B%(?.%F{green}.%F{red})${PROMPT_CHAR}%f%b "

    RED=$'\033[1;31m'
    GREEN=$'\033[0;32m'
    RESET=$'\033[0m'
    [[ $ENABLE_SUDO_PROMPT == 1 ]] && export SUDO_PROMPT="${GREEN}%u${RESET} → ${RED}[🔒root]${RESET}: "

    if [[ $GIT_STATUS == 1 ]]; then
      RPROMPT='%F{red}${vcs_info_msg_0_}%f'
    fi
}

prompt_themes+=( lambda )

# DIR HASHES
if [[ $DIR_HASHES == 1 ]]; then
    hash -d cfg=~/.config
    hash -d pic=~/Pictures
    hash -d doc=~/Documents
    hash -d py=~/projects/python
    hash -d rs=~/projects/rust
    hash -d dl=~/Downloads
    hash -d p=~/projects
fi
