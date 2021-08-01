#!/bin/bash

printHelp() {
	echo "Usage: $(basename "$0") [start|stop|restart|reset]"
	echo
	echo "Actions:"
	echo "  start   - starts the system"
	echo "  stop    - stop the system"
	echo "  restart - restarts the system"
	echo "  reset   - resets the system, removing Docker containers and images"
	echo "  build   - builds the Docker images"
	echo "  logs    - follow logs of all containers (starting with the last 100 lines"
}

SERVICES_TO_START='auth authdb mq proxy admin bedb'

if [[ -z ${1} ]]
then
	printHelp
	exit 1
fi

start() {
    docker-compose up -d ${SERVICES_TO_START}
}

stop() {
    docker-compose down
}

restart() {
    stop
	sleep 1
	start
}

case "${1}" in
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
    	docker-compose down -v --remove-orphans --rmi all
    	;;
	build)
		stop
		sleep 1
		docker-compose build
		;;
	logs)
		docker-compose logs -f --tail=100 ${SERVICES_TO_START}
		;;
esac
