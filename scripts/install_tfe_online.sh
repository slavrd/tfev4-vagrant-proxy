#!/usr/bin/env bash
# installs replicated and pTFE

[ -v PTFE_PRIVATE_IP ] || PTFE_PRIVATE_IP="192.168.56.33"
[ -v PTFE_PUBLIC_IP ] || PTFE_PUBLIC_IP="192.168.56.33"

cp /vagrant/config/replicated.conf /etc/replicated.conf

curl -sS -o /tmp/install.sh https://install.terraform.io/ptfe/stable

if [ -v PROXY_ADDR ]; then
    bash /tmp/install.sh http-proxy=${PROXY_ADDR} private-address=${PTFE_PRIVATE_IP} public-address=${PTFE_PUBLIC_IP}
else
    bash /tmp/install.sh no-proxy private-address=${PTFE_PRIVATE_IP} public-address=${PTFE_PUBLIC_IP}
fi

while ! curl -ksfS --connect-timeout 5 https://localhost/_health_check >/dev/null 2>&1; do
    echo "==> Waiting for TFE to start..."
    sleep 30
done
