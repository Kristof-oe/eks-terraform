#!/bin/sh

timeout=5 

for timeout in $(seq 5 -1 0);do

    echo "Postgre in progress...($timeout)"

    if nc -z $DB_HOST $DB_PORT; then
        echo "PostgreSQL started..."
        break
    fi
    sleep 1
    if [ $timeout -eq 0 ]; then
            echo "PostgreSQL connection timed out..."
            exit 1
        fi
    done

echo "Running Django migrations..."
python manage.py makemigrations
python manage.py migrate 


exec "$@"