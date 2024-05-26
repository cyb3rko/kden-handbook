...

alias update="sudo yt-dlp -U && sudo flatpak update -v -y && sudo pkcon refresh -v && sudo pkcon update -v -y"
alias autoremove="sudo apt-get autoremove && sudo apt-get autoclean && flatpak uninstall --unused -y"
