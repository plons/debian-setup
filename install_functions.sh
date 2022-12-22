#!/bin/bash

function apt_install() {
    if [ -z "${_APT_UPDATE_CALLED}" ]; then
        sudo apt-get update;
        _APT_UPDATE_CALLED=1
    fi
    sudo apt-get install --assume-yes "$@"
}

function install_bc() { hash bc 2> /dev/null || { apt_install bc; } }
function install_make() { hash make 2> /dev/null || { apt_install make; } }
function install_git() { hash git 2> /dev/null || { apt_install git; } }
function install_realpath() { hash realpath 2> /dev/null || { sudo apt-get install coreutils; } }

function install_git_lg() {
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
}

function install_gitslave() {
    hash gits 2> /dev/null || {
        install_git
        install_make

        temp_dir=$(mktemp -d)
        pushd "${temp_dir}" || { echo "Unable to enter temp dir, bailing out"; exit 1; }
        git clone https://github.com/jaypha/gitslave
        pushd gitslave || { echo "Unable to enter gitslave dir, bailing out"; exit 1; }
        make
        sudo make install
        popd || echo "Unable to exit gitslave dir"
        popd || echo "Unable to exit tempdir"
        rm -fr "${temp_dir}"
    }
}

function install_perl() {
    hash perl 2> /dev/null || { apt_install perl; }
}

function install_perl_modules() {
    export PERL_MM_USE_DEFAULT=1
    export CPAN_MM_USE_DEFAULT=1
    for module in "$@"; do
        if cpan -l 2>/dev/null |grep -q "${module}"; then
            echo "Perl module ${module} already installed"
        else
            cpan install "${module}"
        fi
    done
}

function install_go() {
    install_bootstrap_tools

    if [ ! -x /usr/local/go/bin/go ]; then

        # Download and extract go executable
        local source_package_filemane="go1.17.7.linux-amd64.tar.gz"
        local source_package_destination="/usr/local/${source_package_filemane}"
        if [ ! -f "${source_package_destination}" ]; then
            sudo curl \
                -L "https://go.dev/dl/${source_package_filemane}" \
                -o "${source_package_destination}"
        fi
        sudo tar -C /usr/local -xzf "${source_package_destination}"

        # Append bin location to PATH
        if [ ! -d "$HOME/.bashrc.d" ]; then
            # Add support for .bashrc.d
            mkdir -p "$HOME/.bashrc.d"
            cat << EOF >> $HOME/.bashrc
if [ -d ~/.bashrc.d ]; then
    for script in ~/.bashrc.d/*
    do
        # skip non-executable snippets
        [ -x "\$script" ] || continue
        . \$script
    done
fi
EOF
        fi
        echo "export PATH=\$PATH:/usr/local/go/bin:$HOME/go/bin" > $HOME/.bashrc.d/go.sh
        chmod +x $HOME/.bashrc.d/go.sh
        source $HOME/.bashrc
    else
        echo "$(go version) already installed"
    fi
}

function install_grpcui() {
    install_go

    # see https://github.com/fullstorydev/grpcui
    hash grpcui 2>/dev/null || { go install github.com/fullstorydev/grpcui/cmd/grpcui@latest; }
}

function install_zenity() {
    hash zenity 2>/dev/null || { apt_install zenity; }
}

function install_wget() {
    hash wget 2> /dev/null || { apt_install wget; }
}

function install_bootstrap_tools() {

    if     ! dpkg -l apt-transport-https > /dev/null \
        || ! dpkg -l ca-certificates > /dev/null \
        || ! dpkg -l curl > /dev/null \
        || ! dpkg -l gnupg2 > /dev/null \
        || ! dpkg -l software-properties-common > /dev/null;
    then
        sudo apt-get update && apt_install apt-transport-https ca-certificates curl gnupg2 software-properties-common
    fi
}

function install_docker() {
    if ! hash docker 2>/dev/null; then
        install_bootstrap_tools
        install_zenity

        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
        sudo apt-get update
        apt_install docker-ce
        sudo adduser "${USER:-1000}" docker

        local warning="Docker is now installed. Log out/in to use."
        if [ -n "${DISPLAY}" ]; then
            zenity --warning \
                --title "docker install" \
                --text "${warning}"
        else
            echo -e "\n ==== ${warning} ==== \n"
        fi
    else
        echo "$(docker --version) already installed."
    fi
}

function install_docker_compose() {
    if ! hash docker-compose 2>/dev/null; then
        install_bootstrap_tools
        install_docker

        # See https://docs.docker.com/compose/install/
        sudo curl \
            -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
            -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        sudo curl \
            -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose \
            -o /etc/bash_completion.d/docker-compose
    else
        echo "$(docker-compose --version) already installed."
    fi
}

function install_x11docker() {
    if ! hash x11docker 2> /dev/null; then
        install_git
        install_docker

        mkdir -p ~/src
        git clone https://github.com/mviereck/x11docker ~/src/x11docker
        pushd ~/src/x11docker && sudo ./x11docker --install && popd
    fi
}

function install_vscode() {
    if ! hash code 2>/dev/null; then
        install_wget
        wget -O code.deb https://update.code.visualstudio.com/latest/linux-deb-x64/stable
        sudo dpkg -i code.deb || sudo apt-get install -f -y
        rm code.deb
        code --install-extension ms-vscode-remote.remote-containers
        echo "Installed Visual Studio Code version: $(code --version |head -n 1)"
    else
        echo "Visual Studio Code  $(code --version |head -n 1) already installed"
    fi
}
