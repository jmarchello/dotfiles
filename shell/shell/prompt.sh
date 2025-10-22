# Enable prompt command substitution
PROMPT_COMMAND="__prompt_command"

# Plugins

## git prompt
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
. $HOME/shell/vendor/git-prompt.sh

# Define prompt function
function __prompt_command() {
  # update history
  history -a

  local exit_status=$?
  local status_symbol
  local jobs_count=$(jobs | wc -l)
  local job_status=""

  if [ $jobs_count -eq 1 ]; then
    job_status="\[\033[34m\]@ "
  elif [ $jobs_count -gt 1 ]; then
    job_status="\[\033[34m\]\j@ "
  fi

  if [ $exit_status -eq 0 ]; then
    status_symbol="\[\033[32m\]√"
  else
    status_symbol="\[\033[31m\]?"
  fi

  # First line of prompt
  PS1="${status_symbol} \[\033[33m\]\W\[\033[36m\]"
  # Add git status if available
  if type __git_ps1 &>/dev/null; then
    PS1+="$(__git_ps1 ' (%s)')"
  fi

  # Second line
  PS1+="\n${job_status}\[\033[33m\]# \[\033[0m\]"
}
