# myubuntu

Sets up my Ubuntu Desktop System (works both on 18.04 LTS and 20.04 LTS)

To execute it, you must login with your username (must be sudoer) to a **clean** Ubuntu Desktop installation.

### Full Installation

First, log in with your username (`sudo` will be used internally so expect to be requested your password once. You can avoid it, by using `sudo ls` before executing the commands below).

Do not execute this scripts as `root` or with `sudo`.

This Ubuntu config is installed by running one of the following commands in your terminal as the main user of this desktop. 
You can install this via the command-line with `wget`. 

```shell
bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/master/install-all.sh -O -)"
```

Note: Powerline fonts are not enabled by the script above (only installed). To use them right-click on the terminal and choose
any of the fonts that contain *Powerline*.

### Partial Installation

You can install just one item just invoking one of the `install-?.sh` scripts; for instance:

```shell
bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/master/install-awscli.sh -O -)"
```

# VMware

If you are installing Ubuntu 18.04 LTS on a virtual machine (VMware) it is recomeded to install Virtual Machine drivers (they are not installed by script above)

```shell
bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/master/install-vmguest.sh -O -)"
```

On Ubuntu 20.04 LTS you must skip this step as the support is already installed on the Desktop base distribution.

# Hyper-V

This script has been tested with Ubuntu 18.04.3 LTS Desktop on Microsoft Hyper-V.

## note

`install.sh` script (was) based on [robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
