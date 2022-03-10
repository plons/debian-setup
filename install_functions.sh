#!/bin/bash

function install_bc() {
    hash bc 2> /dev/null || { sudo apt-get install bc; }
}

function install_git() {
    hash git 2> /dev/null || { sudo apt-get install -y git; }
}

function install_perl() {
    hash perl 2> /dev/null || { sudo apt-get install -y perl; }
}

function install_perl_modules() {
    for module in in "$@"; do
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
    hash zenity 2>/dev/null || { sudo apt-get install -y zenity; }
}

function install_wget() {
    hash wget 2> /dev/null || { sudo apt-get install -y wget; }
}

function install_bootstrap_tools() {

    if     ! dpkg -l apt-transport-https > /dev/null \
        || ! dpkg -l ca-certificates > /dev/null \
        || ! dpkg -l curl > /dev/null \
        || ! dpkg -l gnupg2 > /dev/null \
        || ! dpkg -l software-properties-common > /dev/null;
    then
        sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
    fi
}

function install_docker() {
    if ! hash docker 2>/dev/null; then
        install_bootstrap_tools
        install_zenity

        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce
        sudo adduser ${USER:-1000} docker

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
