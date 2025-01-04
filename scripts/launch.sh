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

    DEPENDENCIES="ansible git"
    echo -e "${YELLOW}Installing dependencies...${RC}"
    if [[ $PACKAGER == "pacman" ]]; then
        sudo ${PACKAGER} --noconfirm -S ${DEPENDENCIES} --needed
        if ! command_exists yay && ! command_exists paru; then
            echo "Installing paru as AUR helper..."
            sudo ${PACKAGER} --noconfirm -S base-devel
            git clone https://aur.archlinux.org/paru.git
            cd paru && makepkg --noconfirm -si
            cd .. && rm -rf paru
        else
            echo "Aur helper already installed"
        fi
        if ! command_exists yay && ! command_exists paru; then
            echo "The Installation failed try again or install paru/yay manually."
            exit 1
        else
            ansible-galaxy collection install kewlfft.aur
        fi
    else
        sudo ${PACKAGER} install -yq ${DEPENDENCIES}
	ansible-galaxy install -r requirements.yml
    fi
}

execPlaybook() {
    if [[ `uname` == 'Linux' ]]; then
        mkdir -p ~/workspace/github/
        git clone https://github.com/jimmy-sama/dotconfig.git ~/workspace/github/dotconfig/
        cd ~/workspace/github/dotconfig/
        ansible-playbook main.yml -K
    else
        echo -e "${RED}Only Linux systems are supported at this time!${RC}"
        exit 1
    fi
}

checkEnv
installDependencies
execPlaybook
