This repo can be used to launch a full Scolvo Dev environment locally or on a cloud based Virtual Machine. (Getting started with Scolvo Development Framework: https://github.com/Scolvo/Scolvo-Development-Platform)


# Starting the server


#### KeyCloak: accesible in browser

    url: https://localdemo.scolvo.solutions/auth/
    username: admin
    password: admin

#### BackendDB: use a mysql client such as Sequel Pro or similar.

    url: localdemo.scolvo.services
    port: 23306
    username: bedb
    password: bedb
    database: bedb

## START the environment from CLI:
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
