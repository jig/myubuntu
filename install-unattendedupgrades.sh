unattended-upgrades() {
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
 
  printf "${BLUE}Installing unattended-upgrades package...${NORMAL}\n"
  # Install unattended-upgrades package
  sudo apt-get install -y unattended-upgrades

  # Change apt configuration to allow updates and to send emails if any error is encountered
  sudo sed -i 's#^//[ \t]"${distro_id}:${distro_codename}-updates";#"${distro_id}:${distro_codename}-updates";#g' /etc/apt/apt.conf.d/50unattended-upgrades
  sudo sed -i 's#^//Unattended-Upgrade::Mail "root";#Unattended-Upgrade::Mail "adria.alcaraz@entrustdatacard.com";#g' /etc/apt/apt.conf.d/50unattended-upgrades
  sudo sed -i 's#^//Unattended-Upgrade::MailOnlyOnError "true";#Unattended-Upgrade::MailOnlyOnError "true";#g' /etc/apt/apt.conf.d/50unattended-upgrades

  # Enable unattended upgrades 
  sudo bash -c "echo 'APT::Periodic::Download-Upgradeable-Packages "1";' >> /etc/apt/apt.conf.d/20auto-upgrades"
  sudo bash -c "echo 'APT::Periodic::AutocleanInterval "7";' >> /etc/apt/apt.conf.d/20auto-upgrades"
 
  # Test the package
  sudo unattended-upgrades --dry-run --debug
}

# Check if reboot is needed
unattended-upgrades