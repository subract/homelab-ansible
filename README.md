# Homelab Ansible
Stores Ansible config for `subract`'s homelab, to simplify management and enable easier service deployment.
Currently managing the following:

- A primary application server
	- Using [ZFS](https://openzfs.org/wiki/Main_Page) and [automated snapshots](roles/syncoid_sanoid/tasks/main.yml) with Sanoid for [functional immortality](https://github.com/jimsalterjrs/sanoid)
	- [Automated backups](roles/backblaze/tasks/main.yml) to Backblaze B2 for disaster recovery
	- ZFS-based full-disk encryption
	- [Tailscale](https://tailscale.com/) for seamless remote access
	- Docker [hosting the following](templates/cepheus)
		- [Traefik](https://traefik.io/traefik/) - reverse proxy managing access to all web services
			- Providing TLS termination and automated certificates with [Let's Encrypt](https://letsencrypt.org/)
		- [Authelia](https://www.authelia.com/) - authentication and authorization server providing SSO
			- Backed by [lldap](https://github.com/lldap/lldap) - lightweight LDAP server
		- [Nextcloud](https://nextcloud.com/) - file storage and synchronization
			- With [Collabora](https://www.collaboraonline.com/) - online office suite for document editing
		- [Immich](https://immich.app/) - Google Photos replacement
		- [Gitea](https://gitea.io/en-us/) - lightweight Git hosting
		- [Drone](https://www.drone.io/) - continuous integration platform handling deployments
		- [Home Assistant](https://www.home-assistant.io/) - smart home management
			- Supported by [Zigbee2MQTT](https://www.zigbee2mqtt.io) and [Mosquitto](https://mosquitto.org/)
		- [Node-RED](https://nodered.org/) - visual scripting for home automation and sundry other tasks
		- [CyberChef](https://github.com/gchq/CyberChef) - "Cyber Swiss Army Knife" - handy for random operations
		- [it-tools](https://it-tools.tech/) - similar to CyberChef, but focused on a different set of sysadmin-y tasks
		- [Miniflux](https://miniflux.app/) - minimalist RSS feed reader ingesting ~70 feeds
		- [Paperless-ngx](https://docs.paperless-ngx.com/) - document management system to digitize documents
		- [Changedetection.io](https://changedetection.io/) - monitors web pages for changes
		- [Jellyfin](https://jellyfin.org/) - media server
		- [Navidrome](https://www.navidrome.org/) - music streaming server
		- [Bar Assistant](https://barassistant.app/) - manage home bar and cocktail recipes
		- [Open WebUI](https://openwebui.com/) - run chatbots with [ollama](https://ollama.com/)
		- [Homepage](https://gethomepage.dev/) - simple, static, and _secure_ dashboard
		- [Karakeep](https://karakeep.app/) - bookmarks and read-it-later
		- [HedgeDoc](https://hedgedoc.org/) - collaborative markdown notes
		- [copyparty](https://github.com/9001/copyparty) - portable file server
		- [Dawarich](https://dawarich.app/) - location history
		- [Webtop](https://docs.linuxserver.io/images/docker-webtop/) - Linux desktop in the browser
		- Game servers: [Minecraft](https://github.com/itzg/docker-minecraft-server), [Factorio](https://github.com/factoriotools/factorio-docker), and [Vintage Story](https://github.com/devidian/docker-vintagestory)
		- [Newt](https://github.com/fosrl/newt) - tunnel client connecting to the Pangolin VPS

- An auxiliary server hosting [local services](templates/larkhaven)
	- [Frigate](https://frigate.video/) - NVR with AI object detection for security cameras
	- Plus mirrors of the core stack: Traefik, Authelia, Nextcloud, Paperless-ngx, Home Assistant, and Homepage

- A cloud VPS exposing [public services](templates/web03) to the Internet
	- [Pangolin](https://github.com/fosrl/pangolin) - identity-aware tunneling reverse proxy providing secure access to self-hosted services
	- [ipinfo.tw](https://github.com/PeterDaveHello/ipinfo.tw) - simple IP check

This is a living repo, evolving as I add and manage additional services. As I tackle the challenges of managing additional systems, I'll expand this repo to include them.

## Development

This repo uses [pre-commit](https://pre-commit.com/) to run [ansible-lint](https://ansible-lint.readthedocs.io/) and [git-secrets](https://github.com/awslabs/git-secrets) before each commit. To set up the hooks:

```sh
pre-commit install
```
