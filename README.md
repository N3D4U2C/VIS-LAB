# Distributed Information Systems Laboratory aka vis-lab
Splitting a monolithic web shop application, running on a Tomcat into small domain-driven microservices with Spring Boot and Docker. This project is part of the masters course 'Distributed Information Systems' at the University of Applied Sciences (Karlsruhe).

## Prerequisites
- [maven](https://maven.apache.org/)
- [docker](https://docker.com)
- docker-compose

## Starting
### Legacy System
- Start Docker daemon
- Check out the project and simply run the script:
```bash
$ chmod +x run_legacy.sh
$ ./run_legacy.sh
```
- Builds the web app `war`, packs it into a docker tomcat8 container,
and sets the user `tomcat` with password `admin` for the Management Console at [http://localhost:8888/](http://localhost:8888/)
- Inits the MySQL Database docker container with the db user defined in `hibernate.cfg.xml`
- Sets up both containers and make the web app available under [http://localhost:8888/EShop-1.0.0/](http://localhost:8888/EShop-1.0.0/)

### Microservice Architecture
will be realized soon...

### Notes
If you change the user and password of the MySQL database, you should run
```bash
$ docker-compose -f docker-compose-legacy.yml rm -v
$ rm -rf .data
```
Details can be found [here](https://github.com/docker-library/mysql/issues/51)
