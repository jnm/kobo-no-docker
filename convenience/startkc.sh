#!/bin/bash
cd ..
. kcenv/bin/activate
. envfile
cd ../kobocat
./manage.py collectstatic --noinput
./manage.py runserver 10.6.6.1:9001
