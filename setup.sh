#!/bin/bash

## make sure xcode tools are installed
# make sure mac app store is logged in
# CONFIG
git_email="edemoney@mail.csuchico.edu"
git_name="Eric DeMoney"

BREWPACKAGES=(
    autojump
    go
    git
    bat
    mas
    tree
    tldr
    unar
    node # for coc.vim
    trash
    mackup
    neovim
    ripgrep
    antigen
    thefuck
    prettyping
    speedtest-cli
    font-fira-code-nerd-font
    koekeishiya/formulae/skhd
    clementtsang/bottom/bottom
)

CASKPACKAGES=(
    eul
    staruml
    dozer
    darktable
    the-unarchiver
    amethyst	
    transmission
    iterm2
    zoom
    discord
    openinterminal
    plexamp
    qlvideo
    qlmarkdown
    qlcolorcode
    quicklook-csv
    quicklook-json
    syncthing
    appcleaner
    1password
    vscodium
    notion
    staruml
    karabiner-elements
)

MACAPPS=(
    # safari extensions
    1514703160 # focus for youtube
    1397180934 # dark mode for safari
    1239207203 # about:blank
    1480933944 # vimari
    1376402589 # stopthemadness
    1018301773 # adblock
    # apps
    1303222628 # paprika
    290986013 # deliveries
    1529448980 # reeder. 5
    937984704 # amphetamine
    967805235 # paste
    411643860 # daisydisk
)

PIPPACKAGES=(
    pynvim
)

# ask for the administrator password upfront
sudo -v

set -x
# install xcode tools
xcode-select --install

    # WAIT
    # SSH ADD KEY
    # set up git
    git config --global user.name "${git_name}"
    git config --global user.email "${git_email}"

# create ssh key and add to github
ssh-keygen -t rsa -b 4096 -C ${git_email}
pbcopy < ~/.ssh/id_rsa.pub
open https://github.com/settings/ssh/new
read -p "Press [Enter] key after adding key"

# install homebrew if not already installed
if test ! $(which brew); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# update homebrew formulae
brew update

brew tap homebrew/cask-fonts 

# install packages
brew install ${BREWPACKAGES[@]}
brew install --cask ${CASKPACKAGES[@]}

# cleanup packages
brew cleanup

# enable skhd
brew services start skhd

# install fzf extras
$(brew --prefix)/opt/fzf/install

# install mac app store apps
mas install ${MACAPPS[@]}

# upgrade pip
python3 -m pip install --upgrade pip

# install pip packages
pip3 install ${PIPPACKAGES[@]}

### MANUAL INSTALLS ###

# install logi options
curl https://download01.logi.com/web/ftp/pub/techsupport/options/Options_8.36.76.zip --output options.zip
unar options.zip
appfile="$(find . -maxdepth 1 -name "LogiMgr Installer*.app")"
open $appfile
read -p "Press [Enter] key after installing"
trash $appfile options.zip

# install logo-ls (requires icon font configured in iterm)

### RESTORE SETTINGS ###

# restore settings with mackup :)
mackup restore

# get dotfiles

### ZSH CONFIG ###
# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# activate antigen (MAKE SURE ZSHRC IS LOADED FIRST)
source ~/.zshrc

# fix insecure directories for zsh completions
compaudit | xargs chmod g-w,o-w

# enable vim keys in zsh
#echo "bindkey -v" >> ~/.zshrc

# add some nice zsh plugins

# source changes
source ~/.zshrc

### NEOVIM CONFIG ###
# install vim-plug 
# TODO: test if already installed
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


### HOUSEKEEPING ###

# hide all desktop icons
#defaults write com.apple.finder CreateDesktop -bool false

# automatically quit printer app once the print jobs complete
#defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# auto-hide menu bar (requires reboot to take effect)
#defaults write NSGlobalDomain _HIHideMenuBar -bool true

# auto hide the dock
#defaults write com.apple.dock autohide -bool true

# dont show recent apps in dock
#defaults write com.apple.dock show-recents -bool false

# increase sound quality for bluetooth headphones/headsets
#defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 80

# change screenshot location
#defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

# enable subpixel font rendering on non-Apple LCDs
#defaults write NSGlobalDomain AppleFontSmoothing -int 2

### FINDER ###
# avoid creating .DS_Store files on network volumes
#defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# empty Trash securely by default
#defaults write com.apple.finder EmptyTrashSecurely -bool true

# disbale mouse acceleration
#defaults write .GlobalPreferences com.apple.mouse.scaling -1

### SAFARI ###
# Privacy: don’t send search queries to Apple
#defaults write com.apple.Safari UniversalSearchEnabled -bool false
#defaults write com.apple.Safari SuppressSearchSuggestions -bool true

### MAIL.app ###
# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
#defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

### TRANSMISSION ###
# Hide the donate message
#defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
#defaults write org.m0k.transmission WarningLegal -bool false
#defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false

### VSCODIUM ###
#defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# configure pmset settings
sudo pmset -a tcpkeepalive 0
sudo pmset -a proximitywake 0

set +x


        # update wallpaper in preboot enviroment to custom
        # diskutil apfs updatePreboot /
        # speed up trackpad
        # tap to click
        # enable firewall

# hackintosh
# move efi folder over
# get mountefi
# quick action
# yogasmc
# remap capslock to esc
# set up text message forwarding
# install pip packages for neovim etc
# set up media keys
# set up skhd with media keys
# skhd applescrips for iterm etc
# enable smart shift
# set wallpapers
# ssh config
# neovim setup
# vscodium setup
# iterm setup colors and transparency/ minimal look
# enable drag lock in accessability settings
# set accent color
# iterm set dim inactive
# swap antigen for antibody?
# https://project-awesome.org/unixorn/awesome-zsh-plugins#antibody
# give iterm full disk access in security settings
# 212124 background code
# set bar to left in iterm
# import all base16 colorschemes for iterm
# enable all the gestures
# enable qlcolorcode in security and privacy
# track wallpapers folder
# sessions from github

# https://github.com/AlexPerathoner/Sessions/releases/tag/v1.6.1
