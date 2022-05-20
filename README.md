# kobo (some) docker
*fighting complexity with simplicity*

## goal
As a developer, I would like to run things I don't change inside Docker (PostgreSQL, Redis, MongoDB, and—for now—Enketo Express).
I would like full, manual control over running code that I do change (kpi Python, kpi JS, kobocat Python).
I would like simplicity in configuration with sensible defaults and a minimum of mandatory customization.

## to do
* celery always eager

## nasties
* `apt-get install gdal-bin` on the host unavoidable?
* kpi copy fonts calls `python` not `python3` (fails)
* the wizard has not included a full inventory of his workshop
    * eslint not installed by `npm install` in kpi
    * `npm install --legacy-peer-deps eslint-plugin-react`
    * `npm install` requires `--legacy-peer-deps`??? (v16)
    * try installing prettier manually?
      ```
      ERROR in Failed to load config "prettier" to extend from.
      Referenced from: /home/john/Local/kobo-dev/kpi/node_modules/kobo-common/src/configs/.eslintrc.js
      ```
