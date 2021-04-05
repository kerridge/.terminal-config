# Throw these next lines at the TOP of your `~/.zshrc` to configure plugins

# # ---------------------------------------------------
# # APPEND SPECIFIC PLUGINS TO MAIN LIST
# source "$(dirname "$0")/.device-config.sh"
# plugins=()
# for i in "${my_plugins[@]}"; do plugins+=($i); done
# # ---------------------------------------------------

# Loads in your device type and OS
source "$(dirname "$0")/.device-config.sh"

if [[ $currentMachine = "Work Macbook" ]]
then
    my_plugins=(
        zsh-autosuggestions
        zsh-syntax-highlighting
    )
fi