debian-setup
============

Setup of scripts and personal preferences for debian

## Debian installation

Create bootable usb
* Download iso using [jigdo](https://cdimage.debian.org/debian-cd/current/amd64/jigdo-cd/)
* Create iso: `jigdo-lite <YOUR_DOWNLOADED_FILE>.jigdo`
* Flash image to usb using [etcher](https://www.balena.io/etcher)

Solve driver problems:
* https://wiki.debian.org/NvidiaGraphicsDrivers
* https://wiki.debian.org/ATIProprietary
* https://wiki.debian.org/iwlwifi

## Bootstrap
Configure sudo rights:
```
su
apt-get install aptitude sudo
```

Edit /etc/sudoers:
```
peter	ALL=NOPASSWD: /usr/bin/apt-get , /usr/bin/aptitude
```
or
```
peter   ALL=NOPASSWD: ALL
```

install [dropbox](https://www.dropbox.com)
install [onedrive](https://github.com/skilion/onedrive)

## Customize
* clone the repository to your home directory (example ~/dotfiles/)
* run the *install.sh* script
* run the *install_packages.sh* script

### Third party software
* [ atom          ](https://atom.io/)
* [ teamviewer    ](https://www.teamviewer.com/en/download/linux/)
* [ beyondcompare ](https://www.scootersoftware.com/download.php)
* [ eclipse       ](https://www.eclipse.org/downloads/)
* [ pycharm       ](https://www.jetbrains.com/pycharm/download/)

### Configurations
* ssh configuration (copy previous ssh id)
* dotvim
* desktop items
  - Copy previous items from ~/.local/share/applications/ (eclipse and pycharm)
  - Create using alacarte
* reset bookmarks
* firefox plugins (lastpass, foxy-proxy)
  - Can be done using firefox account

### Gnome 3

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
| https://extensions.gnome.org/local/ | Here you find an overview of your installed shell extensions (this overview is also available in gnome-tweak-tool) |
| https://extensions.gnome.org/extension/120/system-monitor/   | system monitor always visible in status bar (follow the instructions!) |
| https://extensions.gnome.org/extension/310/alt-tab-workspace/ | alt-tab switches between windows in current workspace (not all workspaces) |
| https://extensions.gnome.org/extension/39/put-windows/  | Easy placement of windows in corners of the screen. |
| https://extensions.gnome.org/extension/8/places-status-indicator/ | Fast access to favorite places |
| settingscenter | Fast acces to all kind of settingssettings |

### Development
* clone our git repositories
* schroot setup for wheezy
