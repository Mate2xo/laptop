fancy_echo "Updating system packages ..."
  update_system

fancy_echo "Installing zsh ..."
  successfully sudo aptitude install -y zsh

fancy_echo "Changing your shell to zsh ..."
  successfully chsh -s `which zsh`

fancy_echo "Installing curl for transferring data with URL syntax ..."
  install_pkg curl # Comes in Arch base already

fancy_echo "Installing xclip for clipboard integration with your terminal ..."
  install_pkg xclip

fancy_echo "Installing git, for source control management ..."
  install_pkg git

fancy_echo "Installing base ruby build dependencies ..."
  successfully sudo aptitude build-dep -y ruby1.9.3 # Not needed on Arch

fancy_echo "Installing libraries for common gem dependencies ..."
  install_pkg libxslt1-dev libcurl4-openssl-dev libksba8 libksba-dev libqtwebkit-dev # Not all needed on Arch

fancy_echo "Installing Postgres, a good open source relational database ..."
  install_pkg postgresql postgresql-server-dev-all # Arch is just "postgresql"

fancy_echo "Installing Redis, a good key-value database ..."
  install_pkg redis-server # Arch is just "redis"

fancy_echo "Installing The Silver Searcher (better than ack or grep) for searching the contents of files ..."
  # Arch has an AUR package for this
  successfully git clone git://github.com/ggreer/the_silver_searcher.git /tmp/the_silver_searcher
  install_pkg automake pkg-config libpcre3-dev zlib1g-dev
  successfully sh /tmp/the_silver_searcher/build.sh
  successfully cd /tmp/the_silver_searcher
  successfully sh build.sh
  successfully sudo make install
  successfully cd ~
  successfully rm -rf /tmp/the_silver_searcher

fancy_echo "Installing ctags, for indexing files for vim tab completion of methods, classes, variables ..."
  install_pkg exuberant-ctags

fancy_echo "Installing vim ..."
  install_pkg vim-gtk # Arch calls this gvim?

fancy_echo "Installing tmux, for saving project state and switching between projects ..."
  install_pkg tmux # I want screen :(

fancy_echo "Installing ImageMagick, for cropping and re-sizing images ..."
  install_pkg imagemagick

fancy_echo "Installing watch, used to execute a program periodically and show the output ..."
  install_pkg watch

fancy_echo "Installing rbenv for changing Ruby versions ..."
  # Arch has an AUR package for this -- also, I want chruby :(
  successfully git clone git://github.com/sstephenson/rbenv.git ~/.rbenv

  if ! grep -qs "rbenv init" ~/.zshrc; then
    successfully echo 'export PATH="$HOME/bin:$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
    successfully echo 'eval "$(rbenv init -)"' >> ~/.zshrc
  fi

  export PATH="$HOME/bin:$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"

fancy_echo "Installing rbenv-gem-rehash so the shell automatically picks up binaries after installing gems with binaries..."
  # Arch has an AUR package for this
  successfully git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash

fancy_echo "Installing ruby-build for installing Rubies ..."
  # Arch has an AUR package for this
  successfully git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

fancy_echo "Installing Ruby 1.9.3-p392 ..."
  successfully rbenv install 1.9.3-p392

fancy_echo "Setting Ruby 1.9.3-p392 as global default Ruby ..."
  successfully rbenv global 1.9.3-p392
  successfully rbenv shell 1.9.3-p392

fancy_echo "Update to latest Rubygems version ..."
  successfully gem update --system

fancy_echo "Installing critical Ruby gems for Rails development ..."
  successfully gem install bundler foreman pg rails thin --no-document

fancy_echo "Installing GitHub CLI client ..."
  successfully gem install hub --no-document

fancy_echo "Installing Heroku CLI client ..."
  # Arch has an AUR package for this
  successfully wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

fancy_echo "Installing the heroku-config plugin for pulling config variables locally to be used as ENV variables ..."
  successfully heroku plugins:install git://github.com/ddollar/heroku-config.git

if ! grep -qs "DO NOT EDIT BELOW THIS LINE" ~/.zshrc; then
  fancy_echo "Prepare ~/.zshrc for http://github.com/thoughtbot/dotfiles ..."
  successfully echo "# DO NOT EDIT BELOW THIS LINE\n" >> ~/.zshrc
fi

fancy_echo "Your shell will now restart to apply changes."
  exec `which zsh` -l