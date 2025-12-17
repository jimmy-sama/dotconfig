#!/usr/bin/bash

PACKAGER=""
SUDO_CMD=""

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

checkPackageManager() {
    PACKAGEMANAGER='nala apt dnf yum pacman'
    for pgm in $PACKAGEMANAGER; do
        if command_exists "$pgm"; then
            PACKAGER="$pgm"
            printf "Using %s\n" "$pgm"
            break
        fi
    done

    if [ -z "$PACKAGER" ]; then
        print_colored "$RED" "Can't find a supported package manager"
        exit 1
    fi
}

checkSudoCommand() {
    if command_exists sudo; then
        SUDO_CMD="sudo"
    elif command_exists doas && [ -f "/etc/doas.conf" ]; then
        SUDO_CMD="doas"
    else
        SUDO_CMD="su -c"
    fi

    printf "Using %s as privilege escalation software\n" "$SUDO_CMD"
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

    ## Check for correct Locals
    if ! locale -a | grep "en_US.UTF-8 UTF-8"; then
	sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
	locale-gen
    fi

    if ! grep "LANG=en_US.UTF-8" /etc/locale.conf; then
	echo "LANG=en_US.UTF-8"	> /etc/locale.conf
    fi
}

installDepend() {
    ## Check for dependencies.
    DEPENDENCIES='ansible-core git python3'

    echo "Installing dependencies..."

    if [ "$PACKAGER" = "pacman" ]; then
	${SUDO_CMD} ${PACKAGER} -S ${DEPENDENCIES} --needed --noconfirm
	if ! command_exists paru; then
	    ${SUDO_CMD} ${PACKAGER} -S base-devel --needed --noconfirm
	    printf "%b\n" "${YELLOW}Installing paru as AUR helper...${RC}"
	    cd /opt && "$SUDO_CMD" git clone https://aur.archlinux.org/paru.git && "$SUDO_CMD" chown -R "$USER": ./paru
	    cd paru && makepkg --noconfirm -si
	    printf "%b\n" "${GREEN}Paru installed${RC}"
	    cd ~/
	else
	    printf "%b\n" "${GREEN}Paru already installed${RC}"
	fi
	ansible-galaxy collection install kewlfft.aur
    elif [ "$PACKAGER" = "nala" ] || [ "$PACKAGER" = "apt" ]; then
	${SUDO_CMD} ${PACKAGER} install ${DEPENDENCIES} --assume-yes
    elif [ "$PACKAGER" = "dnf" ] || [ "$PACKAGER" = "yum" ]; then
	${SUDO_CMD} ${PACKAGER} install ${DEPENDENCIES} --assumeyes
    fi

    ansible-galaxy collection install community.general
}

startAnsible() {
    REPOLOCATION="$HOME/workspace/git/hub/dotconfig" 
    if [ ! -d "$REPOLOCATION" ]; then
	echo "Cloning dotconfig repository into: $REPOLOCATION"
	mkdir -p $REPOLOCATION
	git clone https://github.com/jimmy-sama/dotconfig "$REPOLOCATION"
	if [ $? -eq 0 ]; then
	    echo "Successfully cloned dotconfig repository"
	else
	    echo "Failed to clone dotconfig repository"
	    exit 1
	fi
    else
	cd "$REPOLOCATION"
	git pull
	if [ $? -eq 0 ]; then
	    echo "Successfully pulled the latest changes"
	else
	    echo "Failed to pull the repo"
	    exit 1
	fi
    fi

    # ansible-playbook main.yml -K
}

checkPackageManager
checkSudoCommand
checkEnv
installDepend
startAnsible
