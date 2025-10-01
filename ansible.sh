#!/bin/bash
echo "Lets install ansible"

sudo apt update
sudo apt install -y pipx python3-venv

sudo apt install pipx


pipx install --include-deps ansible

pipx ensurepath

echo "Ansible installation complete."