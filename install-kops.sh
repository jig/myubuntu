install_kops() {
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
  # kubectl & kops
  printf "${BLUE}Installing kubectl and kops...${NORMAL}\n"
  sudo apt-get -y install curl
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
  echo "source <(kubectl completion bash)" >> ~/.bashrc
  echo "source <(kubectl completion zsh)" >> ~/.zshrc  
  
  curl -LO https://github.com/kubernetes/kops/releases/download/1.7.0/kops-linux-amd64
  chmod +x ./kops-linux-amd64
  sudo mv ./kops-linux-amd64 /usr/local/bin/kops

  # helm
  printf "${BLUE}Installing helm...${NORMAL}\n"
  sudo snap install helm --classic

  # kind
  printf "${BLUE}Installing kind (kubernetes in docker)...${NORMAL}\n"
  cd /tmp
  GO111MODULE="on" go get sigs.k8s.io/kind@v0.4.0
}

# Check if reboot is needed
install_kops
