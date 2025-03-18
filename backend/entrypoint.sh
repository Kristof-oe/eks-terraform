#!/bin/sh

timeout=5 

if [ "$DATABASE" = "postgres" ]; then
    echo "Waiting for postgres..."

    while ! nc -z $DB_HOST $DB_PORT; do
      sleep 0.1
      timeout=$((timeout - 1))
        if [ $timeout -le 0 ]; then
            echo "PostgreSQL connection timed out"
            exit 1
        fi
    done

    echo "PostgreSQL started"
fi

echo "Running Django migrations..."
python manage.py makemigrations
python manage.py migrate 


exec "$@"