# ----------------------------------------------
# ------------------- ALIASES ------------------
# ----------------------------------------------
alias ed='code ~/.zshrc'
alias ref='source ~/.zshrc'
alias dev='cd ~/dev'
alias dl='cd ~/Downloads'
alias xdev='cd ~/dev/Xero'
alias .='cd ../'
alias o='open .'
alias c='clear'

alias ll='colorls -lA --sd'
alias l='colorls -A --sd'

# ----------------------------------------------
# -------------------- GIT ---------------------
# ----------------------------------------------
alias rems='git remote -v'
alias gs='git status'
alias gl='git log'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gc='git commit'
alias gco='git checkout'


function commit {
  git add .
  git commit
}

function record {
  dl
  cd recordings
  xcrun simctl io booted recordVideo $1.mp4
}

function swiftlint {
    xdev
    './Pods/SwiftLint/swiftlint'
}