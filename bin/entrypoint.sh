#!/bin/ash

/app/tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
until /app/tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=office
do
    sleep 0.1
done

echo tailscale started

export ALL_PROXY=socks5://localhost:1055/
cd /opt/office/app && exec make run
