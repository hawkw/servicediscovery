#!/usr/bin/env sh
set -e

# Run service if we see the command
if [ "$1" = "service" ]; then

    exec su-exec python /sbin/tini -- pytest /apps/tests

fi

# Otherwise run whatever command provided by the user
exec "$@"
