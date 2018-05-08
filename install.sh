#! /bin/bash

# Move into the git root dir and run this script as ./install.sh

ROOT='/nubq'

# create Q system user with no shell (prevent login) and no home dir
sudo useradd -r -s /bin/false q

# create Q's root dir structure
sudo mkdir "$ROOT"
sudo mkdir "$ROOT/done"
sudo mkdir "$ROOT/jobs"
sudo mkdir "$ROOT/nubq"
sudo touch "$ROOT/error.log"
sudo touch "$ROOT/jobs.log"

# copy the scripts to root dir
cp -r ./* "$ROOT/nubq"

sudo chown -R q "$ROOT"
sudo chmod -R 755 "$ROOT"
sudo chmod 777 "$ROOT/jobs" "$ROOT/nubq/KILLSWITCH"

#sudo ln "$ROOT/bin/start-q" /usr/bin/start-q

# add bin to PATH for all users and non-login shells
# /etc/bash.bashrc is executed for non-login shells
echo "PATH=\$PATH:$ROOT/nubq" | sudo tee -a /etc/bash.bashrc
# /etc/profile is executed for normal logins for all users, so we have it source bash.bashrc
echo "[ -f /etc/bash.bashrc ] && . /etc/bash.bashrc" | sudo tee -a /etc/profile
# apply for current session 
source /etc/profile

echo 'NubQ was installed! Use start-q to start it up.'
