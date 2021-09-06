# Docker container management with Traefik v2 and Portainer

A configuration set-up for a Traefik v2 reverse proxy along with Portainer and Docker Compose.

This set-up makes container management & deployment a breeze and the reverse proxy allows for running multiple applications on one Docker host. Traefik will route all the incoming traffic to the appropriate docker containers and through the open-source app Portainer you can speed up software deployments, troubleshoot problems and simplify migrations.

Detailed explanation how to use this in my blog post:
[Docker container management with Traefik v2 and Portainer](https://rafrasenberg.com/posts/docker-container-management-with-traefik-v2-and-portainer/)

## Setting

add docker network

`docker network create traefik-proxy`

core/docker-compose.yml

- change `traefik.YOURDOMAIN.com` and `portainer.YOURDOMAIN.com`

vloumes/traefik/traefik.yml

change 

```
certificatesResolvers:
  letsencrypt:
    acme:
      email: tech@YOURDOMAIN.com
```

vloumes/traefik/acme.json

```
sudo chmod 600 acme.json
```

### change basic auth

https://www.web2generators.com/apache-tools/htpasswd-generator

vloumes/traefik/traefik.yml

change 

```
user-auth:
      basicAuth:
        users:
          - "NEW_AUTH_STRING"
```

## How to run it?

```
$ git clone git@github.com:ame1973/docker-traefik-portainer.git
$ cd docker-traefik-portainer/core

# update setting

$ docker-compose up -d
```