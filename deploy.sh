#!/bin/bash

set -e

username=$(whoami)
if [ "x${username}" != "xroot" ]; then
  echo "Need to run this with sudo."
  exit 1
fi

apt-get update
apt-get install -y \
        isc-dhcp-server \
        linux-igd       \
        lsb-invalid-mta \
        smokeping       \
        openssh-server  \
        screen          \
        vim             \
        git             \
        nmap            \
        python-pip      \
        nethack-console  


echo "Deploying the files/ directory to the root filesystem..."
tsnow=$(date +%s)

files_backup=/root/files-backup-${tsnow}/

if [ "x${files_backup}" = "x" ]; then
  echo "files_backup not set, bailing."
  exit
fi

mkdir -p ${files_backup}

# The files/ subdirectory is a mirror of the local filesystem state
pushd files
for x in $(find . -type f); do
  x_abs=/${x}
  d=$(dirname $x)
  mkdir -p ${files_backup}/${d}
  if [ -x ${x_abs} ]; then
    cp ${x_abs} ${files_backup}/${d}
  else
    touch ${files_backup}/${x_abs}.was_missing
  fi
  cp -v ${x} ${x_abs}  
done
popd

echo "Deploying smokeping apache2 config..."
ln -sf /etc/smokeping/apache2.conf /etc/apache2/conf-enabled/smokeping.conf
ln -sf /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/
service apache2 reload


echo "Creating empty authorized keys file if not there..."
mkdir -p /home/pi/.ssh
touch /home/pi/.ssh/authorized_keys
chmod 0700 /home/pi/.ssh
chmod 0600 /home/pi/.ssh/authorized_keys
chown -R pi /home/pi/.ssh

echo "Installing pyserial, for miniterm.py..."
sudo pip install pyserial
