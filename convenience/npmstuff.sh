#!/bin/bash
set -e
loadnvm ()
{
    export NVM_DIR="$HOME/.nvm";
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}
cd ..
. kpienv/bin/activate
. envfile
cd ../kpi
node < /dev/null || loadnvm && echo 'loaded node via nvm 🙂'
npm install --legacy-peer-deps
npm run copy-fonts
npm run build
npm run watch
