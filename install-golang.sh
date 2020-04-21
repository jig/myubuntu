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

  VERSION=1.14.2

  printf "${BLUE}Installing Go...${NORMAL}\n"
  wget https://storage.googleapis.com/golang/go$VERSION.linux-amd64.tar.gz -O /tmp/golang.tgz
  rm -rf $HOME/go
  tar -C $HOME -xzf /tmp/golang.tgz 

  if [ -e $HOME/.bashrc ]; then
    grep -qxF 'export GOPATH=$HOME/git' $HOME/.bashrc || echo 'export GOPATH=$HOME/git'>> $HOME/.bashrc
    grep -qxF 'export GOROOT=$HOME/go' $HOME/.bashrc || echo 'export GOROOT=$HOME/go'>> $HOME/.bashrc
    grep -qxF 'export PATH=$PATH:$GOPATH/bin:$GOROOT/bin' $HOME/.bashrc \
    || echo 'export PATH=$PATH:$GOPATH/bin:$GOROOT/bin'>> $HOME/.bashrc
  fi

  if [ -e $HOME/.zshrc ]; then
    grep -qxF 'export GOPATH=$HOME/git' $HOME/.zshrc || echo 'export GOPATH=$HOME/git'>> $HOME/.zshrc
    grep -qxF 'export GOROOT=$HOME/go' $HOME/.zshrc || echo 'export GOROOT=$HOME/go'>> $HOME/.zshrc
    grep -qxF 'export PATH=$PATH:$GOPATH/bin:$GOROOT/bin' $HOME/.zshrc \
    || echo 'export PATH=$PATH:$GOPATH/bin:$GOROOT/bin'>> $HOME/.zshrc
  fi

  export GOPATH=$HOME/git
  export GOROOT=$HOME/go
  export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

  # Disable the use of the Google Golang Proxy and Google Database Checksum
  go env -w GOPROXY=direct
  go env -w GOSUMDB=off

  # Install Delve Debugger
  printf "${BLUE}Installing Delve Debugger...${NORMAL}\n"
  # delve GO111MODULE=off: https://github.com/go-delve/delve/issues/1991#issuecomment-609706835
  GO111MODULE=off go get -u github.com/go-delve/delve/cmd/dlv

  # Install debugging, testing, linting tools
  printf "${BLUE}Installing some Go tools...${NORMAL}\n"
  go get -u sourcegraph.com/sqs/goreturns
  cd $HOME
  wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.23.7
}

golang
warning "WARN: Log out from the session to load Go binary"

