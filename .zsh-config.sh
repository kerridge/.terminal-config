# Welcome! Throw these next lines in your `~/.zshrc` to read in this file and configure plugins

# # ---------------------------------------------------
# # LOAD IN EXTERNAL CONFIG
# source ~/.terminal-config/.zsh-config.sh
# # APPEND DEVICE SPECIFIC PLUGINS TO MAIN LIST
# for i in "${my_plugins[@]}"; do plugins+=($i); done
# # ---------------------------------------------------


# clears last login message
clear

# ----------------------------------------------------------------------------------------------------
# ------------------------------------------------ GLOBAL --------------------------------------------
# ----------------------------------------------------------------------------------------------------

# ----------------------------------------------
# ----------------- ESSENTIALS -----------------
# ----------------------------------------------
alias ed='code ~/.terminal-config/.zsh-config.sh'
alias .='cd ../'
alias l='ls'
alias ll='ls -la'
alias o='open .'
alias c='clear'
alias own='sudo chown -R $(whoami)'
alias weather="curl wttr.in/Wellington"
alias we="curl wttr.in/Wellington\?1nqF"
alias gidday="printf \"\e[93m\" && figlet -f standard"

# ----------------------------------------------
# -------------------- GIT ---------------------
# ----------------------------------------------
alias rems='git remote -v'
alias gs='git status'
alias gl='git log'
alias gd='git diff'
alias glo='git log --oneline'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gc='git commit'
alias gco='git checkout'
alias gpl='git push local develop'
alias deletelocalbranch='git branch -D'
alias deleteremotebranch='git push local --delete'

function oops {
  git commit --amend
}

# interactive rebase for a specific count of commits
# $1 : number of commits to pop off
function irb {
  git rebase -i HEAD~$1
}

# add all files and open commit
function commit {
  git add .
  git commit
}

# get latest config and push update
function update-zsh {
  cd ~/.terminal-config
  git pull origin master
  git add .
  git commit -m 'Updating zsh-config.sh'
  git push origin master
}

# add a new upstream and disable push
# $1 : upstream url
function new-upstream {
  git remote add upstream $1
  git remote set-url --push upstream DISABLED
  rems
}


function send-push {
  xcrun simctl push booted com.xero.AuthenticatorApp ~/dev/push/$1.json
}

function register-device {
  bundle exec fastlane match development --readonly
}

function gpsup {
    git_current_branch=$(git symbolic-ref --short HEAD)
    git push --set-upstream origin $git_current_branch
}

# networking
alias ports='netstat -ao'

# clone a new repo and rename to local
# $1 : remote url
# function new-local {
#   cd ~/dev;
#   git clone $1
#   cd
#   `git remote rename origin local`;
# }

# ----------------------------------------------
# -------------------- SET OS ------------------
# ----------------------------------------------
unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)     os=Linux;;
  Darwin*)    os=Mac;;
  CYGWIN*)    os=Windows;;
  MINGW*)     os=Windows;;
  *)          os="UNKNOWN:${unameOut}"
esac


# ----------------------------------------------
# ------------- SET CURRENT MACHINE ------------
# ----------------------------------------------
machineName="$(hostname)"
case "$machineName" in
  LM-C02W83C8HTD6*) currentMachine="Work Macbook";;
  KERRIDGE-PC*)     currentMachine="Home PC";;
  XLW-5CD0036MR8*)  currentMachine="Work PC";;
  *)                currentMachine="Unrecognized Device - ${machineName}"
esac

echo "Read in config for your $currentMachine"

# ----------------------------------------------------------------------------------------------------
# ------------------------------------------- DEVICE SPECIFIC ----------------------------------------
# ----------------------------------------------------------------------------------------------------

# ---------------------------------------------
# ----------------- WORK MAC ------------------
# ---------------------------------------------
if [[ $currentMachine = "Work Macbook" ]]
then
  printf "\e[93m" && figlet -f standard "yo my dude"
  echo "\n"

  alias dev='cd ~/dev'
  alias dl='cd ~/Downloads'
  alias xdev='cd ~/dev/Xero'

  # my_plugins=(django)

  function record {
    dl
    cd recordings
    xcrun simctl io booted recordVideo $1.mp4
  }

  function swiftlint {
      xdev
      './Pods/SwiftLint/swiftlint'
  }
fi

# ---------------------------------------------
# ----------------- WORK PC -------------------
# ---------------------------------------------
if [[ $currentMachine = "Work PC" ]]
then
  alias ref='source ~/.bashrc'
  alias edconfig='code ~/.bashrc'

  # execute command using work aws profile
  # @ : command to be run
  function aws-work {
      aws-vault exec work -- bash -c "'$@'"
  }

  default_namespace='bank-feeds'
  namespace=$default_namespace

  # kubernetes/k8s shorthand command
  # -n : namespace override if not using default
  # @  : command to be run
  function k {
      local OPTIND flag n
      while getopts 'n:' flag; do
          case "${flag}" in
            n)
              namespace="${OPTARG}"
              ;;
          esac
      done
      shift $((OPTIND-1))

      aws-work kubectl -n $namespace $@
  }
fi

# ----------------------------------------------------------------------------------------------------
# --------------------------------------------- OS SPECIFIC ------------------------------------------
# ----------------------------------------------------------------------------------------------------

# ---------------------------------------------
# ------------------- MACOS -------------------
# ---------------------------------------------
if [ $os = Mac ]
then
  alias ref='source ~/.zshrc'
  alias edconfig='code ~/.zshrc'

  alias ll='colorls -lA --sd'
  alias l='colorls -A --sd'

  # fuzzy searching function
  bindkey "ç" fzf-cd-widget

  # function f {
  #   $1 | fzf
  # }

# ---------------------------------------------
# ------------------ WINDOWS ------------------
# ---------------------------------------------
elif [ $os = Windows ]
then
  echo "Windows"

  alias ref='source ~/.bashrc'
  alias edconfig='code ~/.bashrc'
fi
