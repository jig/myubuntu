minimal() {
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
  printf "${BLUE}Installing BZIP2...${NORMAL}\n"
  sudo apt-get install bzip2
  printf "${BLUE}Installing LiteIDE for Go language...${NORMAL}\n"

  wget http://downloads.sourceforge.net/project/liteide/X29/liteidex29.linux-64-qt4.tar.bz2 -O /tmp/liteide.tar.bz2
  bzip2 -d /tmp/liteide.tar.bz2
  tar -C ~ -xf /tmp/liteide.tar
}

# Check if reboot is needed
minimal
