#!/bin/sh
#
# Docker entrypoint for the production environment.

# Stop on first return of a non-zero status
# https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#The-Set-Builtin
set -e

# Run database migration
# This need to be first to avoid errors due missing tables
python3 manage.py migrate \
    --no-input \
    --traceback

# Create Django super user
echo Creating Django super user based on DJANGO_SUPERUSER_PASSWORD_FILE
if [ -f "$DJANGO_SUPERUSER_PASSWORD_FILE" ]
then
    export DJANGO_SUPERUSER_PASSWORD=$(cat $DJANGO_SUPERUSER_PASSWORD_FILE)
    createsuperuser.sh
fi

# Export all static files to a single place
python3 \
    manage.py \
    collectstatic \
    --no-input

# Start Django server
gunicorn \
    --bind 0.0.0.0:8000 \
    mwe.wsgi
