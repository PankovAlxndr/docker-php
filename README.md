# Образ с php8.2 
Образ с php(fpm) для каждого нового проекта собирал руками и при этом бОльшую часть копировал из старых проектов.

Ссылка на докерхаб: [https://hub.docker.com/r/pankovalxndr/fpm](https://hub.docker.com/r/pankovalxndr/fpm)

Решил чуть-чуть оптимизировать работу и опубликовал о данный образ, на нем легко заводятся современные фреймворки (Laravel)

> Образ исключительно на dev среды, так как там бешеные таймауты, лимит памяти в 0.5gb и установлен xdebug

В качестве примера в корне проекта лежит [docker-compose.yml](docker-compose.yml)

Для healthcheck есть пинг-понг, можно в своем докерфайле что-то похожее написать:
```shell
HEALTHCHECK --interval=5s --timeout=3s --start-period=1s \
CMD REDIRECT_STATUS=true SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_METHOD=GET \
cgi-fcgi -bind -connect 127.0.0.1:9000 || exit 1
```
p.s: хотя кому это нужно в dev-контексте