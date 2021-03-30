install_kubernetes() {
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
 
  ###################################
  # kubectl
  printf "${BLUE}Installing kubectl...${NORMAL}\n"
  if [ -x /usr/bin/apt-get ]; then 
    $SUDO apt-get -y install curl
  fi
  if [ -x /usr/bin/yum ]; then 
    $SUDO yum -y install curl
  fi
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  $SUDO mv ./kubectl /usr/local/bin/kubectl
  if [ -e $HOME/.bashrc ]; then
    grep -qxF "source <(kubectl completion bash)" $HOME/.bashrc || echo "source <(kubectl completion bash)" >> $HOME/.bashrc
  fi
  if [ -e $HOME/.zshrc ]; then
    grep -qxF "source <(kubectl completion zsh)" $HOME/.zshrc || echo "source <(kubectl completion zsh)" >> $HOME/.zshrc
  fi

  # helm
  printf "${BLUE}Installing helm...${NORMAL}\n"
  wget https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz -O /tmp/helm.tar.gz
  tar -zxf /tmp/helm.tar.gz -C /tmp
  $SUDO mv /tmp/linux-amd64/helm /usr/local/bin/helm
  $SUDO chmod +x /usr/local/bin/helm

  # eksctl
  printf "${BLUE}Installing eksctl...${NORMAL}\n"
  curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
  $SUDO mv /tmp/eksctl /usr/local/bin

  # kind
  # This requires go and docker
  printf "${BLUE}Installing kind (kubernetes in docker)...${NORMAL}\n"
  if [ -z "$GOPATH" ]; then
    curl -Lo kind "https://kind.sigs.k8s.io/dl/v0.10.0/kind-$(uname)-amd64"
    chmod +x ./kind
    $SUDO mv ./kind /usr/local/bin/kind
  else
    curl -Lo kind "https://kind.sigs.k8s.io/dl/v0.10.0/kind-$(uname)-amd64"
    chmod +x ./kind
    $SUDO mv ./kind $GOPATH/bin/kind
  fi
}

# Check if reboot is needed
install_kubernetes
