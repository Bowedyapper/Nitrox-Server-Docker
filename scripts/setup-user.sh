#!/bin/sh

# Remove existing user
echo "Removing existing user..."
deluser nitrox || true
delgroup nitrox || true

# Create the user group
echo "Creating Nitrox user group with ID ${GROUP_ID}..."
addgroup -g ${GROUP_ID} nitrox

# Create the user
echo "Creating Nitrox user account with ID ${USER_ID}..."
adduser -G nitrox -u ${USER_ID} -h /software/nitrox -D nitrox

# Change the active user
echo "Switching to Nitrox user..."
su - nitrox