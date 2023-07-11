#!/bin/bash

# Constants
DOWNLOAD_DIR="/software/packages"
NITROX_DIR="/software/nitrox"
PATCH_NOTES_FILE="../nitrox/Patch Notes.txt"
NITROX_LAUNCHER="../nitrox/NitroxLauncher.exe"
API_URL="https://nitrox.rux.gg/api/version/latest"

function check_and_create_directory() {
  if [[ ! -d "$DOWNLOAD_DIR" ]]; then
    echo "Creating $DOWNLOAD_DIR directory..."
    mkdir -p "$DOWNLOAD_DIR"
  fi

  echo "Changing directory to $DOWNLOAD_DIR..."
  cd "$DOWNLOAD_DIR" || exit 1
}

function download_nitrox() {
  if [[ -n "$NITROX_VERSION" ]]; then
    echo "Downloading Nitrox version $NITROX_VERSION"
    url="https://api.github.com/repos/SubnauticaNitrox/Nitrox/releases/tags/$NITROX_VERSION"
  else
    echo "Downloading latest Nitrox release"
    url="https://api.github.com/repos/SubnauticaNitrox/Nitrox/releases/latest"
  fi

  curl -s "$url" \
    | grep "browser_download_url.*zip" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -O "$DOWNLOAD_DIR/nitrox.zip" -qi -

  response=$(curl -s -o /dev/null -w "%{http_code}" "$url")

  if [[ $response -eq 404 ]]; then
    echo "Error: Nitrox release not found. Please ensure you have set the NITROX_VERSION environment variable correctly. You can check for available versions of Nitrox at https://github.com/SubnauticaNitrox/Nitrox/releases/"
    exit 1
  fi
}

function install_nitrox() {
  # Unzip the package
  echo "Unzipping Nitrox..."
  mkdir -p "$NITROX_DIR"
  unzip -o -u "$DOWNLOAD_DIR/nitrox.zip" -d "$NITROX_DIR"

  # Fix the permissions
  echo "Fixing Nitrox permissions..."
  chmod +x "$NITROX_DIR"/*.exe

  # Fix bug due to Linux file name case sensitivity
  echo "Fixing Nitrox case sensitive filenames..."
  ln -sf "$NITROX_DIR/Subnautica_Data/Managed/LitJson.dll" "$NITROX_DIR/LitJSON.dll"

  # Set the path to Subnautica
  echo "/software/subnautica" > "$NITROX_DIR/path.txt"
}

function get_installed_version() {
  if [[ ! -f "$PATCH_NOTES_FILE" ]]; then
    echo "Error: Unable to determine the currently installed Nitrox version."
    exit 1
  fi

  installed_version=$(awk -F " " '/-- Nitrox/ {print $3; exit}' "$PATCH_NOTES_FILE")

  if [[ -z "$installed_version" ]]; then
    echo "Error: Unable to determine the currently installed Nitrox version."
    exit 1
  fi

  echo "Currently installed Nitrox version: $installed_version"
}

function check_for_updates() {
  get_installed_version
  echo "Checking for updates..."

  response=$(curl -s "$API_URL")
  latest_version=$(echo "$response" | sed -n 's/.*"version":"\([^"]*\)".*/\1/p')

  if [[ -z "$latest_version" ]]; then
    echo "Error: Failed to retrieve the latest Nitrox version from $API_URL."
    exit 1
  fi

  echo "Latest Nitrox version available: $latest_version"

  # Check if update is needed
  if [[ "$latest_version" == "$installed_version" ]]; then
    echo "No updates available. Current version is up to date."
  else
    echo "Updating Nitrox to version $latest_version..."
    download_nitrox
    install_nitrox
    echo "Nitrox updated successfully to version $latest_version."
  fi
}

# Main script
check_and_create_directory
if [[ ! -f "$NITROX_LAUNCHER" ]]; then
  echo "Nitrox is not installed. Installing now..."
  download_nitrox
  install_nitrox
else
  if [[ -n "$NITROX_VERSION" ]]; then
    echo "NITROX_VERSION environment variable set, will not check for Nitrox updates."
    exit 0
  else
    check_for_updates
  fi
fi
