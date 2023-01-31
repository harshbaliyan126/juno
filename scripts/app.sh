#!/bin/bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

TERMINAL_EMULATOR="$(cat "$1" | jq -r '.term.terminal_emulator')"
DESKTOP_ENV="$(cat "$1" | jq -r '.desk_env.desk_env')"
TIL_WIN="$(cat "$1" | jq -r '.twm.tiling_window_manager')"
LAUNCHER="$(cat "$1" | jq -r '.launcher.program_launcher')"

###########################################################

SPOTIFY="$(cat "$1" | jq -r '.package_install.spotify')"
FIREFOX="$(cat "$1" | jq -r '.package_install.firefox')"
DISCORD="$(cat "$1" | jq -r '.package_install.discord')"
GIMP="$(cat "$1" | jq -r '.package_install.gimp')"
OBS_STUDIO="$(cat "$1" | jq -r '.package_install.obs_studio')"
ZOOM="$(cat "$1" | jq -r '.package_install.zoom')"
MICRO_TEAM="$(cat "$1" | jq -r '.package_install.microsoft_teams')"
TELEGRAM="$(cat "$1" | jq -r '.package_install.telegram')"
LIBREOFFICE="$(cat "$1" | jq -r '.package_install.libreoffice')"
CHROMIUM="$(cat "$1" | jq -r '.package_install.chromium')"
VLC="$(cat "$1" | jq -r '.package_install.vlc')"
STEAM="$(cat "$1" | jq -r '.package_install.steam')"

##########################################################

VSCODE="$(cat "$1" | jq -r '.dev_tools.vscode')"
ATOM="$(cat "$1" | jq -r '.dev_tools.atom')"
NEOVIM="$(cat "$1" | jq -r '.dev_tools.neovim')"
GEANY="$(cat "$1" | jq -r '.dev_tools.geany')"
SUBLIME="$(cat "$1" | jq -r '.dev_tools.sublime_text')"
EMACS="$(cat "$1" | jq -r '.dev_tools.gnu_emacs')"
AND_STUDIO="$(cat "$1" | jq -r '.dev_tools.android_studio')"
CLION="$(cat "$1" | jq -r '.dev_tools.clion')"
IDC="$(cat "$1" | jq -r '.dev_tools.intellij_idea_community')"
IPC="$(cat "$1" | jq -r '.dev_tools.intellij_pycharm_community')"
WEBSTORM="$(cat "$1" | jq -r '.dev_tools.webstorm')"
POSTMAN="$(cat "$1" | jq -r '.dev_tools.webstorm')"
INSOMNIA="$(cat "$1" | jq -r '.dev_tools.insomnia')"


###sudo pacman -S --noconfirm --needed flatpak

if [[ "$TERMINAL_EMULATOR" != "none" ]]; then
    sudo pacman -S --noconfirm --needed $TERMINAL_EMULATOR
fi

if [[ "$DESKTOP_ENV" != "none" ]]; then
    sudo pacman -S --noconfirm --needed $DESKTOP_ENV
fi

if [[ "$TIL_WIN" != "none" ]]; then
    sudo pacman -S --noconfirm --needed $TIL_WIN
fi

if [[ "$LAUNCHER" != "none" ]]; then
    sudo pacman -S --noconfirm --needed $LAUNCHER
fi

#### PACKAGE

if  $CHROMIUM;then
    sudo pacman -S --noconfirm --needed $CHROMIUM
fi

if  $SPOTIFY;then
    sudo pacman -S --noconfirm --needed spotify-launcher
fi

if $FIREFOX;then
    sudo pacman -S --noconfirm --needed firefox
fi

if $VLC;then
    sudo pacman -S --noconfirm --needed vlc
fi

if $STEAM;then
    sudo pacman -S --noconfirm --needed steam
fi

if $DISCORD;then
    sudo pacman -S --noconfirm --needed discord
fi

if $GIMP;then
    sudo pacman -S --noconfirm --needed gimp
fi

if $OBS_STUDIO;then
    sudo pacman -S --noconfirm --needed obs-studio
fi

if $ZOOM;then
    yay -S --noconfirm --needed zoom
fi

if $MICRO_TEAM;then
    yay -S --noconfirm --needed teams
fi

if $LIBREOFFICE;then
    sudo pacman -S --noconfirm --needed libreoffice-still
fi

if $TELEGRAM;then
    flatpak install flathub org.telegram.desktop
fi

#### DEV TOOLS

if $VSCODE;then
    sudo pacman -S --noconfirm --needed code
fi

if $ATOM;then
    yay -S --noconfirm --needed atom
fi

if $NEOVIM;then
    sudo pacman -S --noconfirm --needed neovim
fi

if $GEANY;then
    sudo pacman -S --noconfirm --needed geany
fi

if $SUBLIME;then
    yay -S --noconfirm --needed sublime-text-4
fi

if $AND_STUDIO;then
    yay -S --noconfirm --needed android-studio
fi

if $EMACS;then
    yay -S --noconfirm --needed emacs26-git
fi

if $CLION;then
    yay -S --noconfirm --needed clion
fi

if $IDC; then
    sudo pacman -S --noconfirm --needed intellij-idea-community-edition 4:2022.3.2-1
fi

if $IPC; then
    sudo pacman -S --noconfirm --needed pycharm-community-edition 2022.3.2-1
fi

if $WEBSTORM; then
    sudo pacman -S --noconfirm --needed webstorm 2022.3.1-1
fi

if $POSTMAN; then
    yay -S --noconfirm --needed postman-bin
fi

if $INSOMNIA; then
    yay -S --noconfirm --needed insomnia
fi