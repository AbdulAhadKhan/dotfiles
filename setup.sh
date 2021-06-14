#! /bin/bash
trap "exit" INT

# Colors
RED='\u001b[31m'
GREEN='\u001b[32m'
YELLOW='\u001b[33m'
BLUE='\u001b[34m'
NON='\033[0m'

confirm() {
    printf "${RED}Are you sure you want to continue?${NON} "
    read USRIN

    if [[ ${USRIN} != "y" ]]; then
        exit
    fi
}

printf "${GREEN}
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #                                                     # #
# #     This script uses unconventional methods         # #
# #     and installs third party packages. You          # #
# #     should go through the script before running.    # #
# #     You can remove packages you don't need.         # #
# #                                                     # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
${NON}\n"

confirm

# Packages
## Update
printf "${BLUE}\nUpdating your system...\n${NON}"

pacman -Syu

## Display Server and Manager
printf "${BLUE}\nInstalling Xorg and LightDM\n${NON}"

pacman -S xorg xorg-xinit
pacman -S lightdm lightdm-gtk-greeter

## Eye Candy
printf "${BLUE}\nInstalling Eye Candies\n${NON}"

pacman -S bspwm sxhkd
pacman -S polybar rofi picom
pacman -S feh

## terminal and Editors
printf "${BLUE}\nInstalling Terminal and Editors\n${NON}"

pacman -S rxvt-unicode
pacman -S nano visual-studio-code-bin

## Browser
printf "${BLUE}\nInstalling Browser\n${NON}"

pacman -S firefox

## Font installation
printf "${BLUE}\nSetting up fonts\n${NON}"

mkdir $HOME/fonts

### UW Ttyp0 1.3
curl -o $HOME/fonts/UW-Ttype0 https://people.mpi-inf.mpg.de/~uwe/misc/uw-ttyp0/uw-ttyp0-1.3.tar.gz
tar -xf $HOME/fonts/UW-Ttyp0 -C $HOME/fonts/
cd $HOME/fonts/uw-ttyp0-1.3/
./configure
make
make installation

cd $HOME

### Addy's Fonts
mkdir -p /usr/local/share/fonts/
git clone https://github.com/addy-dclxvi/bitmap-font-collections.git /usr/local/share/fonts/misc

fc-cache -fv

printf "${YELLOW}Setup complete. Some changes take effect when you log out.${NON}\n"