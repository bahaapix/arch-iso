#!/bin/bash

DISK="/dev/sda"
ROOT_PARTITION="${DISK}1"
SWAP_PARTITION="${DISK}2"
SWAP_SIZE="16G"

parted --script -- "$DISK" mklabel msdos

DISK_SIZE=$(lsblk -b -n -o SIZE "$DISK")
DISK_SIZE_MIB=$((DISK_SIZE / 1024 / 1024))

SWAP_SIZE_MIB=$((16 * 1024))

ROOT_SIZE_MIB=$((DISK_SIZE_MIB - SWAP_SIZE_MIB))

parted --script -- "$DISK" mkpart primary ext4 1MiB "${ROOT_SIZE_MIB}MiB"

SWAP_START_MIB=$(( (ROOT_SIZE_MIB + 1) / 2 * 2 ))  # Round up to the nearest even MiB

parted --script -- "$DISK" mkpart primary linux-swap "${SWAP_START_MIB}MiB" 100%

parted --script -- "$DISK" set 1 boot on

mkfs.ext4 -F "$ROOT_PARTITION"
mkswap "$SWAP_PARTITION"
swapon "$SWAP_PARTITION"
mount "$ROOT_PARTITION" /mnt

parted -s "$DISK" print
