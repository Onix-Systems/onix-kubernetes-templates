# Миграция кластера на новые сервера

### 1. Подготовить новые инстансы для кластера. 
На даный момент нужно минимум 2 инстанса (Master-Worker). 
В качестве ОС используем чистую **Ubuntu 18.04**.
Так как на Master node будет работать Gitlab и database services, минимум для Master node нужно 8Gb RAM и SSD накопитель что бы ускорить CI\CD.
Worker node минимум 32Gb RAM


### 2. Подготовить инстансы. 
Проверить что бы на новых инстансах не было запщено ничего что бы использовало TCP порты 80 443 3306 5432 27017 6443

### 3. Переключаем DNS.
Переключить DNS на свежие инстансы либо зарегистрировать новые. Обязательно дождаться переключения, это важно для дальшейшей настройки

### 4. Останавливаем текущий активный Gitlab.
Этот пункт важен дня того что бы сделать последний актуальный бекап

### 5. Останавливаем Database services.
Этот пункт важен дня того что бы сделать последний актуальный бекап staging databases

### 6. Делаем резервную копию Gitlab, Database Services и данных проектов:
#### Gitlab:
Внутри контейнера Gitlab выполнить команду
```
gitlab-rake gitlab:backup:create SKIP=registry
```
Так же обязательно нужно скопировать директорию **/etc/gitlab** в ней находятся необходимые файлы:
 - gitlab-secrets.json - файл с секретами 
 - gitlab.rb - конфигурационный файл Gitlab
#### Database Services:
MySQL
```
mysqldump -uuser -ppassword --all-databases
```
PostgreSQL
```
pg_dumpall -U user
```
MongoDB
```
mongodump --gzip --archive
```
#### Данные проектов:
Сделать резервную копию директории ***/home/ubuntu/kuber_projects_data***

Так же, рекомендуем использовать скрипт для автоматического бекапа, который сделает бекапы автоматически и загрузит их в AWS S3

### 7. Запускаем Ansible сценарий.
[Используя эту инструкцию](ANSIBLE.MD).

### 8. Восстановление резервную копию Gitlab .
Для восстановления поместите бекап в директорию:
```
gitlab/gitlab_data/data/backups
```
Внутри контейнера выполните команду 

```
sudo gitlab-rake gitlab:backup:restore
```
Замените gitlab-secrets.json в директории **/etc/gitlab** внутри контейнера GitLab

### 8. Восстановление резервную копию Database Services.
MySQL:
```
mysql -u root -p[root_password] < mysql_dump.sql
```
PostgreSQL:
```
psql on1x_db on1xus3r -f pg_dump.sql
```
MongoDB:
Восстанавливаем дата-директорию
```
docker-compose stop mongo
tar xzvf mongo.tar.gz
docker-compose up -d mongo
```

### 9. Восстановление резервную копию дата - директории проектов.
Поместить в директорию ***/home/ubuntu/kuber_projects_data***

### 10. Запускаем пробный проект для деплоя и проверяем его работу
После чего нужно перезапустить деплой тех проектов которые нужно запустить

