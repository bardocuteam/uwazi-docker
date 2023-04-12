#!/bin/sh

echo "uwazi-docker: IS_FIRST_RUN: $IS_FIRST_RUN"

/wait-for-it.sh -h mongo -p 27017 -t 30

if [ "$IS_FIRST_RUN" = "true" ] ; then
    echo "uwazi-docker: Enviroment variable IS_FIRST_RUN is true. Assuming need to install database from blank state"

    yarn blank-state uwazi
    echo "uwazi-docker: If no fatal errors occurred, you will not need to use this command again"
    exit 0
else
    echo "uwazi-docker: Enviroment variable IS_FIRST_RUN is not true. Assume MongoDB and Elastic Search provide already are intialized"
    echo "uwazi-docker: [protip] is possible to initialize (or reset o initial state) MongoDB and Elastic Search with enviroment variable IS_FIRST_RUN=true"
fi

node server.js
