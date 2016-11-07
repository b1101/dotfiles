#!/usr/bin/env sh
links=( ${XDG_CONFIG_HOME:-$HOME/.config}/* $HOME/.xprofile $HOME/.xinitrc $HOME/.profile ${XDG_DATA_HOME:-$HOME/.local}/fonts ${XDG_DATA_HOME:-$HOME/.local}/base16 )

for link in ${links[@]}; do
    if [ -L $link ]; then
        echo "Removing $link"
        rm $link
    fi
done
