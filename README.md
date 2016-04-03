[![Build Status](https://travis-ci.org/dmp1ce/decompose-web-common.svg?branch=master)](https://travis-ci.org/dmp1ce/decompose-web-common)
# decompose-web-common
Some common code for web development decompose environments

## Requirements

- [decompose](https://github.com/dmp1ce/decompose)
- [Docker](http://www.docker.com/)
- [decompose docker lib](https://github.com/dmp1ce/decompose-docker-common) (For updating production process)
- [decompose backup lib](https://github.com/dmp1ce/decompose-backup-common) (For updating production process)

## Install

Include this library and source `elements` and `processes` files your main decompose environment.

### Example

First add lib as a submodule to your environment:
``` bash
$ cd .decompose/environment
$ git submodule add https://github.com/dmp1ce/decompose-web-common.git lib/common
```

Then make your `processes` and `elements` file look like this:
``` bash
$ cat elements
# Include common elements
source $(_decompose-project-root)/.decompose/environment/lib/web/elements
$ cat processes
# Include common processes
source $(_decompose-project-root)/.decompose/environment/lib/web/processes
```

## Nginx Proxy

Nginx proxy, is a container which is a endpoint for web services running on port 80 with Docker. See [nginx proxy processes](#nginx-proxy-processes) for details on how to use nginx proxy with this environment. See [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) for more details on how the nginx proxy works. Custom nginx proxy images can be used by changing the `PROJECT_NGINX_PROXY_IMAGE` element.

Nginx proxy is configured by both adding environment variables to containers and by copying files into nginx proxy. For the file copying part, specially named files can be placed in `containers/nginx_proxy` directory. These files are explained in the `containers/nginx_proxy/README` file.

## Reverse Proxy

With an SSH server setup, a reverse proxy can be setup to tunnel a port to the SSH server. Use the [reverse proxy elements](#reverse-proxy-settings) and the `start-reverse-proxy` process to use this feature. In order to forward expose port 80 or 443 on the remote SSH server, you may have to configure `/etc/ssh/sshd_config` to set `GatewayPorts yes`.

A reverse proxy can be useful to test a API callbacks or show others local development.

## Update production

Use `update-production-server-to-latest` process to update a production server set by the [production server](#production-server) elements. Updating the production server using this method follows the following steps:

1. Test connection to server
2. Create new tag, incremented from the last tag
3. Push latest code and tags
4. Update code on production site
5. Rebuild/recreate production containers
6. Backup decompose configuration using `backup_config` process
7. Remove old Docker images using `remove-untagged-docker-images` process

## Elements

- `PROJECT_ENVIRONMENT` : The current environment. Only supports the values `development` or `production`. Default is `development`.

### Virtual host settings

- `PROJECT_NGINX_VIRTUAL_HOST` : The main domain name for the website. Default is `mysite.local`.
- `PROJECT_NGINX_VIRTUAL_HOST_ALTS` : All of the alternate domain names which are redirected to `PROJECT_NGINX_VIRTUAL_HOST` domain name. Multiple names are seperated by space (` `) character. Default is `www.mysite.local alt_mysite.local www.alt_mysite.local`
- `PROJECT_NGINX_DEFAULT_HOST` : The default virtual host to use for the nginx proxy.

### Source paths

These elements are used to make it easy to reference source files throughout the project.

- `PROJECT_SOURCE_PATH` : The relative path to the website source from the source Dockerfile. Default is `source`.
- `PROJECT_SOURCE_HOST_PATH` : The relative path to the website source from the decompose root. Default is `"./containers/source/"$PROJECT_SOURCE_PATH`.

### Production server

Production server settings. Used to ssh into the server and update the production code. These elements are empty by default.

- `PROJECT_PRODUCTION_SERVER_IP` : Production server IP.
- `PROJECT_PRODUCTION_SERVER_USER` : Production server user.
- `PROJECT_PRODUCTION_SERVER_BASE_PATH` : Relative source from user's home to decompose project root.

### Reverse proxy settings

Used to establish a reverse proxy for exposing website to the internet through a NAT.

- `PROJECT_WEBSITE_TO_EXPOSE_IP` : The local IP of the website to expose. Default is `localhost`.
- `PROJECT_WEBSITE_TO_EXPOSE_PORT` : The port of the local website to expose. Default is `443`.
- `PROJECT_REVERSE_PROXY_USER` : The ssh user of the reverse proxy server. Default is empty.
- `PROJECT_REVERSE_PROXY_IP` : The server IP of the reverse proxy. Default is empty.
- `PROJECT_REVERSE_PROXY_PORT` : The server port to expose the website on. Default is `44443`.

### Other elements

- `PROJECT_NGINX_PROXY_IMAGE` : Specify the nginx proxy image to use. Default is `jwilder/nginx-proxy`.
- `PROJECT_DOCKER_LOG_DRIVER` : Specify the Docker logging driver to use. Default is `journald`.

### Special elements

- `PRODUCTION` : Only set to `true` if `PROJECT_ENVIRONMENT` is equal to `production`.
- `DEVELOPMENT` : Only set to `true` if `PROJECT_ENVIRONMENT` is equal to `development`.

## Processes

- `env` : Print some web related variables such as current environment and VIRTUAL_HOST variables

### Nginx Proxy processes

See [nginx proxy section](#nginx-proxy).

- `start_nginx_proxy` : Starts nginx proxy container.
- `stop_nginx_proxy` : Stops nginx proxy container.
- `restart_nginx_proxy` : Restarts nginx proxy container.
- `generate_nginx_proxy_configs` : Generates nginx proxy configs based on what is in the nginx_proxy container folder.

### Other processes

- `start-reverse-proxy` : Starts reverse proxy. Will create an SSH connection. Exit out of SSH to terminate reverse proxy. See [reverse proxy section](#reverse-proxy).
- `update-production-server-to-latest` : Updates production environment using SSH commands. Requires [docker](https://github.com/dmp1ce/decompose-docker-common) and [backup](https://github.com/dmp1ce/decompose-backup-common) libs to be installed. See [update production](#update-production) section.
- `increment-tag` : Manually increment git tag if tags are fomated as `vA.B.C` where `A`, `B` and `C` are integers.
- `ssh_production` : SSH into production server.

### Other functions

These functions can be used inside your custom processes.

- `__decompose-process-update-production-repo` : Function to remotely update the production repository using SSH command.
- `__decompose-process-latest-version-tag` : Echo the latest version tag in the format `vA.B.C`
- `_decompose-process_nginx_proxy_id` : Echo the current nginx_proxy container ID.
- `_decompose-process_nginx_proxy_status` : Echo the current nginx_proxy container status.
- `_decompose-process_nginx_proxy_build` : Build nginx proxy container and generate nginx proxy configuration files.
- `_decompose-process_nginx_proxy_up` : Start nginx proxy no matter what state it is currently in and update configuration files in container.
