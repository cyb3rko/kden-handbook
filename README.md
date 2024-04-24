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
  - [Remove Bluetooth](#remove-bluetooth)
  - [Remove all pip packages](#remove-all-pip-packages)
- [SSL Inspection](#ssl-inspection)
  - [Add root CA to java](#add-root-ca-to-java)
- [Applications](#applications)
  - [Firefox](#firefox)
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

### Remove Bluetooth

```shell
sudo apt-get purge bluez
```

### Remove all pip packages

```shell
pip freeze > requirements.txt
```

```shell
pip uninstall -r requirements.txt
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
