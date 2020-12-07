#!/bin/sh
if [ ! -f ~/.zshrc ]; then
    sudo chown jenkins /var/run/docker.sock
    sh /zsh-in-docker.sh --skip-chsh || true
    sudo rm /etc/sudoers.d/jenkinsnosudo
    chsh -s /bin/zsh
    echo "OH MY ZSH has been set, now please"
    echo "login again to start using oh my zsh."
    exit
else
    zsh
    exit
fi