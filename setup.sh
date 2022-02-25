#!/bin/bash

# CONFIG
git_email="your email"
git_name="your name"

mackup_storage_engine="icloud"
brewfile_path="~/Brewfile"
pip_requirement_path="~/requirements.txt"

user_specific="false"

REQUIREMENTS=(
    mackup
)

# install Xcode tools
if test "$(which git)"; then
        echo "You already have git. Continuing..."
else
        XCODE_MESSAGE="$(osascript -e 'tell app "System Events" to display dialog "Please click install when Command Line Developer Tools appears"')"
        if [ "$XCODE_MESSAGE" = "button returned:OK" ]; then
            xcode-select --install
        else
            echo "You have cancelled the installation, please install git via Xcode-tools or otherwise to run this script."
            exit
        fi fi


# install homebrew if not already installed
if test "$(which brew)"; then
    echo "You already have Homebrew. Continuing..."
else 
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install requirements
brew install "${RQUIREMENTS[@]}"

# create mackup config
echo -n "[storage]\nengine = ${mackup_storage_engine}" >> "${HOME}/.mackup.cfg"

# restore settings with mackup :)
mackup restore

# install brew packages from Brewfile
# NOTE: Brewfile should be pulled down from mackup restore
if test -f "${brewfile_path}"; then
    brew bundle --file "${brewfile_path}"
else 
    echo "Brewfile not found. Continuing..."
fi

# install pip packages
# NOTE: requirements.txt should be pulled down from mackup restore
if test -f "${pip_requirements_path}"; then
    pip3 install -r "${pip_requirements_path}"
else
    echo "requirements.txt not found. Continuing..."
fi

echo -n "Waiting for Xcode-tools to install to continue"
until test "$(which git)"; do
        echo -n "."
        sleep 1
done

echo "\nXcode-tools has finished installing\n"

# set up git
echo "Continuing to git setup"
git config --global user.name "${git_name}"
git config --global user.email "${git_email}"

# create ssh key and add to github
ssh-keygen -t rsa -b 4096 -C "${git_email}"
pbcopy < ~/.ssh/id_rsa.pub
open https://github.com/settings/ssh/new
read -p "Press [Enter] key after adding key"

if [[ "${user_specific}" == "true" ]]; then
    # configure pmset settings
    sudo pmset -a tcpkeepalive 0
    sudo pmset -a proximitywake 0

    # enable skhd
    brew services start skhd

    # hide all desktop icons
    defaults write com.apple.finder CreateDesktop -bool false

    # automatically quit printer app once the print jobs complete
    defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

    # auto-hide menu bar (requires reboot to take effect)
    defaults write NSGlobalDomain _HIHideMenuBar -bool true

    # auto hide the dock
    defaults write com.apple.dock autohide -bool true

    # change screenshot location
    defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

    # avoid creating .DS_Store files on network volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    # empty Trash securely by default
    defaults write com.apple.finder EmptyTrashSecurely -bool true

    # Privacy: don’t send search queries to Apple
    defaults write com.apple.Safari UniversalSearchEnabled -bool false
    defaults write com.apple.Safari SuppressSearchSuggestions -bool true

    # Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
    defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

    # dont show recent apps in dock
    #defaults write com.apple.dock show-recents -bool false

    # increase sound quality for bluetooth headphones/headsets
    #defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 80

    # enable subpixel font rendering on non-Apple LCDs
    #defaults write NSGlobalDomain AppleFontSmoothing -int 2

    # disbale mouse acceleration
    #defaults write .GlobalPreferences com.apple.mouse.scaling -1

    ### TRANSMISSION ###
    # Hide the donate message
    #defaults write org.m0k.transmission WarningDonate -bool false
    # Hide the legal disclaimer
    #defaults write org.m0k.transmission WarningLegal -bool false
    #defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false

    ### VSCODIUM ###
    #defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
fi

# Manual steps
# Setup MountEFI quick action
# Install Vim-Plug and :PlugInstall
# Install VsCodium extensions
# Enable smart shift
# Enable firewall
