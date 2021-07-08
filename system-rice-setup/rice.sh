#! /bin/bash
trap "exit" INT

# Colors
RED='\u001b[31m'
GREEN='\u001b[32m'
YELLOW='\u001b[33m'
BLUE='\u001b[34m'
NON='\033[0m'

PKGLIST=$HOME/system-rice-setup/packages.txt

confirm() {
    printf "${RED}Are you sure you want to continue? [y/n] (default=n)${NON} "
    read USRIN

    if [[ ${USRIN} != "y" ]]; then
        printf "${RED}Rice aborted!\n${NON}"
        exit
    fi
}

printf "${BLUE}
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
: ' printf "${YELLOW}\nUpdating your system...\n${NON}"

sudo pacman -Syu
# sudo pacman -S --needed git base-devel

## Yay AUR Helper
printf "${YELLOW}\nInstalling Yay...\n${NON}"

cd /opt
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER ./yay-git

cd yay-git
makepkg -si

cd $HOME
yay -Syu

## Packages From List
printf "${YELLOW}\nThe following packages will be installed:\n${NON}"

cat $PKGLIST

printf "${YELLOW}\nIf there are any packages you wish not to install, remove them from the packges file now.\n${NON}"
confirm

yay -S - < $PKGLIST

# Configurations

## LightDM
printf "${YELLOW}\nEnabling LightDM Service\n${NON}"


## Polybar
printf "${YELLOW}\nSetting up Polybar configurations\n${NON}"

polybar --config=$HOME/.config/polybar/

## Font installation
printf "${YELLOW}\nSetting up fonts\n${NON}"

mkdir -p $HOME/fonts
: '
### UW Ttyp0 1.3
curl -o $HOME/fonts/UW-Ttyp0 https://people.mpi-inf.mpg.de/~uwe/misc/uw-ttyp0/uw-ttyp0-1.3.tar.gz
tar -xf $HOME/fonts/UW-Ttyp0 -C $HOME/fonts/
cd $HOME/fonts/uw-ttyp0-1.3/
./configure
make
sudo make install

cd $HOME

### Addys Fonts
sudo mkdir -p /usr/local/share/fonts/
sudo git clone https://github.com/addy-dclxvi/bitmap-font-collections.git /usr/local/share/fonts/misc

sudo fc-cache -fv
'
printf "${GREEN}Setup complete. Some changes take effect when you log in again.${NON}\n"
