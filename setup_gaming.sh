#!/bin/bash

# Function to update the system
update_system() {
    sudo pacman -Syu --noconfirm || { echo "System update failed"; exit 1; }
}

# Function to check and install git
install_git() {
    if ! command -v git &> /dev/null; then
        sudo pacman -S --noconfirm git || { echo "Git installation failed"; exit 1; }
    fi
}

# Function to install Flatpak
install_flatpak() {
    if ! command -v flatpak &> /dev/null; then
        sudo pacman -S --noconfirm flatpak || { echo "Flatpak installation failed"; exit 1; }
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || { echo "Adding Flathub failed"; exit 1; }
    fi
}

# Function to install AUR helper (paru)
install_paru() {
    if ! command -v paru &> /dev/null; then
        sudo pacman -S --noconfirm base-devel || { echo "Base-devel installation failed"; exit 1; }
        git clone https://aur.archlinux.org/paru.git || { echo "Cloning paru failed"; exit 1; }
        cd paru || { echo "Changing directory failed"; exit 1; }
        makepkg -si --noconfirm || { echo "Building paru failed"; exit 1; }
        cd ..
        rm -rf paru
    fi
}

# Function to update the system using paru
update_system_paru() {
    paru -Syu --noconfirm || { echo "Paru system update failed"; exit 1; }
}

# Function to install GPU drivers
install_gpu_drivers() {
    # For NVIDIA
    if lspci | grep -i nvidia > /dev/null; then
        paru -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils || { echo "NVIDIA driver installation failed"; exit 1; }
    fi

    # For AMD
    if lspci | grep -i amd > /dev/null; then
        paru -S --noconfirm xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon || { echo "AMD driver installation failed"; exit 1; }
    fi

    # For Intel
    if lspci | grep -i intel > /dev/null; then
        paru -S --noconfirm vulkan-intel lib32-vulkan-intel || { echo "Intel driver installation failed"; exit 1; }
    fi
}

# Function to install essential packages
install_essential_packages() {
    paru -S --noconfirm steam lutris wine-staging wine-mono wine-gecko winetricks gamemode || { echo "Essential package installation failed"; exit 1; }
}

# Function to install 32-bit libraries needed for gaming
install_32bit_libraries() {
    paru -S --noconfirm lib32-gamemode lib32-mesa lib32-libpulse lib32-alsa-plugins lib32-alsa-lib lib32-libxcomposite lib32-libxinerama lib32-libxrandr lib32-gtk3 lib32-ncurses lib32-openal lib32-libxdamage lib32-libva lib32-libvdpau lib32-sdl2 lib32-glew lib32-gnutls || { echo "32-bit library installation failed"; exit 1; }
}

# Function to install PipeWire packages (excluding pipewire-media-session and pipewire-docs)
install_pipewire_packages() {
    paru -S --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack pipewire-zeroconf wireplumber || { echo "PipeWire package installation failed"; exit 1; }
}

# Function to install MangoHud and GOverlay for monitoring FPS, GPU, and CPU usage
install_mangohud_goverlay() {
    paru -S --noconfirm mangohud goverlay || { echo "MangoHud and GOverlay installation failed"; exit 1; }
    echo "MANGOHUD=1" >> ~/.profile
}

# Function to install DXVK from the official GitHub repository
install_dxvk() {
    paru -S --noconfirm glslang vulkan-headers ninja || { echo "DXVK dependencies installation failed"; exit 1; }

    git clone https://github.com/doitsujin/dxvk.git || { echo "Cloning DXVK failed"; exit 1; }
    cd dxvk || { echo "Changing directory failed"; exit 1; }
    ./package-release.sh master /tmp/dxvk || { echo "Building DXVK failed"; exit 1; }
    sudo cp /tmp/dxvk/x64/* /usr/share/dxvk/x64/ || { echo "Copying DXVK 64-bit files failed"; exit 1; }
    sudo cp /tmp/dxvk/x32/* /usr/share/dxvk/x32/ || { echo "Copying DXVK 32-bit files failed"; exit 1; }
    cd ..
    rm -rf dxvk
}

# Function to install vkBasalt
install_vkbasalt() {
    paru -S --noconfirm vkbasalt lib32-vkbasalt || { echo "vkBasalt installation failed"; exit 1; }
    echo "ENABLE_VKBASALT=1" >> ~/.profile
}

# Function to install Gamescope
install_gamescope() {
    paru -S --noconfirm gamescope || { echo "Gamescope installation failed"; exit 1; }
}

# Function to install Proton GE from Flathub
install_proton_ge() {
    flatpak install flathub com.valvesoftware.Steam.CompatibilityTool.Proton-GE --noninteractive || { echo "Proton GE installation failed"; exit 1; }
}

# Function to create directories for Steam libraries
create_steam_directories() {
    mkdir -p "$HOME/.steam/steam/steamapps/compatdata" || { echo "Creating Steam compatdata directory failed"; exit 1; }
    mkdir -p "$HOME/.local/share/Steam/steamapps/common" || { echo "Creating Steam common directory failed"; exit 1; }
}

# Function to enable and start the Steam service
enable_steam_service() {
    sudo systemctl enable --now steam.service || { echo "Enabling Steam service failed"; exit 1; }
}

# Main function to call all other functions
main() {
    update_system
    install_git
    install_flatpak
    install_paru
    update_system_paru
    install_gpu_drivers
    install_essential_packages
    install_32bit_libraries
    install_pipewire_packages
    install_mangohud_goverlay
    install_dxvk
    install_vkbasalt
    install_gamescope
    install_proton_ge
    create_steam_directories
    enable_steam_service
    echo "Gaming setup complete! Reboot your system to apply all changes."
}

# Execute the main function
main

