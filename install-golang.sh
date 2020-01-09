warning() {
    printf "\033[0;33m$@\033[0m\n"
}

golang() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e
 
  ###################################
  # Golang

  VERSION=1.13.5

  printf "${BLUE}Installing Go...${NORMAL}\n"
  wget https://storage.googleapis.com/golang/go$VERSION.linux-amd64.tar.gz -O /tmp/golang.tgz
  tar -C $HOME -xzf /tmp/golang.tgz 

  if [ -e ~/.bashrc ]; then
    grep -qxF 'export GOPATH=$HOME/git' .bashrc || echo 'export GOPATH=$HOME/git'>> .bashrc
    grep -qxF 'export GOROOT=\$HOME/go' .bashrc || echo 'export GOROOT=\$HOME/go'>> .bashrc
    grep -qxF 'export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin' .bashrc \
    || echo 'export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin'>> .bashrc
  fi

  if [ -e $HOME/.zshrc ]; then
    grep -qxF 'export GOPATH=$HOME/git' .zshrc || echo 'export GOPATH=$HOME/git'>> .zshrc
    grep -qxF 'export GOROOT=\$HOME/go' .zshrc || echo 'export GOROOT=\$HOME/go'>> .zshrc
    grep -qxF 'export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin' .zshrc \
    || echo 'export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin'>> .zshrc
  fi

  export GOPATH=$HOME/git
  export GOROOT=$HOME/go
  export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

  # Disable the use of the Google Golang Proxy and Google Database Checksum
  go env -w GOPROXY=direct
  go env -w GOSUMDB=off
}

golang
warning "WARN: Log out from the session to load Go binary"

