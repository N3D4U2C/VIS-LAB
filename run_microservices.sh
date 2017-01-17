#!/bin/sh

source run_base_script.sh

#######
info "Check if ENV variables were set"
[ -z "$DOCKER_USER" ] && echo "Need to set DOCKER_USER ENV-var. Run '$ source export_vars.sh' first!" && exit 1;
[ -z "$DOCKER_PROJECT_IMAGE_PREFIX" ] && echo "Need to set DOCKER_PROJECT_IMAGE_PREFIX ENV-var. Run '$ source export_vars.sh' first!" && exit 1;
[ -z "$TAG" ] && echo "Need to set TAG ENV-var. Run '$ source export_vars.sh' first!" && exit 1;
[ -z "$MYSQL_WEBSHOP_DB_ADDR" ] && echo "Need to set MYSQL_WEBSHOP_DB_ADDR ENV-var. Run '$ source export_vars.sh' first!" && exit 1;

#######
info "Building microservices and docker images"
mvn clean install #-DskipTests

#######
info "Building new version of legacy webshop"
cd LegacyWebShop_Micro && mvn clean package && cd ..

#######
info "Building initialized MySQL Database image"
docker build -t ${MYSQL_WEBSHOP_DB_ADDR} -f ./LegacyWebShop/DockerfileMySQL ./LegacyWebShop

#######
info "Stopping and removing old containers"
docker-compose -f docker-compose-microservices.yml stop && docker-compose -f docker-compose-microservices.yml rm -f

#######
info "Composing microservice containers"
docker-compose -f docker-compose-microservices.yml up -d --remove-orphans && docker-compose -f docker-compose-microservices.yml logs -tf
