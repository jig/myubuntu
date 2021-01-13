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

  [ "$GOLANG_VERSION" == "" ] && GOLANG_VERSION=1.15.6

  printf "${BLUE}Installing Go $GOLANG_VERSION...${NORMAL}\n"
  wget https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz -O /tmp/golang.tgz
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

  tools=" \
    github.com/stamblerre/gocode \
    github.com/uudashr/gopkgs/v2/cmd/gopkgs \
    github.com/ramya-rao-a/go-outline \
    github.com/newhook/go-symbols \
    golang.org/x/tools/cmd/gorename \
    github.com/go-delve/delve/cmd/dlv \
    github.com/zmb3/gogetdoc \
    golang.org/x/tools/gopls \
    golang.org/x/tools/cmd/goimports \
  "
  for tool in $tools; do
    printf "${BLUE}Installing $tool...${NORMAL}\n"
    GOFLAGS= GO111MODULE=on go get $tool@latest
  done

  cd $HOME
  printf "${BLUE}Installing golangci-lint...${NORMAL}\n"
  wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.23.7
}

golang
warning "WARN: Log out from the session to load Go binary"

