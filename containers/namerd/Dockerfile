FROM i386/alpine:3.6

# Install gettext so we can grab envsubst
RUN apk add --no-cache gettext

# Use 32bit OS to save on Java's memory requirements
FROM i386/alpine:3.6

# Copy envsubst without all the build dependencies
COPY --from=0 /usr/bin/envsubst /usr/bin/envsubst

# Default to UTF-8 file.encoding
ENV LANG=C.UTF-8

# Set java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ARG JAVA_ALPINE_VERSION=8.131.11-r2
ARG NAMERD_VERSION=1.2.0
ARG NAMERD_URL=https://github.com/linkerd/linkerd/releases/download/$NAMERD_VERSION/namerd-$NAMERD_VERSION-exec
ARG NAMERD_SHA256SUM=9bd837723b664cfde8385c60ccc50af2fcbacadbc6a169843eb86b7daa960c57

RUN set -x \

    # Install java
    && apk add --no-cache openjdk8="$JAVA_ALPINE_VERSION" \

    # Install tini to clean up java processes
    tini \

    # Use su-exec to allow app to be pid 1 under the namerd user
    su-exec \

    # Install openssl so we can connect to HTTPS
    openssl \

    # We need libintl to run envsubst
    libintl \

    # Install namerd
    && mkdir /opt \
    && wget -O /opt/namerd-$NAMERD_VERSION-exec $NAMERD_URL \
    && chmod +x /opt/namerd-$NAMERD_VERSION-exec \
    && echo "$NAMERD_SHA256SUM  /opt/namerd-$NAMERD_VERSION-exec" | sha256sum -c - \
    && ln -s /opt/namerd-$NAMERD_VERSION-exec /usr/bin/namerd \

    # Create a non-root user just for running namerd
    && adduser -H -D namerd

COPY containers/namerd/files /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["service"]
