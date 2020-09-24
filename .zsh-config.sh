# clears last login message
clear

# ----------------------------------------------
# -------------------- SET OS ------------------
# ----------------------------------------------
unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)     os=Linux;;
  Darwin*)    os=Mac;;
  CYGWIN*)    os=Windows;;
  MINGW*)     os=MinGw;;
  *)          os="UNKNOWN:${unameOut}"
esac


# ----------------------------------------------
# ------------- SET CURRENT MACHINE ------------
# ----------------------------------------------
machineName="$(hostname)"
case "$machineName" in
  LM-C02W83C8HTD6*) currentMachine="Work Macbook";;
  KERRIDGE-PC*)     currentMachine="Home PC";;
  *)                currentMachine="Unrecognized Device"
esac

echo "Read in config for your $currentMachine"


# ---------------------------------------------
# ----------------- WORK MAC ------------------
# ---------------------------------------------
if [ $currentMachine = 'Work Macbook' ]
then
  alias dev='cd ~/dev'
  alias dl='cd ~/Downloads'
  alias xdev='cd ~/dev/Xero'

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
# ------------------- MACOS -------------------
# ---------------------------------------------
if [ $os = Mac ]
then
  alias ref='source ~/.zshrc'
  alias edconfig='code ~/.zshrc'

  alias ll='colorls -lA --sd'
  alias l='colorls -A --sd'

  # fuzzy searching function
  function f {
    $1 | fzf
  }

# ---------------------------------------------
# ------------------ WINDOWS ------------------
# ---------------------------------------------
elif [ $os = Windows ]
then
  echo "Windows"
  
  alias ref='source ~/.bashrc'
  alias edconfig='code ~/.bashrc'
fi



# ----------------------------------------------
# ------------------- GLOBAL -------------------
# ----------------------------------------------
alias ed='code ~/.terminal-config/.zsh-config.sh'
alias .='cd ../'
alias o='open .'
alias c='clear'
alias own='sudo chown -R $(whoami)'

# ----------------------------------------------
# -------------------- GIT ---------------------
# ----------------------------------------------
alias rems='git remote -v'
alias gs='git status'
alias gl='git log'
alias glo='git log --oneline'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gc='git commit'
alias gco='git checkout'
alias gpl='git push local develop'
alias deletelocalbranch='git branch -D'
alias deleteremotebranch='git push local --delete'


# interactive rebase for a specific count of commits
# $1 : number of commits to pop
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
}