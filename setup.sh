#!/bin/bash

function linkFile {
  sourceFile="${sourceFolder}/${1}"
  destFile="${destFolder}/${1}"
  dateStr=$(date +%Y-%m-%d-%H%M)

  if [ -h "${destFile}" ]; then
    # Existing symlink
    echo "Removing existing symlink: ${destFile}"
    rm "${destFile}"

  elif [ -f "${destFile}" ]; then
    # Existing file
    echo "Backing up existing file: ${destFile}"
    mv "${destFile}"{,.${dateStr}}

  elif [ -d "${destFile}" ]; then
    # Existing dir
    echo "Backing up existing dir: ${destFile}"
    mv "${destFile}"{,.${dateStr}}
  fi

  echo "Creating new symlink: ${destFile}"
  ln -s "${sourceFile}" "${destFile}"
}

sourceFolder="$(pwd)"
destFolder="${HOME}"

linkFile .bash_profile
linkFile .gitconfig

sourceFolder="$(pwd)/sublime-text"
destFolder="${HOME}/Library/Application Support/Sublime Text/Packages/User"

for i in ${sourceFolder}/*
do
  linkFile "${i##*/}"
done
