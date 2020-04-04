vsc() {
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
  # Visual Studio Code (Microsoft)
  printf "${BLUE}Installing Visual Studio Code (Microsoft)...${NORMAL}\n"
  sudo apt-get -y install git libgtk2.0-0 libgconf-2-4 libasound2 libnss3 libxtst6 gtk-chtheme light-themes 
  
  # get last version of Visual Studio Code:
  wget https://go.microsoft.com/fwlink/?LinkID=760868 -O /tmp/vscode-amd64.deb
  sudo dpkg -i /tmp/vscode-amd64.deb

  if [ ! -d ~/.config/Code/User ]; then
      mkdir -p ~/.config/Code/User
  fi

  if [ ! -e ~/.config/Code/User/settings.json ]; then
      cat > ~/.config/Code/User/settings.json <<EOF
{
    // Editor
    "editor.tabSize": 2,
    "editor.detectIndentation": false,
    "editor.formatOnSave": true,
    "editor.fontFamily": "'Fira Code'",
    "editor.fontLigatures": true,
    // Terminal
    "terminal.integrated.fontFamily": "Ubuntu Mono derivative Powerline",
    "terminal.integrated.fontSize": 17,
    // Go
    "go.lintOnSave": "workspace",
    "go.vetOnSave": "workspace",
    "go.buildTags": "",
    "go.buildFlags": [],
    "go.lintFlags": [],
    "go.vetFlags": [],
    "go.coverOnSave": false,
    "go.useCodeSnippetsOnFunctionSuggest": false,
    "go.formatTool": "goreturns",
    "go.goroot": "~/go",
    "go.gopath": "~/git",
    "go.toolsEnvVars": {
      "GO111MODULE": "on",
    },
    "go.gocodeAutoBuild": false,
    // Markdown
    "markdown-toc.insertAnchor": true,
    "markdown-toc.anchorMode": "bitbucket.org",
    "markdown-toc.depthFrom": 2,
    "markdown-toc.depthTo": 3,
    "markdownlint.config": {
      "default": true,
      "MD007": { "indent": 4 },
      "MD033": false,
      "MD036": false,
      "MD035": {
        "style": "---"
      }
    },
    "[markdown]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode",
      "editor.tabSize": 4,
      "editor.formatOnSave": false
    },
    // YAML
    "yaml.format.bracketSpacing": false,
    // Disable telemetry
    "gitlens.advanced.telemetry.enabled": false,
    "telemetry.enableCrashReporter": false,
    "telemetry.enableTelemetry": false
}
EOF
    fi

    if [ ! -e ~/.config/Code/User/launch.json ]; then
      cat > ~/.config/Code/User/launch.json <<EOF
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch",
            "type": "go",
            "request": "launch",
            "mode": "debug",
            "program": "${workspaceRoot}",
            "env": {},
            "args": []
        }
    ]
}
EOF
    fi

    printf "${YELLOW}Go plugin Visual Studio Code: install it with <Ctrl+Shift+P> and then 'ext install go'...${NORMAL}\n"
}

# Check if reboot is needed
vsc
