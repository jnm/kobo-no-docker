#!/bin/bash
# this is embarrassing, but i'm tired of messing with it
cmd1="./startkpi.sh ${@@Q}"
cmd2="./npmstuff.sh ${@@Q}"
cmd3="./startkc.sh ${@@Q}"
xpanes -de "$cmd1" "$cmd2" "$cmd3"
