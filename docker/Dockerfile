FROM python:3.13.3-alpine3.21 AS base

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR /var/app

RUN python -m pip install --no-cache-dir \
    django \
    gunicorn


COPY ./docker/entrypoint.sh /usr/bin/django-entrypoint.sh

# From Docker documentation at https://docs.docker.com/reference/dockerfile/#cmd
# 
# If CMD is used to provide default arguments for the ENTRYPOINT instruction,
# both the CMD and ENTRYPOINT instructions should be specified in the exec form.
ENTRYPOINT ["/usr/bin/django-entrypoint.sh"]
CMD []
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "wget", "-O", "/dev/null", "http://127.0.0.1:8000"]

COPY . /var/app
