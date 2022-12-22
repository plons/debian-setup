# Debian setup

- [Debian setup](#debian-setup)
  - [Backup](#backup)
  - [Installation](#installation)
  - [Setup](#setup)
    - [Configure sudo rights](#configure-sudo-rights)
    - [Install documents and scripts](#install-documents-and-scripts)
    - [Run install script](#run-install-script)
    - [Third party software](#third-party-software)
    - [Configure git](#configure-git)
    - [Restore configurations](#restore-configurations)
    - [Gnome 3 tweaks](#gnome-3-tweaks)
    - [Development environment](#development-environment)

Setup of scripts and personal preferences for debian

## Backup

Backup the home directory, excluding locally installed programs.

## Installation

Create bootable usb

- Download iso using [jigdo](https://cdimage.debian.org/debian-cd/current/amd64/jigdo-cd/)
- Create iso: `jigdo-lite <YOUR_DOWNLOADED_FILE>.jigdo`
- Flash image to usb using [etcher](https://www.balena.io/etcher)

Solve driver problems:

- <https://wiki.debian.org/NvidiaGraphicsDrivers>
- <https://wiki.debian.org/ATIProprietary>
- <https://wiki.debian.org/iwlwifi>

Make sure to install [dkms](https://linux.die.net/man/8/dkms) so proprietary drivers are rebuild after a kernel update.

## Setup

### Configure sudo rights

```/bin/bash
su
apt-get install aptitude sudo
```

Edit /etc/sudoers:

```/bin/bash
peter   ALL=NOPASSWD: /usr/bin/apt-get , /usr/bin/apt
```

or

```/bin/bash
peter   ALL=NOPASSWD: ALL
```

### Install documents and scripts

- (deprecated) install [dropbox](https://www.dropbox.com)
- install [onedrive](https://github.com/abraunegg/onedrive)
  - Specify sync list (~/.config/onedrive/sync_list)

   ```txt
   Debian
   Work
   wiki
   ```

### Run install script

- clone the repository to your home directory (example ~/dotfiles/)
- run the *install.sh - script
- run the *install_packages.sh - script

### Third party software

- ~~[atom](https://atom.io/)~~
- [Visual Studio Code](https://code.visualstudio.com/)
- [teamviewer](https://www.teamviewer.com/en/download/linux/)
- [beyondcompare](https://www.scootersoftware.com/download.php)
- [eclipse](https://www.eclipse.org/downloads/)
- [pycharm](https://www.jetbrains.com/pycharm/download/)
- [webex](https://www.webex.com/downloads.html)

### Configure git

```bash
git config --global core.editor vi

git config --global diff.tool bc
git config --global difftool.prompt false
git config --global difftool.bc trustExitCode true

git config --global merge.tool bc
git config --global mergetool.bc trustExitCode true

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

### Restore configurations

- ssh configuration (copy previous ssh id)
- dotvim
- desktop items
  - Copy previous items from ~/.local/share/applications/ (eclipse and pycharm)
  - Create using alacarte
- reset bookmarks
- firefox plugins (lastpass, foxy-proxy)
  - Can be done using firefox account

### Gnome 3 tweaks

Suggested tweaks

```bash
gsettings set org.gnome.shell.overrides workspaces-only-on-primary false
gsettings set org.gnome.desktop.background show-desktop-icons true
gsettings set org.gnome.shell.app-switcher current-workspace-only true
```

Shell Extensions

`sudo apt-get install gnome-shell-extensions`

| Suggested extension | description |
| ------------------- | ----------- |
| <https://extensions.gnome.org/local/> | Here you find an overview of your installed shell extensions (this overview is also available in gnome-tweak-tool) |
| <https://extensions.gnome.org/extension/120/system-monitor/>   | system monitor always visible in status bar (follow the instructions!) |
| <https://extensions.gnome.org/extension/310/alt-tab-workspace/> | alt-tab switches between windows in current workspace (not all workspaces) |
| <https://extensions.gnome.org/extension/39/put-windows/>  | Easy placement of windows in corners of the screen. |
| <https://extensions.gnome.org/extension/8/places-status-indicator/> | Fast access to favorite places |
| settingscenter | Fast acces to all kind of settingssettings |

### Development environment

- clone our git repositories
- schroot setup for wheezy
