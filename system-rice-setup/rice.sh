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

## Yay AUR Helper
printf "${BLUE}\nInstalling Yay...\n${NON}"

cd /opt
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER ./yay-git

cd yay-git
makepkg -si

cd $HOME
yay -Syu

## Packages From List
printf "${BLUE}\nThe following packages will be installed:\n${NON}"

cat $HOME/system-rice-Setup/packages

printf "${BLUE}\nIf there are any packages you wish not to install, remove them from the packges file now.\n${NON}"
confirm

yay -S < packages

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