#!/bin/bash

clear

setfont ter-v22b

pacman-key --init
pacman-key --populate
pacman -Sy --noconfirm archlinux-keyring
