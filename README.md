# :skunk:
this is **not** an official kobotoolbox repository, okay?

# kobo (some) docker
*fighting complexity ~~with simplicity~~ by making humans do more work*

## goal
As a developer, I would like to run things I don't change inside Docker
(PostgreSQL, Redis, MongoDB, and—for now—Enketo Express). I would like full,
manual control over running code that I do change (kpi Python, kpi JS, kobocat
Python). I would like simplicity in configuration with sensible defaults and a
minimum of mandatory customization.

## to do
currently empty?!? :open_mouth:

## oh no :scream:
* some changes are currently needed to the kpi and kobocat codebases.
  `kpi.patch` and `kobocat.patch` in this repository contain those changes.
  apply them with `git apply`; e.g. in your `kpi` source directory, run `git
  apply < /path/to/kobo-no-docker/kpi.patch`. sorry.
* you have to manually create the directory `jsapp/compiled` inside your `kpi`
  source directory, otherwise `npm run watch` will fail on
  `ExtractTranslationKeysPlugin` with a `ENOENT`

## getting started
1. clone https://github.com/kobotoolbox/kpi and
   https://github.com/kobotoolbox/kobocat if you haven't already
    * :warning: You must check out kpi and kobocat as siblings of the same
      parent directory
1. `docker-compose up`, which should yield:
    * enketo running on 10.6.6.1:9002
    * postgres, on 10.6.6.1:60666
    * redis, on 10.6.6.1:60667
    * mongo, on 10.6.6.1:60668
1. `virtualenv kpienv && virtualenv kcenv`
    * tested with `CPython3.8.10.final.0-64`
1. install os-level dependencies (sorry): `sudo apt install python3-virtualenv gcc python3-dev gdal-bin libsqlite3-mod-spatialite`
    * more about GDAL [here](https://chat.kobotoolbox.org/#narrow/stream/4-Kobo-Dev/topic/kpi.20py.20packages/near/119776)
      (it's required during migrations. and it's only required then?)
    * `libsqlite3-mod-spatialite` is needed to run kobocat tests, or perhaps
      you could set `TEST_DATABASE_URL` and run them against a real Postgres
      database instead
    * you'll also need docker and docker-compose; tested with docker 20.10.12,
      docker-compose 1.25.0
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
    1. install npm version 8.5.5. downgrade if necessary.
    1. `npm install`
    1. `npm run watch`
        * are you lucky today? i am! `webpack 5.72.0 compiled successfully in 30238 ms`
1. set up a kobocat development environment!
    1. open a new terminal
    1. `. kcenv/bin/activate`
    1. `. envfile`
    1. `pip install pip-tools`
    1. `cd` into your kobocat source directory
    1. `pip-sync dependencies/pip/dev_requirements.txt`
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
        * fyi, when going backwards, django lingo for the migration before
          `0001` is `zero`
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
* some things just don't work without nginx (like serving attachments? need to
  confirm)
    * is ODK Collect able to make submissions at all?
* periodic tasks (`celery beat`) are completely ignored for the sake of
  simplicity
* `apt install gdal-bin` on the host unavoidable?
* "`pyuwsgi` is the exact same code as `uwsgi` but" actually has binary wheels?
    * it'd sure be nice not to compile uwsgi from source
        * then we could remove `gcc` and `python3-dev` requirements
    * https://github.com/unbit/uwsgi/issues/1218#issuecomment-463681335
* kpi copy fonts calls `python` not `python3` (fails; i have only `python2` and `python3`)
    * can be worked around by simply getting inside the kpi virtualenv before running
      `npm run copy-fonts`
* `npm install` above npm 8.5.5 always requires `--legacy-peer-deps`???

## can you use python 3.10?!
sure.
1. `sudo add-apt-repository ppa:deadsnakes/ppa`
1. `sudo apt install python3.10-full python3.10-dev`
1. `sudo apt install libpq-dev`, because psycopg2 >= 2.9
   [breaks everything](https://stackoverflow.com/a/68025007/2402324) and no
   `psycopg2-binary` exists for < 2.9 and Python 3.10
    * having `psycopg2-binary==2.8.6` in the requirements, as the `.patch`
      files do, should not cause a problem: `pip` will automatically fall back
      to building from source
1. create your virtualenv with `python3.10 -m venv kpienv3.10` instead of
   `virtualenv kpienv`
