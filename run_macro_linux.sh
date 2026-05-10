#!/bin/bash

# Linux run script for Fuzzy-Macro
# Assumes venv created by install_dependencies_linux.sh

VENV_PATH="$(pwd)/venv"
MAIN_FILE="src/main.py"

# Safer process killing (only kill processes in our venv if possible, 
# or use a lockfile. For now, we omit heavy-handed pkill)

if [ ! -d "$VENV_PATH" ]; then
    printf "\033[31;1mError: Virtual environment not found at $VENV_PATH. Run ./install_dependencies_linux.sh first.\033[0m\n"
    exit 1
fi

if [ ! -f "$MAIN_FILE" ]; then
    printf "\033[31;1mError: %s not found.\033[0m\n" "$MAIN_FILE"
    exit 1
fi

printf "\033[1;35mActivating virtual environment and starting macro...\033[0m\n"
source "$VENV_PATH/bin/activate"

# Launch main
python "$MAIN_FILE"
