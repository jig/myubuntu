install_istio() {
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
 
  ###################################
  # istio
  printf "${BLUE}Installing istio...${NORMAL}\n"
  curl -sL https://istio.io/downloadIstio | ISTIO_VERSION=1.9.1 sh -
  cd istio-1.9.1
  $SUDO mv bin/istioctl /usr/local/bin/istioctl
}

# Check if reboot is needed
install_istio
