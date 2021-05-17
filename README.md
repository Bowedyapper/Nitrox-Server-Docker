# Nitrox Server Docker

A docker image that runs the Nitrox server software for the game Subnautica.

Visit the official website [here](https://nitrox.rux.gg/download).
You can find the original repository for this project [here](https://gitlab.qub1.com/multimedia/games/subnautica/nitrox-server-docker).

## Disclaimer

This project is not affiliated with either the Nitrox or the Subnautica developers.

## Usage

To run this image, you can either simply use docker or use docker-compose.

### Docker

To run the image using docker, use the following command:

```shell
docker run \
	--name "nitrox" \
	--volume "nitrox-data:/software/nitrox" \
	--volume "/path/to/subnautica:/software/subnautica" \
	--env "GROUP_ID=1000" \
	--env "USER_ID=1000" \
	--env "TIMEZONE=Etc/GMT" \
	qub1/nitrox-server:latest
```

Replace `/path/to/subnautica` with the path to the Subnautica installation directory, for steam this will be something like: `/path/to/steam/steamapps/common/Subnautica`.
Replace the group ID and user ID with your own if needed, this will change the ownership permissions of the server data folder.
Set the timezone to your own for proper timestamps in the logs.

### Docker-Compose

To run the image using docker-compose, adjust [this docker-compose file](https://gitlab.qub1.com/multimedia/games/subnautica/nitrox-server-docker/-/blob/master/docker-compose.yml) to your needs.
Place the `docker-compose.yml` file somewhere on your server and run `docker-compose up` in the same directory to start the server.

### Server Configuration

You can find your server files including the configuration files in the `nitrox-data` volume.
Docker volumes are usually stored in `/var/docker/volumes`.
