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

# 2: Build core services TODO with one pom
info "Bulding legacy web shop"
cd core-services/categoryservice
mvn clean package docker:build
cd ../..

info "Building initialized MySQL Database for CategoryService"
docker build -t categoryservice-db-image -f ./core-services/categoryservice/DockerfileMySQLCategory ./core-services/categoryservice

# x: Compose all together
info "Composing microservice containers"
docker-compose -f docker-compose-microservices.yml up -d