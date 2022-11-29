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
if [ "$1" == "--install" ]; then
    npm install  # --legacy-peer-deps (needed above npm 8.5.5?)
fi
npm run copy-fonts
npm run watch
