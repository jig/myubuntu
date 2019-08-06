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
  printf "${BLUE}Installing docker-engine, docker-machine and docker-compose...${NORMAL}\n"
  
  # Docker Engine
  printf "${BLUE}Installing docker-engine...${NORMAL}\n"
  curl -sSL https://get.docker.com/ | sh
  
  sudo usermod -aG docker $USER
  printf "${YELLOW}You must logout and login to use Docker without sudo... (use sudo docker... meanwhile)${NORMAL}\n"
    
  # Docker Compose i Machine
  printf "${BLUE}Installing docker-compose...${NORMAL}\n"
  sudo curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  
  printf "${BLUE}Installing docker-machine...${NORMAL}\n"
  curl -L https://github.com/docker/machine/releases/download/latest/docker-machine-`uname -s`-`uname -m` > /tmp/docker-machine 
  sudo mv /tmp/docker-machine /usr/local/bin/docker-machine 
  sudo chmod +x /usr/local/bin/docker-machine

  # Docker credentials
  printf "${BLUE}Installing docker-credential-secretservice...${NORMAL}\n"
  curl -L https://github.com/docker/docker-credential-helpers/releases/download/v0.6.0/docker-credential-secretservice-v0.6.0-amd64.tar.gz > /tmp/docker-credential-secretservice.tar.gz
  tar -xvf /tmp/docker-credential-secretservice.tar.gz
  sudo mv docker-credential-secretservice /usr/local/bin/docker-credential-secretservice
  sudo chmod +x /usr/local/bin/docker-credential-secretservice
  
  # Configure docker to use docker-credential-secretservice (gnome keyring)
  printf "${BLUE}${BOLD}In order to configure docker-credential-secretservice add the following line on ~/.docker/config.json: ${NORMAL}\n"
  printf "${YELLOW}{\n\t\"credsStore\": \"secretservice\"\n\t...\n}${NORMAL}\n"
  # When docker-credential-secretservice support docker-compose pull this can be uncommented -v
  # grep -q -G 'credsStore' ~/.docker/config.json && sed -i '/credsStore/c\"credsStore": "secretservice",' ~/.docker/config.json || sed -i '2i"credsStore": "secretservice",' ~/.docker/config.json
}

# Check if reboot is needed
minimal
