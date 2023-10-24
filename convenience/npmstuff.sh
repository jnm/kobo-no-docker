#!/bin/bash
set -e

NODE_VERSION='v16.15.0'
NPM_VERSION='8.5.5'

loadnvm ()
{
    export NVM_DIR="$HOME/.nvm";
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm use "$NODE_VERSION"
}

beginswith () {
    # https://stackoverflow.com/a/18558871
    case $2 in "$1"*) true;; *) false;; esac;
}

cd ..
. kpienv/bin/activate
. envfile
cd ../kpi

node < /dev/null &> /dev/null || loadnvm && echo 'loaded node via nvm 🙂'
beginswith "$NODE_VERSION" "$(node --version)" || (echo '🛑 wrong node version 😢'; exit 1)
beginswith "$NPM_VERSION" "$(npm --version)" || (echo '🛑 wrong npm version 😢'; exit 1)


if [ "$1" == "--install" ]; then
    npm install  # --legacy-peer-deps (needed above npm 8.5.5?)
fi
npm run copy-fonts
npm run watch
