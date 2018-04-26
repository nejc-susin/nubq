#! /bin/bash

ROOT='/nubq'

# create Q system user with no shell (prevent login) and no home dir
sudo useradd -r -s /bin/false q

# create Q's root dir structure
sudo mkdir "$ROOT"

mkdir "$ROOT/done"
mkdir "$ROOT/jobs"
mkdir "$ROOT/bin"
touch "$ROOT/error.log"
touch "$ROOT/jobs.log"
touch "$ROOT/KILLSWITCH"
chmod o+w "$ROOT/KILLSWITCH"
export PATH=$PATH:"$ROOT"/bin

# copy the scripts to root dir
cp ./enqueue "$ROOT/bin"
cp ./q.sh "$ROOT/bin"
cp ./config.sh "$ROOT/bin"

sudo chown -R q "$ROOT"
sudo chmod -R 764 "$ROOT"

cd "$ROOT"
sudo umask 013