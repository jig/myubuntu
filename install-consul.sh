install_consul() {
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

  SUDO=''
  if (( $EUID != 0 )); then
      SUDO='sudo'
  fi

  printf "${BLUE}Installing consul...${NORMAL}\n"
  # Install consul
  wget https://releases.hashicorp.com/consul/1.7.3/consul_1.7.3_linux_amd64.zip -O /tmp/consul.zip
  unzip -d /tmp /tmp/consul.zip
  $SUDO mv /tmp/consul /usr/bin

  # Test the installation
  consul version
}

install_consul
