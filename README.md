# Homelab Ansible
Stores Ansible config for `subract`'s homelab, to simplify management and enable easier service deployment.
Currently managing the following:

- A primary application server
	- Using [ZFS](https://openzfs.org/wiki/Main_Page) and [automated snapshots](roles/syncoid_sanoid/tasks/main.yml) with Sanoid for [functional immortality](https://github.com/jimsalterjrs/sanoid)
	- [Automated backups](roles/backblaze/tasks/main.yml) to Backblaze B2 for disaster recovery
	- ZFS-based full-disk encryption
	- [Tailscale](https://tailscale.com/) for seamless remote access
	- Docker [hosting the following](templates/cepheus
		- [Traefik](https://traefik.io/traefik/) - reverse proxy managing access to all web services. 
			- Providing TLS termination and automated certificates with [Let's Encrypt](https://letsencrypt.org/)
		- [Authelia](https://www.authelia.com/) - authentication and authorization server providing SSO
		- [Nextcloud](https://nextcloud.com/) - file storage and synchronization
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
		- [Pinchflat](https://github.com/kieraneglin/pinchflat) - archives YouTube channels
		- [Jellyfin](https://jellyfin.org/) - watch archived YouTube channels
		- [Bar Assistant](https://barassistant.app/) - manage home bar and cocktail recipes
		- [Open WebUI](https://openwebui.com/) - run chatbots with [ollama](https://ollama.com/)
		- [Beaver Habit Tracker](https://beaverhabits.com/) - simple, minimal habit tracking
		- [Homepage](https://gethomepage.dev/) - simple, static, and _secure_ dashboard
		- [Karakeep](https://karakeep.app/) - bookmarks and read-it-later

- A cloud VPS hosting [public services](templates/web01) to the Internet
	- [Minecraft servers](https://github.com/itzg/docker-minecraft-server) - a few different worlds for friends and family
	- [tModLoader](https://github.com/JACOBSMILE/tmodloader1.4) - modded Terraria server
	- [AdGuard Home](https://adguard.com/en/adguard-home/overview.html) - tailnet-wide ad blocking and custom DNS
	- [Peertube](https://joinpeertube.org/en_US) - YouTube alternative platform that supports ActivityPub federation
	- [Cryptpad](https://cryptpad.org/) - Google Docs alternative with E2E encryption
	- [Ghost](https://ghost.org) - personal blog
	- [immich-public-proxy](https://github.com/alangrainger/immich-public-proxy) - secure access to Immich photo/video shares
	- [ipinfo.tw](https://github.com/PeterDaveHello/ipinfo.tw) - simple IP check
	- [Mastodon](https://joinmastodon.org/) - (un)federated social media
	- [Vikunja](https://vikunja.io/) - to-dos and project management

This is a living repo, evolving as I add and manage additional services. As I tackle the challenges of managing additional systems, I'll expand this repo to include them.

## Development

This repo uses [pre-commit](https://pre-commit.com/) to run [ansible-lint](https://ansible-lint.readthedocs.io/) and [git-secrets](https://github.com/awslabs/git-secrets) before each commit. To set up the hooks:

```sh
pre-commit install
```