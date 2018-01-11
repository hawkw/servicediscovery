#!/usr/bin/env sh

# Set environment variables for namerd
export JVM_HEAP_MIN="${INITIAL_HEAP_SIZE:-64}m"
export JVM_HEAP_MAX="${MAX_HEAP_SIZE:-128}m"

# Optimize JVM for namerd
export JVM_OPTIONS=`echo "  -XX:InitialHeapSize=${JVM_HEAP_MIN}
  -XX:MaxHeapSize=${JVM_HEAP_MAX}
  -XX:MaxDirectMemorySize=${JVM_HEAP_MAX}
  -Djava.net.preferIPv4Stack=true
  -Dsun.net.inetaddr.ttl=60
  -XX:+AggressiveOpts
  -XX:+UseConcMarkSweepGC
  -XX:+CMSParallelRemarkEnabled
  -XX:+CMSClassUnloadingEnabled
  -XX:+ScavengeBeforeFullGC
  -XX:+CMSScavengeBeforeRemark
  -XX:+UseCMSInitiatingOccupancyOnly
  -XX:CMSInitiatingOccupancyFraction=70
  -XX:-TieredCompilation
  -XX:+UseStringDeduplication
  $JVM_OPTIONS
"|tr '\n' ' '`

# Grab the host's IP so we can talk to other running containers
export HOST_IP=`/sbin/ip route|awk '/default/ { print $3 }'`

# Do some environment substitutions for namerd if we are running namerd
envsubst < /etc/namerd/namerd.yaml.template > /etc/namerd/namerd.yaml

# Run namerd if we see the command
if [ "$1" = "service" ]; then
  exec su-exec namerd /sbin/tini -- namerd /etc/namerd/namerd.yaml

# Run whatever command was provided by the user
else
  exec "$@"
fi
