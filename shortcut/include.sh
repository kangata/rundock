#!/usr/bin/env bash

PHP_PATH="$SCRIPT_PATH/php"
FPM_PATH="$SCRIPT_PATH/php-fpm.d"

SUPERVISOR_CONF_PATH="$SCRIPT_PATH/supervisor/conf.d"

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

$SCRIPT_PATH/../vendor/bin/rundock $ENV ${@}