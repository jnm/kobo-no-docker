### Assumptions

* Your kpi virtualenv is in `../kpienv`
* Your kpi source code is in `../../kpi`
* You have tmux and xpanes installed

### Running development servers
* `startkpi.sh`: gets a kpi python development server running
* `npmstuff.sh`: starts up `npm run watch` and friends for kpi
* `all3.sh`: does all of the above simultaneously in three window panes

### Getting environments to run `./manage.py` and stuff
These are pretty basic; just read the code:
* `kpienv_activate` 

NB: Use these with `source`, aka `.`; don't try to execute them.
For example, `. kpienv_activate`.
