#!/bin/bash
cd ..
. kcenv/bin/activate
. envfile
cd ../kobocat
if [ "$1" == "--install" ]; then
    pip-sync dependencies/pip/dev.txt
fi
./manage.py collectstatic --noinput
./manage.py runserver 10.6.6.1:9001
