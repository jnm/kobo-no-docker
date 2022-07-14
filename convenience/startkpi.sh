#!/bin/bash
cd ..
. kpienv/bin/activate
. envfile
cd ../kpi
if [ "$1" == "--install" ]; then
    pip-sync dependencies/pip/dev_requirements.txt
fi
./manage.py collectstatic --noinput
./manage.py runserver 10.6.6.1:9000
