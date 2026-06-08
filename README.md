# :skunk:
this is **not** an official kobotoolbox repository, okay?

# kobo (some) docker
*fighting complexity ~~with simplicity~~ by making humans do more work*

## goal
As a developer, I would like to run things I don't change inside Docker
(PostgreSQL, Redis, MongoDB, and—for now—Enketo Express). I would like full,
manual control over running code that I do change (kpi Python and kpi JS). I
would like simplicity in configuration with sensible defaults and a minimum of
mandatory customization.

## to do
currently empty?!? :open_mouth:

## getting started
1. clone https://github.com/kobotoolbox/kpi if you haven't already
1. `docker-compose up`, which should yield:
    * nginx listening at 10.6.6.1 on port 9000
        * this will reverse-proxy to kpi because the application does not run
          properly without nginx
    * enketo running on 10.6.6.1:9001
    * postgres, on 10.6.6.1:60666
    * redis, on 10.6.6.1:60667
    * mongo, on 10.6.6.1:60668
1. install os-level dependencies (sorry):
   `sudo apt install python3.10-venv gcc python3-dev gdal-bin libpq-dev`
    * more about GDAL [here](https://chat.kobotoolbox.org/#narrow/stream/4-Kobo-Dev/topic/kpi.20py.20packages/near/119776)
      (it's required during migrations. and it's only required then?)
    * you'll also need docker and the compose plugin; tested with docker
      27.2.1 and compose 2.29.2
1. `python3 -m venv kpienv`
    * tested with Python 3.10.12 on Ubuntu 22.04
1. set up a **python** development environment for kpi!
    1. `. kpienv/bin/activate`
    1. `. envfile`
    1. `pip install pip-tools`
    1. `cd` into your kpi source directory
    1. `pip-sync dependencies/pip/dev_requirements.txt`
    1. `scripts/migrate.sh`
    1. `./manage.py runserver 10.6.6.1:9010`
        * :warning: not just any ol' `runserver`, okay?
1. set up a **javascript** development environment for kpi!
    1. open a new terminal
    1. `cd` into your kpi source directory
    1. `nvm use 20.17.0`, or whatever you cool kids like
    1. `npm install`
    1. `npm run watch`
        * are you lucky today? i am! `webpack 5.92.1 compiled successfully in 16285 ms`

:pie: "don't forget to manage your pie"

## hints
1. django is set to use the console email backend, so you can do things like
   create user accounts and read the activation email details right from the
   output of `./manage.py runserver 10.6.6.1:9010`
1. it might also be helpful to have a superuser account:
    1. go to the terminal where kpi `./manage.py runserver 10.6.6.1:9010` is
       running
    1. press ctrl+z to suspend `runserver`
    1. `./manage.py createsuperuser`
    1. once you're done, type `fg` and press enter to bring `runserver` back to
       the foreground
1. help! i want to switch branches!
    1. you're generally responsible for knowing how to use
       `./manage.py migrate` and its wrapper `scripts/migrate.sh` to apply
       database migrations (or revert them, by migrating backwards)
        * fyi, when going backwards, django lingo for the migration before
          `0001` is `zero`
    1. let's say you'd like to back up your databases and start
       from scratch to avoid migration hassles:
        1. stop :warning: the database servers with `docker-compose stop`
        1. rename the `storage` directory to something else
        1. restart the database servers with `docker-compose up`
        1. check out the new branch you'd like to use
        1. re-run `scripts/migrate.sh`
        1. you'll also have to recreate user accounts

## nasties
* periodic tasks (`celery beat`) are completely ignored for the sake of
  simplicity
* `apt install gdal-bin` on the host unavoidable?
* "`pyuwsgi` is the exact same code as `uwsgi` but" actually has binary wheels?
    * it'd sure be nice not to compile uwsgi from source
        * then we could remove `gcc` and `python3-dev` requirements
    * https://github.com/unbit/uwsgi/issues/1218#issuecomment-463681335
* `psycopg2-binary` ["is a practical choice for development and testing but in
  production it is advised to use the package built from sources."](https://github.com/psycopg/psycopg2#installation)
    * the "why" is described [here](https://web.archive.org/web/20201111224247/https://www.psycopg.org/articles/2018/02/08/psycopg-274-released/)
    * for now, this means `libpq-dev` must be installed to avoid messing with
      Python requirements
