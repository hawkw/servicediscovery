FROM python:3.6.3-alpine3.6

RUN set -x \

    # Use tini to forward signals and clean up zombies
    && apk add --no-cache tini \

    # Use su-exec to allow app to be pid 1
    su-exec \

    # Create the python user that will run our applications
    && adduser -H -D python

# Point python to our apps
ENV PYTHONPATH=/apps

# Install pips
COPY --chown=python:python apps/tests/requirements.txt /apps/requirements.txt
RUN pip install -r /apps/requirements.txt

COPY --chown=python:python apps/tests /apps/tests
COPY containers/tests/files /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["service"]
