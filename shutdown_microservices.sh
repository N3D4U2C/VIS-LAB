#!/bin/sh

###################
# Config
###################
# Aborts the script if a command fails
set -e

###################
# Vars and helpers
###################
SP='********';
function info () {
  echo "";
  echo "${SP}${SP}${SP}${SP}${SP}${SP}${SP}${SP}${SP}${SP}${SP}${SP}";
  echo "$SP [SCRIPT INFO] $1";
  echo "${SP}${SP}${SP}${SP}${SP}${SP}${SP}${SP}${SP}${SP}${SP}${SP}";
  echo "";
}

###################
## Go woop woop
###################
# 1: Check for required deps in the $PATH
info "Check for needed binaries in PATH";
BINS_TO_CHECK=( mvn docker docker-compose )
for BIN in ${BINS_TO_CHECK[@]}; do
  command -v $BIN >/dev/null 2>&1 || { echo >&2 "I require '$BIN' but it's not installed.  Aborting."; exit 1; };
done
echo "-> Fine √"

# 1.1 check if docker deamon runs
info "Checking if docker is running";
docker ps
echo "-> Fine √"

# 1.2 unsetting ENVS
info "Setting ENV variables"
unset MYSQL_CATEGORY_DB_ADDR
unset MYSQL_CATEGORY_DB_PORT
unset MYSQL_CATEGORY_DB_DATABASE
unset MYSQL_CATEGORY_DB_USER
unset MYSQL_CATEGORY_DB_PASSWORD
echo "-> Done √"

# 2: stopping microservices
info "Stopping microservices"
IMAGES_TO_STOP=( mysql:5.7.9 mavogel/categoryservice )
for IMG in ${IMAGES_TO_STOP[@]}; do
  docker stop $(docker ps -a -q --filter ancestor=${IMG} --format="{{.ID}}");
done
echo "-> Done √"
