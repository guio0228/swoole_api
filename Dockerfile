FROM php:8.3 as php

# 更新 apt 包列表並安裝所需的軟件包
RUN apt-get update -y && \
    apt-get install -y software-properties-common curl gnupg debian-keyring debian-archive-keyring apt-transport-https ca-certificates build-essential dos2unix gcc git git-lfs libmcrypt4 libpcre3-dev libpng-dev chrony make pv python3-pip re2c supervisor unattended-upgrades whois vim cifs-utils bash-completion zsh zip unzip expect

# 安裝 PHP 擴展
RUN docker-php-ext-install pdo pdo_mysql bcmath

# 安裝 Redis 擴展並啟用
RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

# 設置工作目錄
WORKDIR /var/www

# 複製應用程式代碼到容器
COPY . .

# 從 Composer 容器複製 Composer 可執行文件
COPY --from=composer:2.6.5 /usr/bin/composer /usr/bin/composer

# 設置容器入口點
ENTRYPOINT [ "docker/entrypoint.sh" ]
