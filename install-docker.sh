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
  # Docker
  printf "${BLUE}Installing docker-engine; docker-machine and docker-compose...${NORMAL}\n"
  
  # Docker Engine
  printf "${BLUE}Installing docker-engine...${NORMAL}\n"
  curl -sSL https://get.docker.com/ | sh
  
  sudo usermod -aG docker $USER
  printf "${YELLOW}You must logout and login to use Docker without sudo... (use sudo docker... meanwhile)${NORMAL}\n"
    
  # Docker Compose i Machine
  printf "${BLUE}Installing docker-compose...${NORMAL}\n"
  curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose
  sudo mv /tmp/docker-compose /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  printf "${BLUE}Installing docker-machine...${NORMAL}\n"
  curl -L https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-`uname -s`-`uname -m` > /tmp/docker-machine 
  sudo mv /tmp/docker-machine /usr/local/bin/docker-machine 
  sudo chmod +x /usr/local/bin/docker-machine
}

# Check if reboot is needed
minimal
