#!/bin/bash

if [[ ! -f "$1" ]]; then
    echo "Error 501: $1 doesn't exist"
    exit 501
fi

TERMINAL_EMULATOR="$(cat "$1" | jq -r '.term.terminal_emulator')"

CONFIG_ALACRITTY="$XDG_CONFIG_HOME/alacritty/alacritty.yml"
CONFIG_KITTY="$XDG_CONFIG_HOME/kitty/kitty.conf"

echo "Terminal emulator = $TERMINAL_EMULATOR "

arr_terminal=(alac_themes kitty_themes)
DEFAULT_JSON="$1"

# ALACRITTY FUNCTION BLOCK

alac() {
    ALAC_THEME="$(cat "$DEFAULT_JSON" | jq  '.font_theme.theme')"
    echo "Theme = $ALAC_THEME"

    # CONDITION TO FIND IF GIVEN THEME EXIST OR NOT ,IF NOT TERMINATE THE SCRIPT

    echo "alac function"
    pwd

    if [[ $(grep -c ${ALAC_THEME} ./scripts/themes/${arr_terminal[0]}.json) -eq 0 ]]; then
        echo "Error 502: $ALAC_THEME theme doens't exist"
	exit 502
    fi

    # CONDITION TO FIND OUT IF CONFIG FILE OF ALACRITTY ALREADY EXIST OR NOT

    if [[ -d "$XDG_CONFIG_HOME/alacritty" ]];then
	if [[ -f "$CONFIG_ALACRITTY" ]]; then
	    rm $CONFIG_ALACRITTY
	    cp ./scripts/config/alacritty.yml $XDG_CONFIG_HOME/alacritty/
	else
	    cp ./scripts/config/alacritty.yml $XDG_CONFIG_HOME/alacritty/
	fi
    else
	echo "Creating config file ........"
	mkdir $XDG_CONFIG_HOME/alacritty
	cp ./scripts/config/alacritty.yml $XDG_CONFIG_HOME/alacritty/
    fi

    THEMES=./scripts/themes/${arr_terminal[0]}.json

    return
}

# KITTY FUNCTION BLOCK

kitty() {
    KITTY_THEME="$(cat "$DEFAULT_JSON" | jq '.font_theme.theme')"
    echo "Theme = $KITTY_THEME"

    # CONDITION TO FIND IF GIVEN THEME EXIST OR NOT, IF NOT TERMINATE THE SCRIPT

    if [[ $(grep -c ${KITTY_THEME} ./scripts/themes/${arr_terminal[1]}.json) -eq 0 ]]; then
        echo "Error 502: $KITTY_THEME theme doens't exist"
	exit 502
    fi

    # CONDITION TO FIND OUT IF CONFIG FILE OF KITTY ALREADY EXIST OR NOT

    if [[ -d "./$XDG_CONFIG_HOME/kitty" ]];then
	if [[ -f "$CONFIG_KITTY" ]]; then
	    rm $CONFIG_KITTY
	    cp ./scripts/config/kitty.conf $XDG_CONFIG_HOME/kitty/
	else
	    cp ./scripts/config/kitty.conf $XDG_CONFIG_HOME/kitty
	fi
    else
	echo "Creating config file ........"
	mkdir $XDG_CONFIG_HOME/kitty
	cp ./scripts/config/kitty.conf $XDG_CONFIG_HOME/kitty/
    fi

    THEMES=./scripts/themes/${arr_terminal[1]}.json

    return
}

#CONDITION TO CHECK WHETHER THE TERMINAL CHOOSEN IS ALACRITTY OR KITTY

if [[ "${TERMINAL_EMULATOR}" = "alacritty" ]]; then
    alac
    TERMINAL_THEME=${ALAC_THEME}
elif [[ "${TERMINAL_EMULATOR}" = "kitty" ]]; then
    kitty
    TERMINAL_THEME=${KITTY_THEME}

    export cursor="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."cursor"')"

    export selection_foreground="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."selection_foreground"')"
    export selection_background="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."selection_background"')"
