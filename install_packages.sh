#!/bin/bash
#
# This is my attempt at creating a rudimentary package manager for my
# neovim config
# git submodule add ${GITHUB LINK} pacpppfpins/start/${plugin}


# The source of truth is the .gitmodules file in the root of the repo

# Check if the user has git installed
# If not, exit with an error message
if ! [ -x "$(command -v git)" ]; then
  echo "Error: git is not installed" >&2
  exit 1
fi

# Check if the user has neovim installed
# If not, exit with an error message
if ! [ -x "$(command -v nvim)" ]; then
  echo "Error: neovim is not installed" >&2
  exit 1
fi

# Check if plugin directory exists 
# If not, create it
if [ ! -d pack/plugins/start ]; then
  mkdir -p pack/plugins/start
fi

# Check if the .gitmodules file exists
# If not, exit with an error message
if [ ! -f .gitmodules ]; then
  echo "Error: .gitmodules file not found" >&2
  exit 1
fi

# Print the plugin names
echo "Found the following plugins:"
git config --file .gitmodules --get-regexp path | awk '{ print $1 }' | sed 's:.*/::' | sed 's:path::'

# Ask the user if they want to install the plugins
# If not, exit
read -p "Do you want to install these plugins? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi


