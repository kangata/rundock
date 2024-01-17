#!/usr/bin/env bash

PHP_PATH="$SCRIPT_PATH/php"
FPM_PATH="$SCRIPT_PATH/php-fpm.d"

SUPERVISOR_CONF_PATH="$SCRIPT_PATH/supervisor/conf.d"

STUBS_PATH="$SCRIPT_PATH/stubs"
COMPOSE_PATH="$SCRIPT_PATH/$ENV-confs"

if [[ -d "$PHP_PATH" && ! -f "$PHP_PATH/php.ini" ]]
then
    phpini="php.ini-production"

    if [[ "$ENV" == "dev" ]]
    then
        phpini="php.ini-development"
    fi

    cp "$PHP_PATH/$phpini" "$PHP_PATH/php.ini"
fi

if [[ -d "$FPM_PATH" && ! -f "$FPM_PATH/www.conf" ]]
then
    cp $FPM_PATH/www.conf-default $FPM_PATH/www.conf
fi

if [[ -d "$SUPERVISOR_CONF_PATH" ]]
then
    for template in $(find "$SUPERVISOR_CONF_PATH" -type f -regex ".*-default$")
    do
        config=$(echo $template | sed 's/-default//g')

        if [[ ! -f $config ]]
        then
            cp $template $config
        fi
    done
fi

if [[ -d "$STUBS_PATH" && ! -d "$COMPOSE_PATH" ]]
then
    mkdir "$COMPOSE_PATH"

    if [[ -d "$STUBS_PATH" ]]
    then
        for stub in $(find $STUBS_PATH -type f -regex ".*\.stub")
        do
            compose="$(echo $(basename $stub) | sed 's/\.stub/\.yaml/g')"

            cp "$stub" "$COMPOSE_PATH/$compose"
        done
    fi
fi

$SCRIPT_PATH/../vendor/bin/rundock $ENV ${@}
