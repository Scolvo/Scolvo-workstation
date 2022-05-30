This repo can be used to launch a full Scolvo Dev environment locally or on a cloud based Virtual Machine. (Getting started with Scolvo Development Framework: https://github.com/Scolvo/Scolvo-Development-Platform)


# Starting the server 

#### Before starting the environment, make sure that you have a .env file created in the root folder of the project. Old .env files, previously created are also good.

    cp .env_sample .env
    
To set firebase settings see https://scolvo.atlassian.net/wiki/spaces/GEN/pages/678428673/Setup+Firebase+Service

## For mobile client development

This setup includes everything boxed up: MQ, KeyCloak, Backend, Databases. Availability of used resources:

#### MQ: accessible in browser

    url: https://localdemo.scolvo.solutions/mq/
    username: guest
    password guest

#### KeyCloak: accesible in browser

    url: https://localdemo.scolvo.solutions/auth/
    username: admin
    password: admin

To set up the keycloak realm and user please see : https://scolvo.atlassian.net/wiki/spaces/scolvoproduct/pages/506724376/Setup+Keycloak+local+-+know+how
#### BackendDB: use a mysql client such as Sequel Pro or similar.

    url: localdemo.scolvo.services
    port: 23306
    username: bedb
    password: bedb
    database: bedb
    
#### To log in to Nexus Docker registry:

    docker login https://nexus.scolvo.solutions:18088

## START the environment:
To start it, clone the repo to an empty folder, then and use:

    ./scolvo_full.sh start

To stop it:

    ./scolvo_full.sh stop

To stop and remove all files that were created:

    ./scolvo_full.sh reset

To completely reset docker (WARNING: resets the whole docker environment!):

    docker system prune --all
    docker volume prune

To examine the logs:

    ./scolvo_full.sh logs

## For script development
If you would like to have more detailed logging in Backend, then you can configure specific logging by extending the docker-compose.yml file
with following lines in 'be' section:

* Add new environment variable to the 'environment' block:
    environment:
    - LOGGING_CONFIG=/app/logback-spring.xml

* Add new volume line to 'volumes' block:
    volumes:
    - ./assets/config/backend/logback-spring.xml:/app/logback-spring.xml

Then update the assets/config/backend/logback-spring.xml file according to your needs, it contains debug log level for com.scolvo.backend, but info for other logs.

Finally you have to restart the environment using './scolvo_full.sh stop' and './scolvo_full.sh start' commands.

## For backend development

This setup includes everything boxed up: MQ, KeyCloak, Databases.

MQ:  accessible in browser

    url: https://localdemo.scolvo.solutions/mq/
    username: guest
    password guest

KeyCloak: accesible in browser

    url: https://localdemo.scolvo.solutions/auth/
    username: admin
    password: admin

BackendDB: use a mysql client such as Sequel Pro or similar.

    url: localdemo.scolvo.solutions
    port: 23306
    username: bedb
    password: bedb
    database: bedb
    
After starting the docker image, you can connect your local backend to the amqp endpoint: 

    localdemo.scolvo.solutions


## START the environment for Backend development:

To start it, clone the repo to an empty folder, then and use:

    ./scolvo_be.sh start

To stop it:

    ./scolvo_be.sh stop

To stop and remove all files that were created:

    ./scolvo_be.sh reset



To completely reset docker (WARNING: resets the whole docker environment!):

    docker system prune --all
    docker volume prune

you can now access these URLs (they all resolve to localhost):

* https://localdemo.scolvo.solutions
* https://localdemo.scolvo.solutions/mq/
* https://localdemo.scolvo.solutions/auth


To help with the Development process, many services have ports exposed. Make sure you use the test environment on an AWS instance where firewall is strict, or on your laptop.
