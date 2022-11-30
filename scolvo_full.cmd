@ECHO OFF

SETLOCAL enabledelayedexpansion

ECHO Executing command "%1" ...

if "%1" == "help" (
	ECHO "Usage: %~n0 [start|stop|restart|reset] [-d] [-na]"
	ECHO.
	ECHO Options:
	ECHO   -d  - Enables development mode, exposing ports for direct access
	ECHO   -na - Disables start of MHub
	ECHO.
	ECHO Actions:
	ECHO   start          - starts the system
	ECHO   stop           - stop the system
	ECHO   restart        - restarts the system
	ECHO   reset          - resets the system, removing Docker containers
	REM ECHO   fullreset     - resets the system, removing Docker containers and images
	REM ECHO   build         - builds the Docker images
	ECHO   logs           - follow logs of be, bedb, admin and webapp containers (starting with the last 100 lines
	ECHO   fullLogs       - follow logs of all containers (starting with the last 100 lines
	ECHO   checkRunning   - check if system is currently running
	ECHO   restartBackend - restarts the Backend process

) ELSE ^
if "%1" == "start" (
	SET COMPOSE_FILES=-f docker-compose.yml
	SET SERVICES_TO_START=auth authdb mq proxy be bedb webapp storage
	SET /A ADMIN=1

	if "%2" == "-na" SET /A ADMIN=0
	if "%3" == "-na" SET /A ADMIN=0
	if "%2" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml & SET SERVICES_TO_START=!SERVICES_TO_START! test-runner
	if "%3" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml & SET SERVICES_TO_START=!SERVICES_TO_START! test-runner

	if !ADMIN! == 1 SET SERVICES_TO_START=!SERVICES_TO_START! admin

	docker-compose !COMPOSE_FILES! up -d !SERVICES_TO_START!
) ELSE ^
if "%1" == "stop" (
	SET COMPOSE_FILES=-f docker-compose.yml

	if "%2" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml
	if "%3" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml

	docker-compose !COMPOSE_FILES! down -v --remove-orphans

) ELSE ^
if "%1" == "restart" (

	SET COMPOSE_FILES=-f docker-compose.yml
	SET SERVICES_TO_START=auth authdb mq proxy be bedb webapp storage
	SET /A ADMIN=1

	if "%2" == "-na" SET /A ADMIN=0
	if "%3" == "-na" SET /A ADMIN=0
	if "%2" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml & SET SERVICES_TO_START=!SERVICES_TO_START! test-runner
	if "%3" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml & SET SERVICES_TO_START=!SERVICES_TO_START! test-runner

	if !ADMIN! == 1 SET SERVICES_TO_START=!SERVICES_TO_START! admin

	docker-compose !COMPOSE_FILES! down -v --remove-orphans
	timeout /t 1
	docker-compose !COMPOSE_FILES! up -d !SERVICES_TO_START!

) ELSE ^
if "%1" == "restartBackend" (

	SET COMPOSE_FILES=-f docker-compose.yml
	if "%2" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml
	if "%3" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml
	docker-compose !COMPOSE_FILES! restart be

) ELSE ^
if "%1" == "reset" (

	SET COMPOSE_FILES=-f docker-compose.yml
	SET SERVICES_TO_START=auth authdb mq proxy be bedb webapp storage
	SET /A ADMIN=1

	if "%2" == "-na" SET /A ADMIN=0
	if "%3" == "-na" SET /A ADMIN=0
	if "%2" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml & SET SERVICES_TO_START=!SERVICES_TO_START! test-runner
	if "%3" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml & SET SERVICES_TO_START=!SERVICES_TO_START! test-runner

	if !ADMIN! == 1 SET SERVICES_TO_START=!SERVICES_TO_START! admin

	docker-compose !COMPOSE_FILES! down
	timeout /t 1
	docker-compose !COMPOSE_FILES!  down -v --remove-orphans

) ELSE ^
IF "%1" == "logs" (

	SET COMPOSE_FILES=-f docker-compose.yml
	SET SERVICES_TO_LOG=be admin webapp storage

	if "%2" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml & SET SERVICES_TO_LOG=!SERVICES_TO_LOG! test-runner
	if "%3" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml & SET SERVICES_TO_LOG=!SERVICES_TO_LOG! test-runner

	docker-compose !COMPOSE_FILES! logs -f --tail=100 !SERVICES_TO_LOG!


) ELSE ^
IF "%1" == "fullLogs" (

	SET COMPOSE_FILES=-f docker-compose.yml

    if "%2" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml
	if "%3" == "-d" SET COMPOSE_FILES=!COMPOSE_FILES! -f docker-compose-dev.yml

	docker-compose !COMPOSE_FILES! logs -f --tail=100

) ELSE ^
IF "%1" == "checkRunning" (
	SET SCRIPT_DRIVE_AND_PATH=%~dp0
	ECHO Checking running state from !SCRIPT_DRIVE_AND_PATH! ...

	SET BACKEND_STATUS="notrunning"
	FOR /f %%i in ( 'docker inspect backend --format='{{.State.Status}}' ' ) DO SET BACKEND_STATUS=%%i
	IF "!BACKEND_STATUS!" == "'running'" ( ECHO The backend is running ...) ELSE ( ECHO The system is currently NOT running. & EXIT 1 )
	SET PROJECT_WORKING_DIR=""
	IF "!BACKEND_STATUS!" == "'running'" ( FOR /f "usebackq tokens=*" %%i in (`docker inspect backend --format="{{index .Config.Labels \"com.docker.compose.project.working_dir\"}}" `) do set PROJECT_WORKING_DIR=%%i)

	SET "NORMALIZED_WORKING_DIR=!PROJECT_WORKING_DIR!\" 
	ECHO Normalized project dir is: !NORMALIZED_WORKING_DIR! 
	IF /i !SCRIPT_DRIVE_AND_PATH! == !NORMALIZED_WORKING_DIR! ( ECHO The system is currently running from this project directory & EXIT 0 ) ELSE ( ECHO The system is currently running BUT from a DIFFERENT project directory: !PROJECT_WORKING_DIR! & EXIT 1 )

) ELSE (
	ECHO Unsupported action: %1
	exit 1
)

ENDLOCAL
ECHO Done!
exit 0
