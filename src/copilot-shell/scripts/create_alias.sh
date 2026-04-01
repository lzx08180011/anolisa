#!/usr/bin/env bash
set -euo pipefail

# This script creates aliases for the Copilot Shell CLI

# Determine the project directory
PROJECT_DIR=$(cd "$(dirname "$0")/.." && pwd)
ALIAS_CO="alias co='node \"${PROJECT_DIR}/scripts/start.js\"'"
ALIAS_COSH="alias cosh='node \"${PROJECT_DIR}/scripts/start.js\"'"
ALIAS_COPILOT="alias copilot='node \"${PROJECT_DIR}/scripts/start.js\"'"

# Detect shell and set config file path
if [[ "${SHELL}" == *"/bash" ]]; then
    CONFIG_FILE="${HOME}/.bashrc"
elif [[ "${SHELL}" == *"/zsh" ]]; then
    CONFIG_FILE="${HOME}/.zshrc"
else
    echo "Unsupported shell. Only bash and zsh are supported."
    exit 1
fi

echo "This script will add the following aliases to your shell configuration file (${CONFIG_FILE}):"
echo "  ${ALIAS_CO}"
echo "  ${ALIAS_COSH}"
echo "  ${ALIAS_COPILOT}"
echo ""

# Check if the aliases already exist
CO_EXISTS=false
COSH_EXISTS=false
COPILOT_EXISTS=false
if grep -q "alias co=" "${CONFIG_FILE}"; then CO_EXISTS=true; fi
if grep -q "alias cosh=" "${CONFIG_FILE}"; then COSH_EXISTS=true; fi
if grep -q "alias copilot=" "${CONFIG_FILE}"; then COPILOT_EXISTS=true; fi

if $CO_EXISTS && $COSH_EXISTS && $COPILOT_EXISTS; then
    echo "All aliases ('co', 'cosh', 'copilot') already exist in ${CONFIG_FILE}. No changes were made."
    exit 0
fi

if ! read -t 30 -p "Do you want to proceed? (y/n, auto-yes in 30s) " -n 1 -r; then
    REPLY="y"
    echo " (timeout, auto-accepted)"
fi
echo ""
if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    if ! $CO_EXISTS; then echo "${ALIAS_CO}" >> "${CONFIG_FILE}"; fi
    if ! $COSH_EXISTS; then echo "${ALIAS_COSH}" >> "${CONFIG_FILE}"; fi
    if ! $COPILOT_EXISTS; then echo "${ALIAS_COPILOT}" >> "${CONFIG_FILE}"; fi
    echo ""
    echo "Aliases added to ${CONFIG_FILE}."
    echo "Please run 'source ${CONFIG_FILE}' or open a new terminal to use the 'co' / 'cosh' / 'copilot' commands."
else
    echo "Aborted. No changes were made."
fi
