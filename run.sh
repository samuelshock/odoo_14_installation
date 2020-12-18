#!/bin/bash
DESTINATION=$1
PORT=$2
# clone Odoo directory
git clone --depth=1 https://github.com/samuelshock/odoo_14_installation.git $DESTINATION
rm -rf $DESTINATION/.git
# set permission
sudo chmod -R 777 $DESTINATION/addons
sudo chmod -R 777 $DESTINATION/etc
mkdir -p $DESTINATION/postgresql
sudo chmod -R 777 $DESTINATION/postgresql
# config
if grep -qF "fs.inotify.max_user_watches" /etc/sysctl.conf; then echo $(grep -F "fs.inotify.max_user_watches" /etc/sysctl.conf); else echo "fs.inotify.max_user_watches = 524288" | sudo tee -a /etc/sysctl.conf; fi
sudo sysctl -p
sed -i 's/10013/'$PORT'/g' $DESTINATION/docker-compose.yml
# run Odoo
docker-compose -f $DESTINATION/docker-compose.yml up -d

echo "Started Odoo @ http://localhost:10013"

