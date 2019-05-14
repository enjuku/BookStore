# Установка

## Процесс установки приведён на примере операционной системы [Ubuntu 18.10](http://releases.ubuntu.com/18.10/)

Перед запуском приложения необходимо установить следущие зависимости:
  - RVM
    ```
    $ gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    $ \curl -sSL https://get.rvm.io | bash -s stable --rails
    $ source /home/$USER/.rvm/scripts/rvm    # для возможонсти ипользования команд bundle, gem, ruby в текущей сессии терминала
    ```
    Больше информации [по ссылке](https://rvm.io/rvm/install).

    > **Внимание:** Для использования команд **bundle**, **gem**, **ruby** в терминале при запуске интерактивной оболочки, например **bash**, нужно добавить в файл **.bashrc** следующую строку "`source /home/$USER/.rvm/scripts/rvm`" - путь куда установлен **RVM**

  - Ruby
    ```
    $ rvm install 2.5.1
    $ rvm use 2.5.1
    ```
  - NodeJs
    ```
    $ apt install nodejs
    ```
    Больше информации [по ссылке](https://nodejs.org/en/download/).
  - Redis
    ```
    $ apt install redis-server
    ```
    Больше информации [по ссылке](https://redis.io/topics/quickstart).
  
# Установка пакетов
> Перед выполнением команды нужно перейти в корень проекта
```
$ bundle
```


# Запуск тестов
```
$ rails test
```

# Запуск приложения
```
$ service redis-server start
$ bundle exec sidekiq 
$ rails s
```
