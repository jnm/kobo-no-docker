#!/bin/bash
cd ..
. kpienv/bin/activate
. envfile
cd ../kpi
./manage.py collectstatic --noinput
./manage.py runserver 10.6.6.1:9000
