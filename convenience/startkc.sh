#!/bin/bash
cd ..
. kcenv/bin/activate
. envfile
cd ../kobocat
if [ "$1" == "--install" ]; then
    pip-sync dependencies/pip/dev_requirements.txt
fi
./manage.py collectstatic --noinput
echo "🥸                                                               🥸"
echo "🥸                     Welcome to KoboCAT                        🥸"
echo "🥸                                                               🥸"
echo "🥸 Hey, hey, I know: you're smart, and you're wondering,         🥸"
echo "🥸 \"Why can't I just go directly to http://10.6.6.1:9011?\"       🥸"
echo "🥸 Great question! You could, and a lot of things would be fine. 🥸"
echo "🥸 However, some things break without NGINX! For that reason,    🥸"
echo -n "🥸 please go only to "
echo -ne "\033[1;4m==> http://10.6.6.1:9001/ <==\033[0m"
echo " instead.      🥸"
echo "🥸 Thanks!                                                       🥸"
echo "🥸                                                               🥸"
./manage.py runserver 10.6.6.1:9011