fi

# ENVIRONMENT VARIBALES FOR FONT

FONT="$(cat "$1" | jq -r '.font_theme.font_name')"


if [[ "$FONT" = "font-name-fira-code" ]];then
    sudo pacman -S --needed --noconfirm ttf-fira-code
    export font_family="Fira Code"
elif [[ "$FONT" = "font-name-fantasque-sans-mono" ]];then
    sudo pacman -S --needed --noconfirm ttf-fantasque-sans-mono
    export font_family="Fantasque Sans Mono"
elif [[ "$FONT" = "font-name-hack" ]];then
    sudo pacman -S --needed --noconfirm ttf-hack
    export font_family="Hack"
elif [[ "$FONT" = "font-name-ibm-plex" ]];then
    sudo pacman -S --needed --noconfirm ttf-ibm-plex
    export font_family="IBM Plex Mono"
elif [[ "$FONT" = "font-name-iosevka" ]];then
    sudo pacman -S --needed --noconfirm ttf-iosevka-nerd
    export font_family="Iosevka"
elif [[ "$FONT" = "font-name-inconsolata" ]];then
    sudo pacman -S --needed --noconfirm ttf-inconsolata
    export font_family="Inconsolata"
elif [[ "$FONT" = "font-name-jetbrains-mono" ]];then
    sudo pacman -S --needed --noconfirm ttf-jetbrains-mono
    export font_family="Jetbrains Mono"
elif [[ "$FONT" = "font-name-monoid" ]];then
    sudo pacman -S --needed --noconfirm ttf-monoid
    export font_family="Monoid"
elif [[ "$FONT" = "font-name-source-code-pro" ]];then
    sudo pacman -S --needed --noconfirm adobe-source-code-pro-fonts
    export font_family="Source Code Pro"
elif [[ "$FONT" = "font-name-ubuntu-font-family" ]];then
    sudo pacman -S --needed --noconfirm ttf-ubuntu-font-family
    export font_family="Ubuntu Mono"
else
    export font_family="monospace"
fi


echo "Font = $font_family"

export font_size="$(cat "$1" | jq '.font_theme.font_size')"

echo "Font Size = $font_size"

# ALL ENVIRONMENT VARIBALES FOR THEMES

export background="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."background"')"
export foreground="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."foreground"')"
export black_normal="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."black_normal"')"
export red_normal="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."red_normal"')"
export green_normal="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."green_normal"')"
export yellow_normal="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."yellow_normal"')"
export blue_normal="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."blue_normal"')"
export magenta_normal="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."magenta_normal"')"
export cyan_normal="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."cyan_normal"')"
export white_normal="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."white_normal"')"
export black_bright="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."black_bright"')"
export red_bright="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."red_bright"')"
export green_bright="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."green_bright"')"
export yellow_bright="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."yellow_bright"')"
export blue_bright="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."blue_bright"')"
export magenta_bright="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."magenta_bright"')"
export cyan_bright="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."cyan_bright"')"
export white_bright="$(cat "$THEMES" | jq -r --arg TERMINAL_THEME "$TERMINAL_THEME" '.[] | select(.'$TERMINAL_THEME') | .'$TERMINAL_THEME'."white_bright"')"

# SUBSITUTING THE VALUES OF ENVIRONMENTAL VARIABLES

if [[ "${TERMINAL_EMULATOR}" = "alacritty" ]]; then
    rm -f final.yml temp.yml
    ( echo "cat <<EOF >final.yml";
      cat $CONFIG_ALACRITTY;
      echo "EOF";
    ) >temp.yml
    . temp.yml ; rm temp.yml
    mv final.yml $CONFIG_ALACRITTY
elif [[ "${TERMINAL_EMULATOR}" = "kitty" ]]; then
    rm -f final.conf temp.conf
    ( echo "cat <<EOF >final.conf";
      cat $CONFIG_KITTY
      echo "EOF";
    ) >temp.conf
    . temp.conf ; rm temp.conf
    mv final.conf $CONFIG_KITTY
fi
