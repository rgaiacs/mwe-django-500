#!/bin/sh
#
# Create Django super user.

if [ -n "$DJANGO_SUPERUSER_PASSWORD" ]
then
    echo Creating Django super user based on DJANGO_SUPERUSER_PASSWORD

    # This requires the environment variables
    #
    # DJANGO_SUPERUSER_USERNAME
    # DJANGO_SUPERUSER_EMAIL
    # DJANGO_SUPERUSER_PASSWORD
    #
    # used to create Django super user to be configured.
    # https://docs.djangoproject.com/en/5.1/ref/django-admin/#createsuperuser
    python3 manage.py createsuperuser \
        --no-input || true

    # Reset Django super user password
    # for the case that data has been imported.
    python3 manage.py shell <<EOF
import os

from django.contrib.auth.models import User

username = os.environ["DJANGO_SUPERUSER_USERNAME"]
password = os.environ["DJANGO_SUPERUSER_PASSWORD"]

user = User.objects.get(username=username)
user.set_password(password)
user.save()
EOF
else
    echo Environment variable DJANGO_SUPERUSER_PASSWORD is not defined!
    echo Skipping creation of Django super user.
fi
