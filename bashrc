# .bashrc

# Added by Jijo
HISTSIZE=20000
HISTFILESIZE=20000
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

# store colors
PURPLE="\[\033[0;35m\]"
YELLOW="\[\033[00;33m\]"
BLUE="\[\033[01;34m\]"
CYAN="\[\033[0;36m\]"
GREEN="\[\033[01;32m\]"
RED="\[\033[0;31m\]"
VIOLET='\[\033[01;35m\]'
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
COLOR_NONE="\[\e[0m\]"
FancyX='\342\234\227'
Checkmark='\342\234\223'

# Add git branch if its present to PS1
# color_prompt="yes"
parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# function git_color {
#   local git_status="$(git status 2> /dev/null)"

#   if [[ ! $git_status =~ "working directory clean" ]]; then
#     echo -e $RED
#   elif [[ $git_status =~ "Your branch is ahead of" ]]; then
#     echo -e $YELLOW
#   elif [[ $git_status =~ "nothing to commit" ]]; then
#     echo -e $GREEN
#   else
#     echo -e $CYAN
#   fi
# }

# if [ "$color_prompt" = yes ]; then
#  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w$(git_color)$(parse_git_branch)\[\033[00m\]$ '
# else
#  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
# fi

# ----------------------------------------------------------------------------------------
source /usr/share/git-core/contrib/completion/git-prompt.sh
function color_my_prompt {
  local __user_and_host="$GREEN\u@\h"
  local __cur_location="$BLUE\W"           # capital 'W': current directory, small 'w': full file path
  local __git_branch_color="$GREEN"
  #local __prompt_tail="$VIOLET$"
  #local __user_input_color="$GREEN"
  local __git_branch=$(__git_ps1);

  # colour branch name depending on state
  if [[ "${__git_branch}" =~ "*" ]]; then     # if repository is dirty
      __git_branch_color="$RED"
  elif [[ "${__git_branch}" =~ "$" ]]; then   # if there is something stashed
      __git_branch_color="$YELLOW"
  elif [[ "${__git_branch}" =~ "%" ]]; then   # if there are only untracked files
      __git_branch_color="$LIGHT_GRAY"
  elif [[ "${__git_branch}" =~ "+" ]]; then   # if there are staged files
      __git_branch_color="$CYAN"
  fi

  # Build the PS1 (Prompt String)
  PS1="$__user_and_host $__cur_location$__git_branch_color$__git_branch\[\033[0m\] $ "
 }

#export PS1=color_my_prompt
# configure PROMPT_COMMAND which is executed each time before PS1
#export PROMPT_COMMAND=color_my_prompt

# ----------------------------------------------------------------------------------------
#PS1="\n\[\033[35m\] \$(/bin/date)\n\[\033[1;31m\]\u@\h: \[\033[1;34m\]\$(/usr/bin/tty | /bin/sed -e 's:/dev/::'): \[\033[1;34m\]\$(pwd) \[\033[1;36m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files \[\033[1;33m\]\$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\033[0m\] \[\033[0m\] \[\033[0;32m\]$(parse_git_branch) \n\[\033[0;32m\] └─\[\033[0m\033[0;32m\] ▶\[\033[0m\]"


# ----------------------------------------------------------------------------------------
# determine git branch name
function parse_git_branch(){
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Determine the branch/state information for this git repository.
function set_git_branch() {
  # Get the name of the branch.
  branch=$(parse_git_branch)

  # Set the final branch string.
  BRANCH="${PURPLE}${branch}${COLOR_NONE} "
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
  fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  if [ ! -z "$CONDA_DEFAULT_ENV" ] ; then
     PYTHON_VIRTUALENV="${BLUE}[`basename \"$CONDA_DEFAULT_ENV\"`]${COLOR_NONE} "
  elif test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
  fi
}

function timer_now {
    date +%s%N
}

function timer_start {
    timer_start=${timer_start:-$(timer_now)}
}

function timer_stop {
    local delta_us=$((($(timer_now) - $timer_start) / 1000))
    local us=$((delta_us % 1000))
    local ms=$(((delta_us / 1000) % 1000))
    local s=$(((delta_us / 1000000) % 60))
    local m=$(((delta_us / 60000000) % 60))
    local h=$((delta_us / 3600000000))
    # Goal: always show around 3 digits of accuracy
    if ((h > 0)); then timer_show=${h}h${m}m
    elif ((m > 0)); then timer_show=${m}m${s}s
    elif ((s >= 10)); then timer_show=${s}.$((ms / 100))s
    elif ((s > 0)); then timer_show=${s}.$(printf %03d $ms)s
    elif ((ms >= 100)); then timer_show=${ms}ms
    elif ((ms > 0)); then timer_show=${ms}.$((us / 100))ms
    else timer_show=${us}us
    fi
    unset timer_start
}

function set_check_mark () {
    # If it was successful, print a green check mark. Otherwise, print
    # a red X.
    if [[ $LAST_COMMAND == 0 ]]; then
        CHECK_MARK_TIMER="$CYAN$Checkmark "
    else
        CHECK_MARK_TIMER="$RED$FancyX "
    fi

    # Add the ellapsed time and current date
    timer_stop
    CHECK_MARK_TIMER+="($timer_show) \t "
}


# Set the full bash prompt.
function set_bash_prompt () {
  LAST_COMMAND=$?

  set_check_mark
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $LAST_COMMAND

  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  # Set the BRANCH variable.
  set_git_branch

  # Set the bash prompt variable.
  PS1="
$WHITE\$? ${CHECK_MARK_TIMER}${PYTHON_VIRTUALENV}${GREEN}\u@\h${COLOR_NONE}:${YELLOW}\w${COLOR_NONE}${BRANCH}
${PROMPT_SYMBOL} "
}

# Tell bash to execute this function just before displaying its prompt.
trap 'timer_start' DEBUG
PROMPT_COMMAND=set_bash_prompt

FZF_DEFAULT_OPTS="
--height 40% --layout=reverse --border
--info=inline
--multi
--preview-window=:hidden
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--prompt='∼ ' --pointer='▶' --marker='✓'
--bind '?:toggle-preview'
--bind 'ctrl-e:execute:vim -p {+} > /dev/tty'
--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
--bind 'ctrl-a:select-all'
"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias vi='vimx'
alias vim='vimx'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
_conda_setup="$('/usr/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
   if [ -f "/usr/etc/profile.d/conda.sh" ]; then
       . "/usr/etc/profile.d/conda.sh"
   else
       export PATH="/usr/bin:$PATH"
   fi
fi
unset __conda_setup
# <<< conda initialize <<<
conda deactivate
