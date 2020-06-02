#!/bin/bash
# http://raspberrypi.tomasgreno.cz/ntp-client-and-server.html
csere()
{
OLD="debian.pool.ntp.org iburst"
NEW=$1".pool.ntp.org iburst"
DPATH="/etc/ntp.conf"
BPATH="~/ntp.conf.backup"
[ ! -d $BPATH ] && sudo mkdir -p $BPATH || :
for f in $DPATH
do
  if [ -f $f -a -r $f ]; then
    sudo /bin/cp -f $f $BPATH
    sudo sed -i "s/$OLD/$NEW/g" "$f"
   else
    echo "Error: Cannot read $f"
  fi
done
}

source ntp.conf
sudo timedatectl set-timezone $timezone
sudo apt update
sudo apt install ntp ntpdate ntp-doc -y
sudo systemctl stop systemd-timesyncd
sudo systemctl disable systemd-timesyncd
sudo service ntp restart
sudo service ntp reload
csere $cc
sudo timedatectl set-ntp true
sudo service ntp stop
sudo ntpdate 0.$cc.pool.ntp.org
sudo service ntp start
sudo ntpq -pn
