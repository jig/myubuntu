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
  # kubectl
  printf "${BLUE}Installing kubectl...${NORMAL}\n"
  sudo apt-get -y install curl
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
  echo "source <(kubectl completion bash)" >> ~/.bashrc
  echo "source <(kubectl completion zsh)" >> ~/.zshrc  

  # helm
  printf "${BLUE}Installing helm...${NORMAL}\n"
  sudo snap install helm --classic

  # eksctl
  printf "${BLUE}Installing eksctl...${NORMAL}\n"
  curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
  sudo mv /tmp/eksctl /usr/local/bin

  # kind
  # this requires go
  printf "${BLUE}Installing kind (kubernetes in docker)...${NORMAL}\n"
  # We use the go command whis way, because if installed with another scripts,
  # it may not be in the PATH yet
  if ls $HOME/go/bin/go > /dev/null; then
    GO111MODULE="on" $HOME/go/bin/go get sigs.k8s.io/kind@v0.4.0
  else
    printf "${YELLOW}kind could not be installed because go command is not found${NORMAL}\n"
  fi
}

# Check if reboot is needed
install_kops
