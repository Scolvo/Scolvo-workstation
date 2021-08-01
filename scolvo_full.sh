#!/bin/bash

printHelp() {
	echo "Usage: $(basename "$0") [-d] [start|stop|restart|reset]"
	echo
	echo "Options:"
	echo "  -d  - Enables development mode, exposing ports for direct access"
	echo "  -na - Disables start of MHub"
	echo
	echo "Actions:"
	echo "  start   - starts the system"
	echo "  stop    - stop the system"
	echo "  restart - restarts the system"
	echo "  reset   - resets the system, removing Docker containers"
	echo "  fullreset   - resets the system, removing Docker containers and images"
	echo "  build   - builds the Docker images"
	echo "  logs    - follow logs of all containers (starting with the last 100 lines"
}

COMPOSE_FILES='-f docker-compose.yml'
SERVICES_TO_START='auth authdb mq proxy be bedb'

ADMIN=1
while true
do
	case "${1}" in
	-h|--help)
		printHelp
		exit 1
		shift ;;
	-d|--development)
		COMPOSE_FILES="${COMPOSE_FILES} -f docker-compose-dev.yml"
		shift ;;
	-na|--no-admin)
		ADMIN=0
		shift ;;
	'') shift ; break ;;
	*)
		ACTION="${1}"
		shift ;;
	esac
done

if [[ ${ADMIN} -eq 1 ]]
then
	SERVICES_TO_START="${SERVICES_TO_START} admin"
fi

start() {
    docker-compose ${COMPOSE_FILES} up -d ${SERVICES_TO_START}
}

stop() {
    docker-compose ${COMPOSE_FILES} down
}

restart() {
  stop
	sleep 1
	start
}

case "${ACTION}" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    reset)
	stop
	sleep 1
   	docker-compose ${COMPOSE_FILES} down -v --remove-orphans
   	;;
    fullreset)
	stop
	sleep 1
   	docker-compose ${COMPOSE_FILES} down -v --remove-orphans --rmi all
   	;;
    build)
	stop
	sleep 1
	docker-compose ${COMPOSE_FILES} build ${SERVICES_TO_START}
	;;
    logs)
	docker-compose ${COMPOSE_FILES} logs -f --tail=100
	;;
esac
