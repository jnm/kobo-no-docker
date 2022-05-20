# kobo (some) docker
*fighting complexity with simplicity*

## goal
As a developer, I would like to run things I don't change inside Docker
(PostgreSQL, Redis, MongoDB, and—for now—Enketo Express). I would like full,
manual control over running code that I do change (kpi Python, kpi JS, kobocat
Python). I would like simplicity in configuration with sensible defaults and a
minimum of mandatory customization.

## to do
- [x] ~~celery always eager~~ done!

## oh no :scream:
some changes are currently needed to the kpi and kobocat codebases.
`kpi.patch` and `kobocat.patch` in this repository contain those changes.
apply them with `git apply`; e.g. in your `kpi` source directory, run
`git apply < /path/to/kobo-no-docker/kpi.patch`. sorry.

## getting started
1. clone https://github.com/kobotoolbox/kpi and
   https://github.com/kobotoolbox/kobocat if you haven't already
1. `docker-compose up`, which should yield:
    * enketo, on 10.6.6.1:9002
    * postgres running on 10.6.6.1:60666
    * redis, on 10.6.6.1:60667
    * mongo, on 10.6.6.1:60668
1. `virtualenv kpienv && virtualenv kcenv`
    * tested with `CPython3.8.10.final.0-64`
1. install os-level dependencies (sorry): `apt-get install gdal-bin`
1. set up a kpi (python) development environment!
    1. open a new terminal
    1. `. kpienv/bin/activate`
    1. `. envfile`
    1. `pip install pip-tools`
    1. `cd` into your kpi source directory
    1. `pip-sync dependencies/pip/dev_requirements.txt`
    1. `./manage.py migrate`
    1. `./manage.py runserver 10.6.6.1:9000`
        * :warning: not just any ol' `runserver`, okay?
1. set up a kpi (javascript) development environment!
    1. open a new terminal
    1. `cd` into your kpi source directory
    1. `nvm use 16`, or whatever you cool kids like
    1. `npm install --legacy-peer-deps`
    1. `npm install eslint eslint-plugin-react prettier --legacy-peer-deps`
        * i'm sorry.
        * also, installing prettier this way doesn't seem to solve
          ```
          ERROR in Failed to load config "prettier" to extend from.
          ```
        * terrible workaround: edit `node_modules/kobo-common/src/configs/.eslintrc.js`
          and remove `, 'prettier'` from `extends: ['eslint:recommended', 'prettier'],`
    1. `npm run watch`
        * are you lucky today? i am! `webpack 5.72.0 compiled successfully in 30238 ms`
1. set up a kobocat development environment!
    1. open a new terminal
    1. `. kcenv/bin/activate`
    1. `. envfile`
    1. `pip install pip-tools`
    1. `cd` into your kpi source directory
    1. `pip-sync dependencies/pip/dev.txt`
        * HEY! how about we make that consistent with kpi, eh?
    1. `./manage.py migrate`
    1. `./manage.py runserver 10.6.6.1:9001`
        * :nerd_face: didja see the `1` in `9001`?

:pie: "don't forget to manage your pie"

## hints
1. django is set to use the console email backend, so you can do things like
   create user accounts and read the activation email details right from the
   output of `./manage.py runserver 10.6.6.1:9000`
1. it might also be helpful to have a superuser account:
    1. go to the terminal where kpi `./manage.py runserver 10.6.6.1:9000` is
       running
    1. press ctrl+z to suspend `runserver`
    1. `./manage.py createsuperuser`
    1. once you're done, type `fg` and press enter to bring `runserver` back to
       the foreground
1. help! i want to switch branches!
    1. you're generally responsible for knowing how to use
       `./manage.py migrate` to apply database migrations (or revert them, by
       migrating backwards)
    1. let's say you'd like to back up your databases and start
       from scratch to avoid migration hassles:
        1. stop :warning: the database servers with `docker-compose stop`
        1. rename the `storage` directory to something else
        1. restart the database servers with `docker-compose up`
        1. check out the new branch you'd like to use
        1. for both kpi and kobocat, as described above, re-run
           `./manage.py migrate`
            * since you're starting from a completely empty database,
              you have to migrate both applications even if you only changed
              the branch for one of them
        1. you'll also have to recreate user accounts

## nasties
* enketo bad news `Parse Error: Expected HTTP/`
    * sometimes goes away after refreshing(?!)
* periodic tasks (`celery beat`) are completely ignored for the sake of
  simplicity
* `apt-get install gdal-bin` on the host unavoidable?
* kpi copy fonts calls `python` not `python3` (fails; i have only `python2` and `python3`)
* the wizard has not included a full inventory of his workshop
    * eslint not installed by `npm install` in kpi
    * `npm install --legacy-peer-deps eslint-plugin-react`
    * `npm install` requires `--legacy-peer-deps`??? (v16)
    * try installing prettier manually? (it didn't fix the issue)
      ```
      ERROR in Failed to load config "prettier" to extend from.
      Referenced from: /home/john/Local/kobo-dev/kpi/node_modules/kobo-common/src/configs/.eslintrc.js
      ```
