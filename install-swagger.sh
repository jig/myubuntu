install_swagger() {
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

  set -e

  printf "${BLUE}Installing Pandoc...${NORMAL}\n"

  sudo apt-get update 
  sudo apt install jq pandoc -y

  printf "${BLUE}Installing Swagger...${NORMAL}\n"

  VERSION=v0.21.0

  export download_url=$(curl -s https://api.github.com/repos/go-swagger/go-swagger/releases/tags/${VERSION} | jq -r '.assets[] | select(.name | contains("'"$(uname | tr '[:upper:]' '[:lower:]')"'_amd64")) | .browser_download_url')
  sudo curl -o /usr/local/bin/swagger -L'#' "$download_url"
  sudo chmod +x /usr/local/bin/swagger 

  swagger version
}

install_swagger
