#!/usr/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

checkEnv() {
    ## Check for requirements.
    REQUIREMENTS='groups sudo'
    for req in $REQUIREMENTS; do
        if ! command_exists "$req"; then
            echo "$To run me, you need: $REQUIREMENTS"
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
        echo "Can't find a supported package manager"
        exit 1
    fi

    if command_exists sudo; then
        SUDO_CMD="sudo"
    else
        SUDO_CMD="su -c"
    fi

    echo "Using $SUDO_CMD as privilege escalation software"

    ## Check if the current directory is writable.
    CWD=$(dirname "$(realpath "$0")")
    if [ ! -w "$CWD" ]; then
        echo "Can't write to $CWD"
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
        echo "You need to be a member of the sudo group to run me!"
        exit 1
    fi
}

installDepend() {
    ## Check for dependencies.
    DEPENDENCIES='ansible git'

    echo "Installing dependencies..."
    if [ "$PACKAGER" = "pacman" ]; then
        ${SUDO_CMD} ${PACKAGER} -S ${DEPENDENCIES} --needed --noconfirm
	ansible-galaxy collection install kewlfft.aur
    elif [ "$PACKAGER" = "dnf" ]; then
        ${SUDO_CMD} ${PACKAGER} install -y ${DEPENDENCIES}
    fi
}

startAnsible() {
    echo "Cloning dotconfig repository into: $HOME/configManager"
    git clone https://github.com/jimmy-sama/dotconfig "$HOME/configManager"
    if [ $? -eq 0 ]; then
	echo "Successfully cloned dotconfig repository"
    else
	echo "Failed to clone dotconfig repository"
	exit 1
    fi

    echo "Here should start the ansible playbook if it is in a usable state"
}

checkEnv
installDepend
startAnsible
