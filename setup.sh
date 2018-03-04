#!/usr/bin/env bash

brews=(
  awscli
  git
  go
  node
  yarn
  python
  python3
)

casks=(
  adobe-reader
  docker
  dropbox
  google-chrome
  google-chrome-canary
  slack
  spotify
  atom
  firefox
)

npms=(
  nodemon
  jest
  next
)

apms=(
  prettier-atom
  atom-beautify
  autocomplete-modules
  emmet
  file-icons
  es6-javascript
  filesize
  go-plus
  gpp-compiler
  language-babel
  linter
  linter-eslint
  linter-ui-default
  platformio-ide-terminal
  react-snippets
)

fonts=(
  font-fira-code
)

######################################## End of app list ########################################
set +e
set -x

function prompt {
  read -p "Hit Enter to $1 ..."
}

if test ! $(which brew); then
  prompt "Install Xcode"
  xcode-select --install

  prompt "Install Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  prompt "Update Homebrew"
  brew update
  brew upgrade
fi
brew doctor
brew tap homebrew/dupes

function install {
  cmd=$1
  shift
  for pkg in $@;
  do
    exec="$cmd $pkg"
    prompt "Execute: $exec"
    if ${exec} ; then
      echo "Installed $pkg"
    else
      echo "Failed to execute: $exec"
    fi
  done
}

prompt "Install Java"
brew cask install java

prompt "Install NVM"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

prompt "Install packages"
brew info ${brews[@]}
install 'brew install' ${brews[@]}

prompt "Install software"
brew tap caskroom/versions
brew cask info ${casks[@]}
install 'brew cask install' ${casks[@]}

prompt "Installing secondary packages"
install 'npm install --global' ${npms[@]}
install 'apm install' ${apms[@]}
brew tap caskroom/fonts
install 'brew cask install' ${fonts[@]}

prompt "Cleanup"
brew cleanup
brew cask cleanup
