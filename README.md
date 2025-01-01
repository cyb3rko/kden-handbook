⚠️ Switched to [Fedora KDE](https://github.com/cyb3rko/fedokde-handbook)

# KDE Neon Handbook

System info: (KDE Neon + Plasma Wayland)

---

- [Resource Management](#resource-management)
  - [Large file and folder monitor](#large-file-and-folder-monitor)
  - [Find large files](#find-large-files)
  - [AutoTrash](#autotrash)
  - [journalctl](#journalctl)
- [Packages](#packages)
  - [Flatpak dark mode applications](#flatpak-dark-mode-applications)
  - [Packages Cleanup](#packages-cleanup)
  - [Replace legacy keyrings](#replace-legacy-keyrings)
  - [Remove Plasma Welcome](#remove-plasma-welcome)
  - [Remove Bluetooth](#remove-bluetooth)
  - [Remove KWallet](#remove-kwallet)
  - [Remove KDE Connect](#remove-kde-connect)
  - [Remove all pip packages](#remove-all-pip-packages)
- [Nvidia Graphics](#nvidia-graphics)
- [SSL Inspection](#ssl-inspection)
  - [Add root CA to java](#add-root-ca-to-java)
- [Applications](#applications)
  - [Firefox](#firefox)
  - [OneDrive](#onedrive)
  - [Timeshift](#timeshift)
  - [yt-dlp](#yt-dlp)
  - [Wireshark](#wireshark)
- [Other Tools](#other-tools)
  - [JAVA_HOME](#java_home)
  - [Exiftool](#exiftool)

---

## Resource Management

### Large file and folder monitor

Use the CLI tool ncdu for a simple overview of the largest files and folders.

```shell
ncdu
```

### Find large files

Find files in current directory with a specified minimum size (in this example 100 MB)

```shell
find . -type f -size +100M
```

### Autotrash

To automatically clear older files in the trash, run the following (example: files older than 40 days):

```shell
sudo apt-get install pipx
pipx install autotrash
```

```shell
autotrash -d 40 --install
```

### journalctl

See space used by system logs:

```shell
journalctl --disk-usage
```

Set maximum log retention time in `/etc/systemd/journald.conf`

```
MaxRetentionSec=2months
```

## Packages

### Flatpak dark mode applications

To enable the Breeze Dark theme for Flatpak applications, change the setting in the following files:

`~/.config/gtk-3.0/settings.ini` + `~/.config/gtk-4.0/settings.ini`
```
...
gtk-theme-name=Breeze-Dark
...
```

### Packages Cleanup

To automatically remove unused packages and applications:

```shell
sudo apt-get autoremove && sudo apt-get autoclean && flatpak uninstall --unused
```

### Replace Legacy Keyrings

```shell
for KEY in $( \
    apt-key --keyring /etc/apt/trusted.gpg list \
    | grep -E "(([ ]{1,2}(([0-9A-F]{4}))){10})" \
    | tr -d " " \
    | grep -E "([0-9A-F]){8}\b" \
); do
    K=${KEY:(-8)}
    apt-key export $K \
    | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/imported-from-trusted-gpg-$K.gpg
done
```

Source: https://askubuntu.com/a/1415702

### Remove Plasma Welcome

```shell
sudo apt-get purge --autoremove plasma-welcome
```

### Remove Bluetooth

```shell
sudo apt-get purge --autoremove bluez
```

### Remove KWallet

```shell
sudo apt-get purge --autoremove kwalletmanager
```

### Remove KDE Connect

```shell
sudo apt-get purge --autoremove kdeconnect
```

### Remove all pip packages

```shell
pip freeze > requirements.txt
```

```shell
pip uninstall -r requirements.txt
```

## Nvidia Graphics

To enable support for Nvidia Graphics Cards using Wayland do the following:

Install the Nvidia Wayland library:

```shell
sudo apt-get install libnvidia-egl-wayland1
```

Afterwards list available Nvidia graphics drivers for Ubuntu derivates and install the recommended one:

```shell
sudo ubuntu-drivers list
sudo ubuntu-drivers install
```

## SSL Inspection

### Add root CA to java

Navigate to `*/jbr` or `*/jre` and then `lib/security`.  
Then type the following:

```shell
keytool -import -alias aldi -keystore cacerts -file ~/Dokumente/AlDiRootCA.crt
```

## Applications

### Firefox

```shell
flatpak install flathub org.mozilla.firefox
```

To apply policies to Firefox via the [policies.json](firefox/policies.json), just place it at `/var/lib/flatpak/app/org.mozilla.firefox/x86_64/stable/<id>/files/lib/firefox/distribution`.  
Restart Firefox and find applied policies at `about:policies`.

Custom configs not available with the centralized policy configuration:

- `full-screen-api.warning.timeout`: 0 (disables the fullscreen popup)
- `reader.parse-on-load.enabled`: false (disables the simplified reader mode)
- remove all removable search keywords in the search settings

### OneDrive

To install the current version (and not download from Ubuntu Universe) use the following installation instructions:  
https://github.com/abraunegg/onedrive/blob/master/docs/ubuntu-package-install.md#distribution-ubuntu-2204

To allow logging to `/var/log/onedrive`, do the following:

```shell
sudo mkdir /var/log/onedrive
sudo chown root:niko /var/log/onedrive
sudo chmod 0775 /var/log/onedrive
```

Initialize onedrive:  
`onedrive`

After initializing onedrive and BEFORE running the first sync, copy [config](onedrive/config) and [sync_list](onedrive/sync_list) to `~/.config/onedrive/`. Check the config with `onedrive --display-config`.

First sync:  
`onedrive --resync --synchronize`

### Timeshift

To fix a buggy and old version in the default repo, load a newer version from a non-default repo:
```shell
sudo add-apt-repository ppa:teejee2008/timeshift
sudo apt-get install timeshift=24.01.1-0
sudo apt-mark hold timeshift
```

Copy [timeshift.json](timeshift/timeshift.json) to /etc/timeshift/ to apply custom backup settings.  
Adjust the backup drive if needed.

### yt-dlp

```shell
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp
```

### Wireshark

To install Wireshark and allow traffic capture on all interfaces, do the following:

```shell
sudo apt-get install wireshark
sudo chmod +x /usr/bin/dumpcap
sudo adduser $USER wireshark
```

## Other Tools

### JAVA_HOME

To set the JAVA_HOME variable, edit the `.profile` file in your home dir and add the following:

```shell
export JAVA_HOME="the path to the parent of your java bin path"
export PATH=$JAVA_HOME/bin:$PATH
```

### Exiftool

```shell
sudo apt-get install libimage-exiftool-perl
```

```shell
exiftool -all= file.png
```
