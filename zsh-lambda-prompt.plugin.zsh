autoload -Uz promptinit
promptinit
# Enable substitution in the prompt.
setopt prompt_subst

git_stuff() {
    # Autoload zsh add-zsh-hook and vcs_info functions (-U autoload w/o substition, -z use zsh style)
    autoload -Uz add-zsh-hook vcs_info
    # Run vcs_info just before a prompt is displayed (precmd)
    add-zsh-hook precmd vcs_info
    # add ${vcs_info_msg_0} to the prompt
    # e.g. here we add the Git information in red  
    RPROMPT='%F{red}${vcs_info_msg_0_}%f'

    # Enable checking for (un)staged changes, enabling use of %u and %c
    zstyle ':vcs_info:*' check-for-changes true
    # Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
    zstyle ':vcs_info:*' unstagedstr ' *'
    zstyle ':vcs_info:*' stagedstr ' +'
    # Set the format of the Git information for vcs_info
    zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
    zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'
}

if [[ $CURSOR_BEAM == 1 ]]; then
    ## Use beam shape cursor on startup.
    echo -ne '\e[5 q'

    ### Use beam shape cursor after nvim messes it up
    nvim() {
	/bin/nvim $@
	echo -ne '\e[5 q'
    }
fi

prompt_lambda_setup() {
    if [[ $GIT_STATUS == 1 ]]; then
	git_stuff
    fi

    PROMPT="%U%~%u %B%(?.%F{green}.%F{red})%%%f%b "
}

prompt_themes+=( lambda )

# DIR HASHES
if [[ $DIR_HASHES == 1 ]]; then
    hash -d p=~/projects
    hash -d cfg=~/.config
    hash -d py=~/projects/python
    hash -d pic=~/Pictures
    hash -d wp=~/Pictures/wallpaper
fi
