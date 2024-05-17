#!/usr/bin/bash

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'

command_exists () {
    command -v $1 >/dev/null 2>&1;
}

checkEnv() {
    ## Check for requirements.
    REQUIREMENTS='groups sudo'
    if ! command_exists ${REQUIREMENTS}; then
        echo -e "${RED}To run me, you need: ${REQUIREMENTS}${RC}"
        exit 1
    fi

    ## Check Package Handeler
    PACKAGEMANAGER='apt dnf pacman zypper'
    for pgm in ${PACKAGEMANAGER}; do
        if command_exists ${pgm}; then
            PACKAGER=${pgm}
            echo -e "Using ${pgm}"
        fi
    done
    if [ -z "${PACKAGER}" ]; then
        echo -e "${RED}Can't find a supported package manager"
        exit 1
    fi

    ## Check if the current directory is writable
    GITPATH="$(dirname "$(realpath "$0")")"
    if [[ ! -w ${GITPATH} ]]; then
      echo -e "${RED}Can't write to ${GITPATH}${RC}"
      exit 1
   fi
    ## Check SuperUser Group
    SUPERUSERGROUP='wheel sudo'
    for sug in ${SUPERUSERGROUP}; do
        if groups | grep ${sug}; then
            SUGROUP=${sug}
            echo -e "Super user group ${SUGROUP}"
        fi
    done

    ## Check if member of the sudo group.
    if ! groups | grep ${SUGROUP} >/dev/null; then
        echo -e "${RED}You need to be a member of the sudo group to run me!"
        exit 1
    fi
}

installDependencies() {
    DEPENDENCIES="ansible git"
    echo -e "${YELLOW}Installing dependencies...${RC}"
    if [[ $PACKAGER == "pacman" ]]; then
        if ! command_exists yay && ! command_exists paru; then
            echo "Installing yay as AUR helper..."
            sudo ${PACKAGER} --noconfirm -S base-devel
            git clone https://aur.archlinux.org/paru.git
            cd paru && makepkg --noconfirm -si
            cd .. && rm -rf paru
        else
            echo "Aur helper already installed"
        fi
        if ! command_exists yay && ! command_exists paru; then
            echo "No AUR helper found. Please install yay or paru."
            exit 1
        fi
        ${PACKAGER} --noconfirm -S ${DEPENDENCIES}
    else
        sudo ${PACKAGER} install -yq ${DEPENDENCIES}
    fi
}

execPlaybook() {
    if [[ `uname` == 'Linux' ]]; then
        mkdir -p ~/workspace/github/
        git clone https://github.com/jimmy-sama/dotconfig.git ~/workspace/github/dotconfig/
        ansible-playbook main.yml -K
    else
        echo -e "${RED}Only Linux systems are supported at this time!${RC}"
        exit 1
    fi
}

checkEnv
installDependencies
execPlaybook
