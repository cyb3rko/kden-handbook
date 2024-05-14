# KDE Neon Handbook

System info: (KDE Neon + Plasma Wayland)

---

- [Resource Management](#resource-management)
  - [Large file and folder monitor](#large-file-and-folder-monitor)
  - [Find large files](#find-large-files)
  - [AutoTrash](#autotrash)
  - [journalctl](#journalctl)
- [Packages](#packages)
  - [Cleanup after housekeeping](#cleanup-after-housekeeping)
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
  - [Timeshift](#timeshift)
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

### Cleanup after housekeeping

After removing many packages do this:

```shell
sudo apt-get autoremove && sudo apt-get autoclean
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

### Timeshift

To fix a buggy and old version in the default repo, load a newer version from a non-default repo:
```shell
sudo add-apt-repository ppa:teejee2008/timeshift
sudo apt-get install timeshift=24.01.1-0
sudo apt-mark hold timeshift
```

Copy [timeshift.json](timeshift/timeshift.json) to /etc/timeshift/ to apply custom backup settings.  
Adjust the backup drive if needed.

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
