## Commands

### Add service
`rundock add app-nginx` or `rundoc add app-nginx 8.2-fpm-alpine`

### Remove service
`rundock remove app-nginx`




## Enviroment

### Networks
```
NETWORK_DEFAULT_NAME=
NETWORK_DEFAULT_EXTERNAL=
```

### Nginx
```
FORWARD_NGINX_PORT=8000
```

### Mailpit
```
FORWARD_MAILPIT_WEB_UI_PORT=8025
FORWARD_MAILPIT_SMTP_PORT=1025
```




## Docker Compose

### Nginx
#### Default Volumes
```
- ${PROJECT_PATH}:/var/www/html
- ${PROJECT_PATH}/storage/logs/nginx:/var/log/nginx
- ${RUNDOCK_BASE_PATH}/nginx/templates:/etc/nginx/templates
- ${RUNDOCK_BASE_PATH}/nginx/nginx.conf:/etc/nginx/nginx.conf
```
#### Default Environment
```
- TZ=Asia/Jakarta
- APP_HOST=app
```

### PHP Cron
#### Default Volumes
```
- ${PROJECT_PATH}:/var/www/html
- ${RUNDOCK_BASE_PATH}/cron/schedule_run.sh:/etc/periodic/1min/schedule_run.sh
```
#### Default Environment
```
- TZ=Asia/Jakarta
```

### PHP FPM
#### Default Volumes
```
- ${PROJECT_PATH}:/var/www/html
- ${RUNDOCK_BASE_PATH}/php/php.ini:/usr/local/etc/php/php.ini
- ${RUNDOCK_BASE_PATH}/php-fpm.d/zz-docker.conf:/usr/local/etc/php-fpm.d/zz-docker.conf
- ${PROJECT_PATH}/${PROJECT_RUNDOCK_DIR}/data/.config:/.config
```
#### Default Environment
```
- TZ=Asia/Jakarta
```



## Extras
```
docker run -it --rm \
    -u 33:33 \
    -v $(pwd):/var/www/html \
    -w /var/www/html \
    -e "TZ=Asia/Jakarta" \
    quetzalarc/php-laravel:8.3-alpine \
    composer 
```