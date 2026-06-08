#!/bin/bash
set -e

# Anchor everything to this script's location so cwd doesn't matter.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KPI_DIR="$SCRIPT_DIR/../../kpi"   # kobo-dev/kpi (one level up from kobo-no-docker)

# Resolve the Node version from kpi's package.json "engines.node" range.
# Online: exact latest published version (e.g. v22.22.3). Offline fallback:
# highest major prefix (e.g. v22), which nvm resolves to the latest installed
# match.
PKG="$KPI_DIR/package.json"
if NODE_VERSION="$(python3 "$SCRIPT_DIR/latest-node-engine.py" "$PKG")"; then
    echo "📌 kpi engines wants latest Node: $NODE_VERSION"
else
    NODE_VERSION="$(python3 "$SCRIPT_DIR/latest-node-engine.py" --fallback "$PKG")"
    echo "⚠️  couldn't reach Node dist index; falling back to major $NODE_VERSION"
fi

loadnvm ()
{
    export NVM_DIR="$HOME/.nvm";
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    # Fail (rather than auto-install) if nvm doesn't have this version.
    if ! nvm use "$NODE_VERSION"; then
        echo "🛑 Node $NODE_VERSION is not installed in nvm."
        echo "   Install it manually, then re-run:"
        echo "     nvm install $NODE_VERSION"
        exit 1
    fi
}

beginswith () {
    # https://stackoverflow.com/a/18558871
    case $2 in "$1"*) true;; *) false;; esac;
}

. "$SCRIPT_DIR/../kpienv/bin/activate"
. "$SCRIPT_DIR/../envfile"
cd "$KPI_DIR"

node < /dev/null &> /dev/null || loadnvm && echo 'loaded node via nvm 🙂'
beginswith "$NODE_VERSION" "$(node --version)" || (echo '🛑 wrong node version 😢'; exit 1)


if [ "$1" == "--install" ]; then
    npm install
fi
npm run copy-fonts
npm run watch
