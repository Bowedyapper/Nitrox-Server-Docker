# Nitrox Server Docker

This repository provides a Docker image specifically for running the Nitrox server software on linux for the game Subnautica. You can use the prebuilt image or build your own custom image.

For more information about Nitrox, visit the official Nitrox website [here](https://nitrox.rux.gg/download).

This project is an updated version of the original [Nitrox server Docker project](https://gitlab.qub1.com/multimedia/games/subnautica/nitrox-server-docker), which appears to be abandoned. I have updated it to work with the latest version of Nitrox and made efforts to minimize the overall image size to around ~136 MB

## Disclaimer

Please note that this project is not affiliated with either the Nitrox or the Subnautica developers.

## Usage

You can run this Docker image using either `docker` or `docker-compose`. 

### Docker

To run the prebuilt image with Docker, execute the following command:

```shell
docker run \
  --name "nitrox" \
  --volume "/path/to/nitrox-data:/software/nitrox" \
  --volume "/path/to/subnautica:/software/subnautica" \
  --env "GROUP_ID=1000" \
  --env "USER_ID=1000" \
  --env "TIMEZONE=Etc/GMT" \
  --env "NITROX_VERSION=1.7.1.0" \
  --publish 11000:11000/udp \
  bowedyapper/nitrox-docker:latest
```

The `NITROX_VERSION` environment variable is optional and should only be used if you want to download a specific version and disable automatic updates.

Replace `/path/to/subnautica` with the path to your Subnautica installation directory. For Steam installations, the path will be something like: `/path/to/steam/steamapps/common/Subnautica`.

You can also install Subnautica using the `install_subnautica.sh` script in the `additional_scripts` directory.

If needed, replace the `GROUP_ID` and `USER_ID` with your own values to change the ownership permissions of the server data folder.

Replace `/path/to/nitrox-data` with a folder on the host machine where you would like to store the Nitrox data, including world data.

Set the timezone according to your own requirements for proper timestamps in the logs.

### Docker-Compose

To run the prebuilt image using Docker Compose, adjust the following `docker-compose.yml` file to meet your specific needs:

```docker
version: "3.4"
services:
    image: "bowedyapper/nitrox-docker:latest"
    restart: "unless-stopped"
    ports:
      - "11000:11000/udp" # Nitrox
    volumes:
      - "/path/to/nitrox-data:/software/nitrox" # Stores your server data, such as the configuration and world data
      - "/path/to/subnautica:/software/subnautica" # Stores Subnautica's game files - you will need to copy your own game directory here by moving the contents of your Subnautica installation directory to this volume
    environment:
      - "GROUP_ID=1000" # The ID of the group to run Nitrox as (default=1000)
      - "USER_ID=1000" # The ID of the user to run Nitrox as (default=1000)
      - "TIMEZONE=Etc/GMT" # The timezone to run Nitrox with (default=Etc/GMT)
#     - "NITROX_VERSION=1.7.1.0"
```

Save the `docker-compose.yml` file on your server and run `docker-compose up` from the same directory to start the server.

### Building and Using a Custom Image

If you prefer to build your own custom image, follow these steps:

1. Clone this repository to your local machine:

```shell
git clone https://github.com/Bowedyapper/Nitrox-Server-Docker.git
```

2. Navigate to the cloned repository:

```shell
cd Nitrox-Server-Docker
```

3. Build the Docker image using the provided Dockerfile:

```shell
docker build -t nitrox-docker .
```

4. Once the build is complete, you can use the newly built image with the same instructions provided in the previous sections. Replace the image name with `nitrox-docker`:

```shell
docker run \
  --name "nitrox" \
  --volume "/path/to/nitrox-data:/software/nitrox" \
  --volume "/path/to/subnautica:/software/subnautica" \
  --env "GROUP_ID=1000" \
  --env "USER_ID=1000" \
  --env "TIMEZONE=Etc/GMT" \
  --env "NITROX_VERSION=1.7.1.0" \
  --publish 11000:11000/udp \
  nitrox-docker
```

Alternatively, modify the `docker-compose.yml` file to use the `nitrox-docker` image instead:

```docker
version: "3.4"
services:
  nitrox:
    image: "nitrox-docker"
    restart: "unless-stopped"
    ports:
      - "11000:11000/udp" # Nitrox
    volumes:
      - "/path/to/nitrox-data:/software/nitrox" # Stores your server data, such as the configuration and world data
      - "/path/to/subnautica:/software/subnautica" # Stores Subnautica's game files - you will need to copy your own game directory here by moving the contents of your Subnautica installation directory to this volume
    environment:
      - "GROUP_ID=1000" # The ID of the group to run Nitrox as (default=1000)
      - "USER_ID=1000" # The ID of the user to run Nitrox as (default=1000)
      - "TIMEZONE=Etc/GMT" # The timezone to run Nitrox with (default=Etc/GMT)
#     - "NITROX_VERSION=1.7.1.0" # Specific version of Nitrox to install, will also disable auto-update comment out for latest version.
```

Save the modified `docker-compose.yml` file and run `docker-compose up` from the same directory to start the server using your custom image.