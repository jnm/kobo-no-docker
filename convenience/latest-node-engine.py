#!/usr/bin/env python3
"""
🤖🤖🤖
Resolve a Node.js version from a package.json's "engines.node" range
(e.g. "^20.18.1 || ^22.4.1").

Default mode (online): print the latest *published* version satisfying the
range, queried from the canonical Node dist index (e.g. "v22.22.3").

--fallback mode (offline): print just the highest acceptable major as a prefix
(e.g. "v22"), derived purely from the range with no network. Intended as a
loose target: `nvm use v22` picks the latest installed v22, and a prefix match
(beginswith) confirms it.

Usage: latest-node-engine.py [--fallback] path/to/package.json
"""
import json, re, sys, urllib.request

DIST_INDEX = "https://nodejs.org/dist/index.json"


def parse_ver(s):
    return tuple(int(x) for x in s.split("."))


def parse_comparator(comp):
    """Return (predicate, base_version_tuple) for one semver comparator, or None.

    Handles ^, ~, >=, >, <=, <, and bare "=".
    """
    comp = comp.strip()
    m = re.match(r'^([\^~]|>=|>|<=|<|=)?\s*v?(\d+)\.(\d+)\.(\d+)', comp)
    if not m:
        return None
    op = m.group(1) or "="
    maj, minr, pat = int(m.group(2)), int(m.group(3)), int(m.group(4))
    base = (maj, minr, pat)
    if op == "^":   # >=base, same major
        pred = lambda v: v >= base and v[0] == maj
    elif op == "~":   # >=base, same major.minor
        pred = lambda v: v >= base and v[:2] == (maj, minr)
    elif op == ">=":
        pred = lambda v: v >= base
    elif op == ">":
        pred = lambda v: v > base
    elif op == "<=":
        pred = lambda v: v <= base
    elif op == "<":
        pred = lambda v: v < base
    else:
        pred = lambda v: v == base
    return pred, base


def parse_range(rng):
    """Parse an engines.node range into (satisfies_fn, base_versions list)."""
    ranges = []      # list of AND-ed predicate lists, OR-ed together
    bases = []       # every comparator's base version, for the offline fallback
    for part in rng.split("||"):
        preds = []
        for c in part.split():
            parsed = parse_comparator(c)
            if parsed:
                preds.append(parsed[0])
                bases.append(parsed[1])
        if preds:
            ranges.append(preds)
    satisfies = lambda v: any(all(p(v) for p in preds) for preds in ranges)
    return satisfies, bases


def main():
    args = sys.argv[1:]
    fallback = "--fallback" in args
    args = [a for a in args if a != "--fallback"]
    if len(args) != 1:
        sys.exit("usage: latest-node-engine.py [--fallback] path/to/package.json")

    with open(args[0]) as f:
        rng = json.load(f)["engines"]["node"]
    satisfies, bases = parse_range(rng)

    if not bases:
        sys.exit("could not parse engines.node range '%s'" % rng)

    if fallback:
        # Offline: highest acceptable major, as a prefix for nvm + beginswith.
        print("v%d" % max(bases)[0])
        return

    with urllib.request.urlopen(DIST_INDEX, timeout=30) as r:
        published = json.load(r)

    best = None
    for entry in published:
        v = parse_ver(entry["version"].lstrip("v"))
        if satisfies(v) and (best is None or v > best):
            best = v

    if best is None:
        sys.exit("no published Node version satisfies '%s'" % rng)
    print("v" + ".".join(map(str, best)))


if __name__ == "__main__":
    main()
