# Начало работы

## Основные ссылки

Git репозиторий: https://gitlab.onix.ua

Менеджер БД: http://db.gitlab.onix.ua/


# НАЧАЛО РАБОТЫ

-  Войти в аккаунт на GitLab

- Ознакомиться с wiki (в левом блоке сайта). В этой wiki важная информация, такая как DNS имя проекта и нформация об аккаунтах для доступов к базам данных (PostgreSQL, MySQL, MongoDB)

- Склонировать новосозданный проект и настроить 3 основных конфигурационных файла, положить их в корень проекта, подробней в разделе [CI\CD](CI-CD.MD)

- Создать [Deploy Token](PULL_SECRET.MD)

- Запушить проект в репозиторий

- Наблюдать за процессом деплоймента

- Перейти на DNS имя вашего проекта


# ОСНОВНЫЕ ПОНЯТИЯ

- Pod - базовая единица для управления и запуска приложений, один или несколько контейнеров, которым гарантирован запуск на одном узле, обеспечивается разделение ресурсов
- [Deployment](KIND_DEPLOYMENT.MD) - Кind Deployment - часть конфигурационного файла для деплоймента, отвечающий за деплоймет приложения.
- [Service](KIND_SERVICES.MD) - Служба с помощью которой происходит проброс порта с вашего контейнера на Ingress контроллер и для доступа между подами
- [Ingress](KIND_INGRESS.MD) - Точка вхождения в приложения, так же отвечает за регистрацию сертификатов
- [Persistent Volumes](PERSISTENTVOLUMES.MD) - Служба отвечающая за сонтирование и сохранение статических данных приложения
- [Deploy Token](PULL_SECRET.MD) - Токен для деплоймента приложения в Кубернетес
