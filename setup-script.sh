#!/bin/sh

# Jon's New Mac Setup script
# curl -s https://raw.githubusercontent.com/jb510/mac-setup/master/setup-script.sh | bash -

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Reading is better with a Rainbow
fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

# future...  fanicer appened personal setting to .zshrc
append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  if [ -w "$HOME/.zshrc.local" ]; then
    zshrc="$HOME/.zshrc.local"
  else
    zshrc="$HOME/.zshrc"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\n" "$text" >> "$zshrc"
    else
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}

# shellcheck disable=SC2154
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if [ ! -d "$HOME/.bin/" ]; then
  mkdir "$HOME/.bin"
fi

if [ ! -f "$HOME/.zshrc" ]; then
  touch "$HOME/.zshrc"
fi

# shellcheck disable=SC2016
append_to_zshrc 'export PATH="$HOME/.bin:$PATH"'

HOMEBREW_PREFIX="/usr/local"

if [ -d "$HOMEBREW_PREFIX" ]; then
  if ! [ -r "$HOMEBREW_PREFIX" ]; then
    sudo chown -R "$LOGNAME:admin" /usr/local
  fi
else
  sudo mkdir "$HOMEBREW_PREFIX"
  sudo chflags norestricted "$HOMEBREW_PREFIX"
  sudo chown -R "$LOGNAME:admin" "$HOMEBREW_PREFIX"
fi

update_shell() {
  local shell_path;
  shell_path="$(which zsh)"

  fancy_echo "Changing your shell to zsh ..."
  if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
    fancy_echo "Adding '$shell_path' to /etc/shells"
    sudo sh -c "echo $shell_path >> /etc/shells"
  fi
  sudo chsh -s "$shell_path" "$USER"
}

case "$SHELL" in
  */zsh)
    if [ "$(which zsh)" != '/usr/local/bin/zsh' ] ; then
      update_shell
    fi
    ;;
  *)
    update_shell
    ;;
esac

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    gem update "$@"
  else
    gem install "$@"
  fi
}

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

    append_to_zshrc '# recommended by brew doctor'

    # shellcheck disable=SC2016
    append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1

    export PATH="/usr/local/bin:$PATH"
fi

if brew list | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

fancy_echo "Updating Homebrew formulae ..."
brew update --force # https://github.com/Homebrew/brew/issues/1151
brew bundle --file=- <<EOF
tap "homebrew/services"
tap "universal-ctags/universal-ctags"
tap "caskroom/cask"

# My Formulae
tap "homebrew/bundle"
tap "homebrew/core"
tap "homebrew/php"
tap "homebrew/services"
brew "handbrake"
brew "htop"
brew "httpie"
brew "imagemagick"
brew "node"
brew "npm"
brew "nativefier"
brew "python"
brew "speedtest-cli"
cask "osxfuse"
brew "sshfs"
brew "subversion"
brew "homebrew/php/composer"

#Mac App Store
brew "mas"
#mas 'Airmail 3', id: 918858936
mas 'Annotate', id: 918207447
mas 'Better Rename 9', id: 414209656
mas 'CodeBox', id: 412536790
mas 'EasyFind', id: 411673888
mas 'Evernote', id: 406056744
mas 'Fantastical 2', id: 975937182
#mas 'Fusion360', id: 868968810
#mas 'GarageBand', id: 682658836
mas 'GIF Brewery 3', id: 1081413713
mas 'iBooks Author', id: 490152466
mas 'iMovie', id: 408981434
mas 'IP Scanner', id: 404167149
mas 'Keynote', id: 409183694
mas 'LogTail', id: 1073404370
mas 'Numbers', id: 409203825
mas 'PageLayers', id: 437835477
mas 'Pages', id: 409201541
mas 'Permute', id: 731738567
mas 'QuickBooks', id: 640830064
mas 'Simplenote', id: 692867256
mas 'SiteSucker', id: 442168834
mas 'Slack', id: 803453959
#mas 'Spark', id: 1176895641
mas 'Tweetbot', id: 557168941
#mas 'Xcode', id: 497799835


# My Casks
cask "1password"
cask "alfred"
cask alfred link
cask "blisk"
cask "cloudup"
cask "dash"
cask "dropbox"
cask "encryptme"
cask "google-drive-file-stream"
cask "moom"
cask "postbox"
cask "transmit"
cask "tower"
cask "java"
cask "iterm2"
cask "keybase"
cask "vagrant"
cask "virtualbox"
cask "local-by-flywheel"
cask "vlc"
cask "google-chrome"
cask "firefox"
cask "firefox-developer-edition"
cask "skype"
cask "spotify"
cask "spotifree"

# Unix
#brew "universal-ctags", args: ["HEAD"]
brew "openssl"
brew "git"
brew "lftp"
brew "mosh"
tap "mistertea/et"
brew "mtr"
brew "the_silver_searcher"
brew "mistertea/et/et"
brew "tmux"
brew "wget"
brew "zsh"
brew "zsh-completions"
brew "zsh-syntax-highlighting"
brew "z"

# GitHub
#brew "hub"

# Image manipulation
brew "imagemagick"

# Programming language prerequisites and package managers
brew "libyaml" # should come after openssl
brew "coreutils"
cask "gpg-suite"
#Brew Install EOF
EOF

fancy_echo "Installing oh-zsh-shell..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi
