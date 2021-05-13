#!/bin/bash

install_swagger_nosudo() {
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

  set -e

  SUDO=''
  if (( $EUID != 0 )); then
      SUDO='sudo'
  fi

  printf "${BLUE}Installing Pandoc...${NORMAL}\n"

  $SUDO apt-get update 
  $SUDO apt install jq pandoc -y

  [ "$SWAGGER_VERSION" == "" ] && SWAGGER_VERSION="v0.27.0"
  printf "${BLUE}Installing go-swagger ${SWAGGER_VERSION}...${NORMAL}\n"

  export download_url=$(curl -s https://api.github.com/repos/go-swagger/go-swagger/releases/tags/${SWAGGER_VERSION} | jq -r '.assets[] | select(.name | contains("'"$(uname | tr '[:upper:]' '[:lower:]')"'_amd64")) | .browser_download_url')
  curl -o /tmp/swagger -L'#' "$download_url"
  $SUDO mv /tmp/swagger /usr/local/bin/swagger
  chmod +x /usr/local/bin/swagger 

  swagger version
}

install_swagger_nosudo
