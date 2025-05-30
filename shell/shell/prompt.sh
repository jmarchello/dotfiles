if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
else
  # Enable prompt command substitution
  PROMPT_COMMAND="__prompt_command"

  # Plugins

  ## git prompt
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  . $HOME/shell/vendor/git-prompt.sh

  # Define prompt function
  function __prompt_command() {
    local exit_status=$?
    local status_symbol

    if [ $exit_status -eq 0 ]; then
      status_symbol="\[\033[32m\]√"
    else
      status_symbol="\[\033[31m\]?"
    fi

    # First line of prompt
    PS1="${status_symbol} \[\033[37m\]\W\[\033[36m\]"
    # Add git status if available
    if type __git_ps1 &>/dev/null; then
      PS1+="$(__git_ps1 ' (%s)')"
    fi

    # Second line
    PS1+="\n\[\033[33m\]# \[\033[0m\]"
  }
fi
