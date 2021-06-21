install_vault() {
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

  printf "${BLUE}Installing Vault...${NORMAL}\n"
  # Install Vault
  wget https://releases.hashicorp.com/vault/1.7.3/vault_1.7.3_linux_amd64.zip -O /tmp/vault.zip
  unzip -d /tmp /tmp/vault.zip
  $SUDO mv /tmp/vault /usr/bin

  # Test the installation
  vault version
}

install_vault
