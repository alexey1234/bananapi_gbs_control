#!/bin/ash
# Install script for Trueview 5725 control (GBS8200, GBS8220, HD9000, HD Box Pro etc)

DIR=$HOME
echo -e "\nInstall location is: "$DIR

# Update sources and install I2C components.
echo -e "\nUpdating sources & installing i2c utils:"
sudo apt-get update
# sudo apt-get install -y i2c-tools libi2c-dev python-smbus

# Get latest stable version from GitHub
echo -e "\nDownloading current master version:"
cd $DIR
wget https://github.com/alexey1234/bananapi_gbs_control/archive/master.zip

# Unpack scripts & default settings
echo -e "\nUnpacking zip package:"
unzip -oq $DIR/master.zip

echo -e "\nRemove zip package:"
# rm $DIR/master.zip

# Patch /etc/inittab to allow for automatic login.
# and to use xterm-mono for B&W (monochrome) interactive terminal.
echo -e "\nApply patch to /etc/inittab for auto login and monochrome terminal:"
sudo patch -bN -F 6 /etc/inittab $DIR/scripts/patch.inittab

# Patch /etc/modules & /etc/modprobe.d/raspi-blacklist.conf for i2c use
echo -e "\nApply patch to /etc/modules for kernal i2c modules:"
sudo patch -bN -F 6 /etc/modules $DIR/scripts/patch.modules
echo -e "\nApply patch to /etc/modprobe.d/raspi-blacklist.conf to allow i2c use:"
sudo patch -bN -F 6 /etc/modprobe.d/raspi-blacklist.conf $DIR/scripts/patch.raspi-blacklist.conf

# Patch /etc/default/triggerhappy to use root user
echo -e "\nApply patch to /etc/default/triggerhappy to use root"
sudo patch -bN -F 6 /etc/default/triggerhappy $DIR/scripts/patch.triggerhappy

# Move triggerhappy files to /etc/triggerhappy/triggers.d
# Detect Banana
BANANA=$(cat /proc/cpuinfo | grep Hardware | awk '{ print $3 }' | tr -d '\n')
if ["$BANANA" = "sun7i"]; then
	echo -e "BananaPi detected"
	sudo cp thd/triggerhappy_banana/* /etc/triggerhappy/triggers.d/
	sudo patch -bN -F 6 $DIR/scripts/Adafruit_I2C.py $DIR/scripts/patch.adaftuit
	sudo patch -bN -F 6 $DIR/adaptive_deinterlace.sh $DIR/scripts/patch.adaptive_deinterlace
	sudo patch -bN -F 6 $DIR/gbs-control.sh $DIR/scripts/patch.gbs-control
	#
else	
	echo -e "\nCopy triggerhappy hotkey conf files:"
	REVISION=$(cat /proc/cpuinfo | grep revision)
	LEN=${#REVISION}
	POS=$((LEN -1))
	REV=${REVISION:POS}
	if [ "$REV" = "0" ] || [ "$REV" = "1" ]; then
		echo -e "Revision 1 detected"
		sudo cp thd/triggerhappy_rev1/* /etc/triggerhappy/triggers.d/
	else
		echo -e "Revision 2 detected"
		sudo cp thd/triggerhappy/* /etc/triggerhappy/triggers.d/
	fi
fi

# Add required scripts for automatic start-up.
echo -e "\nApply patch to .profile for bootup scripts:"
patch -bN -F 6 $DIR/.profile $DIR/scripts/patch.profile

# Replace config.txt to ensure booting with composite.
echo -e "\nReplace /boot/config.txt for Luma output settings:"
sudo cp /boot/config.txt /boot/config.txt.bak
sudo rm /boot/config.txt
# Check for Device tree usage
DEVTREE=$(ls /proc | grep -c device-tree)
if [ "$DEVTREE" = "0" ]; then
    echo -e "No Device Tree detected"
	sudo cp $DIR/scripts/config.txt /boot/config.txt
else
    echo -e "Device Tree detected"
	sudo cp $DIR/scripts/config-device-tree.txt /boot/config.txt
fi

# Reboot
echo -e "\nNow rebooting system"
sync
sudo reboot
exit 0
