# Welcome! Throw these next lines at the BOTTOM of your `~/.zshrc` to read in this file

# # ---------------------------------------------------
# # LOAD IN EXTERNAL CONFIG
# [[ ! -f ~/.terminal-config/.zsh-config.sh ]] || source ~/.terminal-config/.zsh-config.sh
# # ---------------------------------------------------

# Loads in your device name and OS
source "$(dirname "$0")/.device-config.sh"

# clears iTerm2 last login message
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
alias gidday="printf \"\e[32m\" && figlet -f standard"

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

# pops and opens last commit for editing/squashing changes in
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

function gpsup {
    git_current_branch=$(git symbolic-ref --short HEAD)
    git push --set-upstream origin $git_current_branch
}

function disable-push {
  git remote set-url --push upstream DISABLED
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


# ----------------------------------------------------------------------------------------------------
# --------------------------------------------- OS SPECIFIC ------------------------------------------
# ----------------------------------------------------------------------------------------------------
# ---------------------------------------------
# ------------------- MACOS -------------------
# ---------------------------------------------
if [ $os = Mac ]
then
  printf "\e[32m" && figlet -w 150 -f roman "yo my dude"
  printf "\e[35m" && figlet -c -w 150 -f smslant "$currentMachine"

  alias ref='source ~/.zshrc'
  alias edconfig='code ~/.zshrc'

  alias ll='colorls -lA --sd'
  alias l='colorls -A --sd'

  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#939393,bold,underline"

  # shows available custom plugin commands
  function options() {
    PLUGIN_PATH="$HOME/.oh-my-zsh/custom/plugins/"
    for plugin in $plugins; do
        echo "\n\nPlugin: $plugin"; grep -r "^function \w*" $PLUGIN_PATH$plugin | awk '{print $2}' | sed 's/()//'| tr '\n' ', '; grep -r "^alias" $PLUGIN_PATH$plugin | awk '{print $2}' | sed 's/=.*//' |  tr '\n' ', '
    done
  }

  # ---------------------------------------
  # -------------- WORK MAC ---------------
  # ---------------------------------------
  if [[ $currentMachine = "Work Macbook" ]]
  then
    alias dev='cd ~/dev'
    alias dl='cd ~/Downloads'
    alias xdev='cd ~/dev/Xero'

    # records an MP4 video of the simulator to ~/dev/recordings
    # $1 : filename of video to save
    function record {
      dev
      cd recordings
      xcrun simctl io booted recordVideo $1.mp4
    }

    # runs swiftlinter
    function swiftlint {
        xdev
        './Pods/SwiftLint/swiftlint'
    }

    # sends a pre-configured json push payload to simulator
    # $1 : push payload filename
    function send-push {
      xcrun simctl push booted com.xero.AuthenticatorApp ~/dev/push/$1.json
    }

    # registers test device to work with xCode
    function register-device {
      bundle exec fastlane match development --readonly
    }
  fi

# ---------------------------------------------
# ------------------ WINDOWS ------------------
# ---------------------------------------------
elif [ $os = Windows ]
then
  echo "Read in config for your $currentMachine"

  alias ref='source ~/.bashrc'
  alias edconfig='code ~/.bashrc'

  # ---------------------------------------
  # --------------- WORK PC ---------------
  # ---------------------------------------
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
fi
