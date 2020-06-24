awscli() {
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

  printf "${BLUE}Installing AWS CLI...${NORMAL}\n"
  sudo apt-get -y install unzip python
  curl -JL "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" > /tmp/awscli-bundle.zip
  unzip /tmp/awscli-bundle.zip -d /tmp
  sudo /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
  printf "${GREEN}"
  /usr/local/bin/aws --version
  printf "${NORMAL}\n"
}

awscli
