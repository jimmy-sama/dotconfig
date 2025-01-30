#!/usr/bin/bash

RC='\033[0m'
RED='\033[31m'
YELLOW='\033[33m'
GREEN='\033[32m'

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

checkEnv() {
    ## Check for requirements.
    REQUIREMENTS='curl groups sudo'
    for req in $REQUIREMENTS; do
        if ! command_exists "$req"; then
            echo "${RED}To run me, you need: $REQUIREMENTS${RC}"
            exit 1
        fi
    done

    ## Check Package Handler
    PACKAGEMANAGER='pacman dnf'
    for pgm in $PACKAGEMANAGER; do
        if command_exists "$pgm"; then
            PACKAGER="$pgm"
            echo "Using $pgm"
            break
        fi
    done

    if [ -z "$PACKAGER" ]; then
        echo "${RED}Can't find a supported package manager${RC}"
        exit 1
    fi

    if command_exists sudo; then
        SUDO_CMD="sudo"
    else
        SUDO_CMD="su -c"
    fi

    echo "Using $SUDO_CMD as privilege escalation software"

    ## Check if the current directory is writable.
    GITPATH=$(dirname "$(realpath "$0")")
    if [ ! -w "$GITPATH" ]; then
        echo "${RED}Can't write to $GITPATH${RC}"
        exit 1
    fi

    ## Check SuperUser Group

    SUPERUSERGROUP='wheel sudo root'
    for sug in $SUPERUSERGROUP; do
        if groups | grep -q "$sug"; then
            SUGROUP="$sug"
            echo "Super user group $SUGROUP"
            break
        fi
    done

    ## Check if member of the sudo group.
    if ! groups | grep -q "$SUGROUP"; then
        echo "${RED}You need to be a member of the sudo group to run me!${RC}"
        exit 1
    fi
}

installDepend() {
    ## Check for dependencies.
    DEPENDENCIES='ansible git'

    echo "${YELLOW}Installing dependencies...${RC}"
    if [ "$PACKAGER" = "pacman" ]; then
        ${SUDO_CMD} ${PACKAGER} -S ${DEPENDENCIES} --needed --noconfirm
    elif [ "$PACKAGER" = "dnf" ]; then
        ${SUDO_CMD} ${PACKAGER} install -y ${DEPENDENCIES}
    fi
}

startAnsible() {
    echo "${YELLOW}Cloning dotconfig repository into: $XDG_CONFIG_HOME/configManager${RC}"
    git clone https://github.com/jimmy-sama/dotconfig "$XDG_CONFIG_HOME/configManager"
    if [ $? -eq 0 ]; then
	echo "${GREEN}Successfully cloned mybash repository${RC}"
    else
	echo "${RED}Failed to clone mybash repository${RC}"
	exit 1
    fi

    echo "${RED}Here should start the playbook if it is in a usable state${RC}"
}

checkEnv
installDepend
startAnsible
