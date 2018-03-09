#!/bin/bash
CONTAINER="wikilds"
BASEDIR=$(pwd)
CONTENT_PATH="$BASEDIR/content/"
CONFIG_PATH="$BASEDIR/config/config.default.js/"
COMMAND=$1

ISCONTAINER=`docker ps -a | grep -c $CONTAINER`
ISIMAGE=`docker image ls -a | grep -c $CONTAINER`
ISRUNNING=`docker ps -a | grep -c -G Up.*$CONTAINER`


build_container () {
    echo "BUILD"
    # docker build -t $CONTAINER . --rm 
}

start_contatiner () {
    echo "START"
    docker start $CONTAINER
}

restart_contatiner () {
    echo "RESTART"
    docker restart $CONTAINER
}

run_container () {
    echo "RUN"
    docker run --name $CONTAINER  \
		-v $CONTENT_PATH:/data/content/ \
		-v $CONFIG_PATH:/opt/raneto/example/config.default.js \
		-p 3200:3000 -d $CONTAINER
}

stop_contatiner () {
    echo "STOP"
    docker stop $CONTAINER
}

remove_contatiner () {
    echo "REMOVE"
    docker rm $CONTAINER
}

case $COMMAND in
app_restart*)
    if [ $ISRUNNING -eq 1 ]
    then
       docker exec $CONTAINER pm2 restart $CONTAINER
    else
        echo "No executed containers"
    fi
    ;;
stop*)
    if [ $ISCONTAINER -eq 1 ]
    then
        stop_contatiner
    fi
    ;;
clear*)
    if [ $ISCONTAINER -eq 1 ]
    then
        stop_contatiner
        remove_contatiner
    fi
    ;;
run*)
    # Если не существует image, то нужно сбилдить
    if [ $ISIMAGE -eq 0 ]
    then
        build_container
    fi

    # Если существует сontainer
    if [ $ISCONTAINER -eq 1 ]
    then
        # Если он запущен, то просто рестартим
        if [ $ISRUNNING -eq 1 ]
        then
            restart_contatiner
        else
            # стартуем
            start_contatiner
        fi
    fi

    # Если не существует сontainer то запускаем
    if [ $ISCONTAINER -eq 0 ]
    then
        run_container
    fi

    ;;
esac