#!/bin/bash
cd ..
. kpienv/bin/activate
. envfile
cd ../kpi
if [ "$1" == "--install" ]; then
    pip-sync dependencies/pip/dev_requirements.txt
fi
./manage.py collectstatic --noinput
echo -ne "\033[7m"
echo "🥸                                                               🥸"
echo "🥸                       Welcome to KPI                          🥸"
echo "🥸                                                               🥸"
echo "🥸 Hey, hey, I know: you're smart, and you're wondering,         🥸"
echo "🥸 \"Why can't I just go directly to http://10.6.6.1:9010?\"       🥸"
echo "🥸 Great question! You could, and a lot of things would be fine. 🥸"
echo "🥸 However, some things break without NGINX! For that reason,    🥸"
echo -n "🥸 please go only to "
echo -ne "\033[0m\033[1;4m==> http://10.6.6.1:9000/ <==\033[0m\033[7m"  # READ about how to do this properly
echo " instead.      🥸"
echo "🥸 Thanks!                                                       🥸"
echo "🥸                                                               🥸"
echo -ne "\033[0m"
./manage.py runserver 10.6.6.1:9010
