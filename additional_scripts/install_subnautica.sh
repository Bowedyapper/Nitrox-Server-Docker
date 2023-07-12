#!/bin/bash
# This script will allow you to install Subnautica on a Linux system, you must have SteamCMD installed first
clear
echo -e "Subnautica Steam Installer for Linux\n"

which steamcmd >/dev/null 2>&1 || { 
  echo "SteamCMD is not installed. Please install SteamCMD before trying to install Subnautica";
  echo "You can see installation instuctions here: https://developer.valvesoftware.com/wiki/SteamCMD#Linux"
  exit 1;
}


# Prompt the user for the installation directory
while true; do
  read -p "Enter the installation directory for Subnautica: " install_dir
  if [ -z "$install_dir" ]; then
    echo -e "\033[0;31mError: Installation directory cannot be empty.\033[0m"
  else
    break
  fi
done


# Prompt the user for the username
while true; do
  read -p "Enter your Steam username: " user_name
  if [ "$user_name" == "anonymous" ]; then
    echo -e "\033[0;31mError: You must login with an account that owns Subnautica, anonymous cannot download the game.\033[0m"
  elif [[ -z "$user_name" ]]; then
    echo -e "\033[0;31mError: Username cannot be empty.\033[0m"
  else
    break
  fi
done

# Prompt the user for the password (it won't be visible while typing)
while true; do
  read -s -p "Enter your Steam password: " password
  if [ -z "$password" ]; then
    echo -e "\n\033[0;31mError: Password cannot be blank.\033[0m"
  else
    break
  fi
done

echo -e "\n"

# Run the SteamCMD command with the provided input
steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "$install_dir" +login "$user_name" "$password" +app_update 264710 -beta legacy +quit

steamcmd_exit_code=$?
echo -e "\n"
# Check the exit code of the steamcmd command
if [ $steamcmd_exit_code -eq 0 ]; then
  echo -e "\nDone. Make sure to set your Subnautica install folder by changing\n\"/path/to/subnautica:/software/subnautica\" to \"$install_dir:/software/subnautica\"\nin either the docker run command or your docker-compose.yml file"

elif [ $steamcmd_exit_code -eq 5 ]; then
    echo "It seems there was an issue logging into steam, it could be that you are rate limited, username or password is incorrect or the 2FA code was wrong"

elif [ $steamcmd_exit_code -eq 6 ]; then
    echo "Subnautica was already up to date"

elif [ $steamcmd_exit_code -eq 8 ]; then
    echo "Oops, steam says you don't own this game, please buy it before trying again"

else
  echo -e "\nError: Installation failed"

fi