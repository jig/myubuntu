install_sshconfig() {
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

  printf "${BLUE}Updating SSH config...${NORMAL}\n"

  # Update SSH configuration to persist SSH connections (avoid ssh_exchange_identification errors)
  if [ -e $HOME/.ssh/config ]; then
    grep -qxF 'ServerAliveInterval 60' $HOME/.ssh/config || echo 'ServerAliveInterval 60'>> $HOME/.ssh/config
    grep -qxF 'ServerAliveCountMax 3' $HOME/.ssh/config || echo 'ServerAliveCountMax 3'>> $HOME/.ssh/config
    grep -qxF 'TCPKeepAlive yes' $HOME/.ssh/config || echo 'TCPKeepAlive yes'>> $HOME/.ssh/config
    grep -qxF 'ControlMaster auto' $HOME/.ssh/config || echo 'ControlMaster auto'>> $HOME/.ssh/config
    grep -qxF 'ControlPath ~/.ssh/%C' $HOME/.ssh/config || echo 'ControlPath ~/.ssh/%C'>> $HOME/.ssh/config
    grep -qxF 'ControlPersist 600' $HOME/.ssh/config || echo 'ControlPersist 600'>> $HOME/.ssh/config
  fi
}

install_sshconfig