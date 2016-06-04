#!/bin/bash
# This file use for start control manually
DIR=$HOME
sudo python $DIR/scripts/rawProg.py $DIR/scripts/start.txt
sudo python $DIR/scripts/regProg.py $DIR/settings/defaults/pi.set
sudo bash $DIR/gbs-control.sh
