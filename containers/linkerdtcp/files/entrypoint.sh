#!/usr/bin/env sh

# Grab the host's IP so we can talk to other running containers
export HOST_IP=`/sbin/ip route|awk '/default/ { print $3 }'`

# Do some environment substitutions for linkerd config
envsubst < /etc/linkerd/linkerd.yaml.template > /etc/linkerd/linkerd.yaml

# Run linkerd if we see the command
if [ "$1" = "service" ]; then
  exec gosu linkerd tini -- linkerd-tcp /etc/linkerd/linkerd.yaml

# Run whatever command was provided by the user
else
  exec "$@"
fi
