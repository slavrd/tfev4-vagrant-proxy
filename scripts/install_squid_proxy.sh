#!/usr/bin/env bash
# Provision script for Squid proxy instance
PKGS="squid wget curl"
which ${PKGS} || (
  sudo apt-get update -y -q
  sudo apt-get install -y -q ${PKGS}
  sudo cp /vagrant/config/squid.conf /etc/squid/squid.conf
  sudo systemctl restart squid.service
)
