#!/usr/bin/env bash

brews=(
  cf-cli
  git
  gradle
  go
  hh
  htop
  imagemagick --with-webp
  maven
  neofetch
  node
  openssl@1.1
  python
  python3
  ruby
  scala
  wget
  yarn
)

casks=(
  adobe-reader
  atom
  datagrip
  dbvisualizer
  docker
  firefox
  google-chrome
  google-backup-and-sync
  intellij-idea
  jetbrains-toolbox
  onedrive
  slack
  sts
  virtualbox
  virtualbox-extension-pac
  webstorm
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

prompt "Update ruby"
ruby -v
brew install gpg
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
ruby_version='2.6.0'
rvm install ${ruby_version}
rvm use ${ruby_version} --default
ruby -v
sudo gem update --system

prompt "Install Java"
brew tap caskroom/versions
brew cask install java8

prompt "Install packages"
brew info ${brews[@]}
install 'brew install' ${brews[@]}

prompt "Install software"
brew cask info ${casks[@]}
install 'brew cask install' ${casks[@]}

prompt "Upgrade bash"
brew install bash
sudo bash -c "echo $(brew --prefix)/bin/bash >> /private/etc/shells"
mv ~/.bash_profile ~/.bash_profile_backup
mv ~/.bashrc ~/.bashrc_backup
mv ~/.gitconfig ~/.gitconfig_backup
cd; curl -#L https://github.com/barryclark/bashstrap/tarball/master | tar -xzv --strip-components 1 --exclude={README.md,screenshot.png}
#source ~/.bash_profile



prompt "Update packages"
pip3 install --upgrade pip setuptools wheel

prompt "Cleanup"
brew cleanup
brew cask cleanup

echo "Done!"
