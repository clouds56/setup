#!/bin/sh

# change shell
chsh -s /bin/zsh clouds

# install xcode and homebrew
sudo xcodebuild -license
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install wget and zshrc
brew install wget
wget -O .zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

# setup git (manually setup username and email)
git config --global alias.st "status -s"
git config --global alias.lg "log --oneline --all --graph --decorate"

# install shadowsocks
brew install shadowsocks-libev
vim /usr/local/etc/shadowsocks-libev.json
ln -s /usr/local/opt/shadowsocks-libev/homebrew.mxcl.shadowsocks-libev.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.shadowsocks-libev.plist
# https://github.com/shadowsocks/shadowsocks/wiki/Using-Shadowsocks-with-Command-Line-Tools
mkdir ~/.proxychains && cp proxychains.conf ~/.proxychains

# install python3
brew install python3
pip3 install jupyter
pip3 install numpy

brew install freetype
pip3 install matplotlib

brew install gcc
pip3 install scipy

brew install libtiff libjpeg webp little-cms2
brew install homebrew/dupes/zlib
brew link zlib --force
pip3 install pillow
