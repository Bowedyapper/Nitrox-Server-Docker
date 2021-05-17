# Nitrox Server Docker

A docker image that runs the Nitrox server software for the game Subnautica.
Visit the official website at: https://nitrox.rux.gg/download

## Disclaimer

This project is not affiliated with either the Nitrox or the Subnautica developers.

## Usage

To run this image, you can either simply use docker or use docker-compose.

### Docker

To run the image using docker, use the following command:

```shell
docker run --volume "nitrox-data:/software/nitrox" --volume "/path/to/subnautica:/software/subnautica" qub1/nitrox-server:latest
```

Replace `/path/to/subnautica` with the path to the Subnautica installation directory.
For steam this will be something like: `/path/to/steam/steamapps/common/Subnautica`.

### Docker-Compose

To run the image using docker-compose, adjust the docker-compose file found here to your needs: [https://gitlab.qub1.com/multimedia/games/subnautica/nitrox-server-docker/-/blob/master/docker-compose.yml](https://gitlab.qub1.com/multimedia/games/subnautica/nitrox-server-docker/-/blob/master/docker-compose.yml).
Place the `docker-compose.yml` file somewhere on your server and run `docker-compose up` in the same directory to start the server.
