#!/bin/bash
set -e
if [ -f /etc/debian_version ]; then
    pkg_mgr="apt"
    sudo apt update
    sudo apt install -y firefox python3 python3-pip git curl sqlite3 espeak
elif [ -f /etc/redhat-release ]; then
    pkg_mgr="dnf"
    sudo dnf install -y firefox python3 python3-pip git curl sqlite sqlite-devel espeak
elif [ -f /etc/arch-release ]; then
    pkg_mgr="pacman"
    sudo pacman -Sy --noconfirm firefox python python-pip git curl sqlite espeak
else
    echo "unsupported distro"
    exit 1
fi
pip3 install --upgrade pip
pip3 install discord.py ollama selenium requests
curl -fsSL https://ollama.com/install.sh | sh
if pidof systemd >/dev/null; then
    sudo systemctl enable ollama
    sudo systemctl start ollama
else
    ollama serve &
fi
ollama pull llama3.2
ollama pull TheBloke/phi-2-GGUF
