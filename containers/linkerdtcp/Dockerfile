FROM linkerd/linkerd-tcp:0.1.1

# Install envsubst
RUN apt-get update && apt-get install -y gettext

# Install tini
COPY --from=coldrye/debian-tini:0-14-0-jessie-20170224233049 /usr/local/sbin/tini /usr/local/sbin/tini

# Install gosu
COPY --from=scottabernethy/debian:latest /usr/local/bin/gosu /usr/local/bin/gosu

# Create a linkerd user
RUN adduser --no-create-home --disabled-password --quiet --gecos "User" linkerd

COPY containers/linkerdtcp/files /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["service"]
