#!/bin/bash

## Step 1 
sudo pacman -Syu

## Step 2
sudo pacman -S git

## Step 3 
sudo pacman -S --noconfirm flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Step 4 
sudo pacman -S xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon lib32-mesa vulkan-icd-loader lib32-vulkan-icd-loader

## Step 5 
yay -S steam lutris wine-staging wine-mono wine-gecko winetricks gamemode heroic-games-launcher lib32-gamemode lib32-mesa lib32-libpulse lib32-alsa-plugins lib32-alsa-lib lib32-libxcomposite lib32-libxinerama lib32-libxrandr lib32-gtk3 lib32-ncurses lib32-openal lib32-libxdamage lib32-libva lib32-libvdpau lib32-sdl2 lib32-glew lib32-gnutls mangohud goverlay dxvk-bin vkbasalt lib32-vkbasalt gamescope protonup-qt
