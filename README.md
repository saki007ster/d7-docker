d7-docker
==================

This repo contains a recipe for making a Docker container running Drupal7, using Linux, Apache, MySQL, Memcache and SSH.
To use it, make sure you first [Install Docker](https://docs.docker.com/installation/).


### Download and install the docker toolbox from [here](https://www.docker.com/docker-toolbox)

## Get the image and run it using port 80:
```
docker run -i -t -p 80:80 saki007ster/drupal7
```
That's it!

### Credentials:
* Drupal account-name=admin & account-pass=admin
* ROOT SSH/MYSQL PASSWORD will be on /mysql-root-pw.txt
* DRUPAL   MYSQL_PASSWORD will be on /drupal-db-pw.txt

## How to go back to the last docker run?
```
docker ps -al
(get the container ID)
docker start -i -a (container ID)
```

## You can also clone this repo somewhere and build it,
```
git clone https://github.com/saki007ster/drupal7-docker-app.git
cd drupal7-docker-app
docker build -t <yourname>/drupal7 .
```
## Or build it directly from github,
```
docker build -t ricardo/drupal7 https://github.com/saki007ster/drupal7-docker-app.git
```

Note1: you cannot have port 80 already used or the container will not start. In that case you can start by setting: `-p 8080:80`

Note2: To run the container in the background
```
docker run -d -t -p 80:80 <yourname>/drupal7
```

## More docker awesomeness

This will create an ID that you can start/stop/commit changes:
```
# docker ps
ID            IMAGE                       COMMAND               CREATED             STATUS              PORTS
dda662a2a3f9  <yourname>/drupal7:latest   /bin/bash /start.sh   3 minutes ago       Up 6 seconds        80->80
```

Start/Stop
```
docker stop dda662a2a3f9
docker start dda662a2a3f9
```

Commit the actual state to the image
```
docker commit dda662a2a3f9 <yourname>/drupal7
```

Starting again with the commited changes
```
docker run -d -t -p 80:80 <yourname>/drupal7 /start.sh
```

Shipping the container image elsewhere
```
docker push  <yourname>/drupal7
```

You can find more images using the [Docker Index][docker_index].

### Clean up
While i am developing i use this to rm all old instances
```
docker ps -a | awk '{print $1}' | grep -v CONTAINER | xargs -n1 -I {} docker rm {}
```

### Known Issues
* Warning: This is still in development and ports shouldn't be open to the outside world.


## Contributing
Feel free to submit any bugs, requests, or fork and contribute to this code. :)

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

Created and maintained by [Saket Kumar][author]
http://saki007ster.github.io

## License
GPL v3

[author]:                 https://github.com/saki007ster
[docker_index]:           https://index.docker.io/

