emacsinstall() {
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
 
  printf "${BLUE}Installing Emacs...${NORMAL}\n"
  sudo apt-get -y install \
    emacs-nox \
    subversion
  
  printf "${BLUE}Configuring Emacs...${NORMAL}\n"
  svn checkout https://github.com/jig/myubuntu/trunk/emacs.d .emacs.d
}

# Check if reboot is needed
emacsinstall
