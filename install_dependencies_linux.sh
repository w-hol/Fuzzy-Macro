#!/bin/bash

# Linux installation script for Fuzzy-Macro
# Uses existing python in ./python/bin/python3

VENV_NAME="venv"
VENV_PATH="$(pwd)/$VENV_NAME"
PYTHON_BIN="$(pwd)/python/bin/python3"

if [ ! -x "$PYTHON_BIN" ]; then
    printf "\033[31;1mError: Python 3.9 not found at $PYTHON_BIN\033[0m\n"
    exit 1
fi

create_virtual_env() {
    if [ ! -d "$VENV_PATH" ]; then
        printf "\033[1;35mCreating virtual environment at $VENV_PATH\033[0m\n"
        "$PYTHON_BIN" -m venv "$VENV_PATH"
    else
        printf "\033[1;32mVirtual environment already exists at $VENV_PATH\033[0m\n"
    fi
}

activate_virtual_env() {
    printf "\033[1;35mActivating virtual environment\033[0m\n"
    source "$VENV_PATH/bin/activate"
}

install_pip_package() {
	local packages="$1"
	local extra_args="$2"
	pip install --prefer-binary --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --default-timeout=100 $extra_args $packages
}

upgrade_pip_tools() {
    "$PYTHON_BIN" -m pip install --upgrade pip setuptools wheel
}

#get system information
chip=$(uname -m)

if [[ "$chip" == "x86_64" ]]; then
    printf "\033[32;1mDetected x86_64 architecture\033[0m\n"
else
    printf "\033[31;1mUnsupported architecture: $chip\033[0m\n"
    exit 1
fi

# Check if python is installed
printf "\033[32;1mChecking for Python 3.9...\033[0m\n"

if [ -x "$PYTHON_BIN" ] && [[ "$($PYTHON_BIN --version 2>&1)" == Python\ 3.9* ]]; then
    printf "\033[32;1mFound Python 3.9 at $PYTHON_BIN\033[0m\n"
else
    printf "\033[31;1mPython 3.9 not found at $PYTHON_BIN\033[0m\n"
    exit 1
fi

printf "\033[32;1mStarting installation for Linux...\033[0m\n\n"

upgrade_pip_tools

attempt=1
while [ "$attempt" -le 3 ]; do
	create_virtual_env
	activate_virtual_env
	
	if [ -x "$VENV_PATH/bin/python" ] && [ -x "$VENV_PATH/bin/pip" ]; then
		echo -e "\033[1;32mVirtual environment is valid\033[0m"
		break
	else
		echo -e "\033[1;31mVirtual environment is broken, recreating...\033[0m"
		rm -rf "$VENV_PATH"
		((attempt++))
		sleep 2
	fi
done

pip install --upgrade pip setuptools wheel
install_pip_package "numpy<2"

printf "\033[1;35mInstalling libraries\033[0m\n\n"

# Core Linux dependencies
install_pip_package "opencv-python-headless<4.11 numpy<2" "--force-reinstall"
# Install torch cpu only
install_pip_package "torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu"
# Install easyocr without dependencies, as we handle torch manually
install_pip_package "ninja pyclipper python-bidi PyYAML scikit-image Shapely"
install_pip_package "easyocr" "--no-deps"
install_pip_package "pyautogui"
install_pip_package "mss"
install_pip_package "pillow"
install_pip_package "discord-webhook"
install_pip_package "discord.py"
install_pip_package "pypresence"
install_pip_package "matplotlib"
install_pip_package "fuzzywuzzy"
install_pip_package "python-Levenshtein"
install_pip_package "pyscreeze<0.1.29"
install_pip_package "html2image"
install_pip_package "gevent"
install_pip_package "eel"
install_pip_package "ImageHash"
install_pip_package "httpx"
install_pip_package "flask"
install_pip_package "pygetwindow"
install_pip_package "requests"
install_pip_package "aiohttp==3.10.5"
install_pip_package "pynput"
install_pip_package "tkinter"

# Fix html2image
"$VENV_PATH/bin/python" << "EOF"
import os, importlib.util
spec = importlib.util.find_spec('html2image')
if spec and spec.origin:
    path = os.path.join(os.path.dirname(spec.origin), "browsers", "chrome_cdp.py")
    if os.path.exists(path):
        linesToRemove = ["print(f'{r.json()=}')", "print(f'cdp_send: {method=} {params=}')", "print(f'{method=}')", "print(f'{message=}')"]
        with open(path, "r") as f:
            data = f.read()
        for i in linesToRemove:
            data = data.replace(i, "")
        with open(path, "w") as f:
            f.write(data)
EOF

printf "\n\n\n\033[32;1mInstallation complete!\033[0m\n"
