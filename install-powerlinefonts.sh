powerline() {
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
  
  # Powerline
  printf "${BLUE}Installing Powerline fonts...${NORMAL}\n"
  mkdir -p ~/git/src/github.com/powerline
  cd ~/git/src/github.com/powerline
  if [ ! -d fonts ]; then
      git clone https://github.com/powerline/fonts.git
      cd fonts
      ./install.sh
  fi

  # botó dret, i selecciona un font adaptat a Powerline
  # per exemple: Liberation Mono for Powerline
}

# Check if reboot is needed
powerline
