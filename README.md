# TFE / Proxy Lab

A two node Vagrant project demonstrating TFE using HTTP proxy.

The Vagrant file defines two VMs

* `proxy` - has Squid proxy installed
* `tfe` - has TFE installed in poc mode using self-signed certificate. Installation is online.

## Prerequisites

* Have [Vagrant](https://www.vagrantup.com/downloads) installed.

## Building the environment

* place a valid TFE license file in `assets/tfe-license.rli`

* run `vagrant up`

At this point 

* TFE will be accessible on `https://192.168.56.33.xip.io`

* Replicated console will be accessible on `https://192.168.56.33.xip.io:8800` with password `Password123#`.

## Verifying that TFE uses the proxy

* connect to the proxy VM

  `vagrant ssh proxy`

* check the squid proxy logs for connection events

  `sudo cat /var/logs/squid/access.log`

  There should be messages that look like

  ```bash
  1592473627.586  13857 192.168.56.33 TCP_TUNNEL/200 17127096 CONNECT registry.replicated.com:443 - HIER_DIRECT/54.226.216.146 -
  1592473683.628    974 192.168.56.33 TCP_TUNNEL/200 4072 CONNECT checkpoint-api.hashicorp.com:443 - HIER_DIRECT/23.23.113.197 -
  ```
## TODO

- [ ] configure Squid proxy in SSL bumping mode and make TFE work