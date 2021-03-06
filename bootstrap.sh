#!/usr/bin/env bash

host="${1:?Missing host}"
tag="${2:?Missing tag}"


unamestr=$(uname)

# debian, ubuntu, mint etc.
if [[ $unamestr == "Linux"  && -f $(which apt-get) ]]; then
    sudo apt install -y software-properties-common build-essential curl file git
    sudo apt update
    sudo apt install --yes python3-jmespath
    sudo apt install --yes ansible
fi

if brew list ; then
    echo "brew command succeeded, skipping"
else
    echo "brew command failed, configuring"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bashrc && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi
    brew install pre-commit vaulted terraform terragrunt

sudo ansible-playbook -c local setup.yml -vv -i "$host", --tags "$tag"
