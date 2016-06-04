#/bin/bash
#
#  Run this script for remove gbs-control scrtipts
#
DIR=$HOME
#sudo patch -bN -F 6 /etc/inittab $DIR/scripts/patch.inittab
sudo mv -f /etc/inittab.orig /etc/inittab
#sudo patch -bN -F 6 /etc/modules $DIR/scripts/patch.modules
sudo mv -f /etc/modules.orig /etc/modules
#sudo patch -bN -F 6 /etc/modprobe.d/raspi-blacklist.conf $DIR/scripts/patch.raspi-blacklist.conf
sudo mv -f /etc/modprobe.d/raspi-blacklist.conf.orig /etc/modprobe.d/raspi-blacklist.conf
#sudo patch -bN -F 6 /etc/default/triggerhappy $DIR/scripts/patch.triggerhappy
sudo mv -f /etc/default/triggerhappy.orig /etc/default/triggerhappy
#Move triggerhappy files to /etc/triggerhappy/triggers.d
sudo rm -f /etc/triggerhappy/triggers.d/*
#patch -bN -F 6 $DIR/.profile $DIR/scripts/patch.profile
sudo mv -f $DIR/.profile.orig $DIR/.profile

#sudo cp /boot/config.txt /boot/config.txt.bak
sudo mv -f /boot/config.txt.bak /boot/config.txt
#Remove folders
sudo rm -fR $DIR/{scripts,settings,thd,.gitattributes,.gitignore,README.md,adaptive_deinterlace.sh,changelog.txt,gbs-control.sh,install-gbs-control.sh}
#
echo -e "\nDone"
