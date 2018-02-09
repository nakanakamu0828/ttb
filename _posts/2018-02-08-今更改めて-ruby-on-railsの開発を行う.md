---
layout: post
thumbnail: /images/uploads/rails.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part1
description: Railsによる開発をスタートしよう
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - rails
---
こんばんわ、なかむです。  
今回はRuby On Railsの基礎として環境設定からインストール、プロジェクト作成まで行なっていきたいと思います。  
vagrantを利用してCentOS7で開発環境を構築していきます。  
  
【補足】
* rbenvでrubyを管理
* nginx + puma でWEB/APサーバーを構築
* DBはMySQL5.7を利用
* フロントエンドのライブラリはyarnで管理

## さっそくインストール
yumを最新にupdateしてから作業を進めていきます。
yumで必要なライブラリをインストール
```
$ # rootユーザーにswitchして作業を進めます
$ 
$ sudo su -
# yum -y update
# yum -y install git gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel libffi-devel libxml2 libxslt libxml2-devel libxslt-devel mysql mysql-devel ImageMagick ImageMagick-devel epel-release curl-devel
```

rbenvでrubyをインストールするので、まずはrbenvをインストール
```
# git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
# echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile
# echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> /etc/profile
# echo 'eval "$(rbenv init -)"' >> /etc/profile
# source /etc/profile
# git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
```

ruby2.5.0(執筆時点(2018/02/08)の最新)をインストール
```
# rbenv install -v 2.5.0
# rbenv global 2.5.0
# rbenv rehash
# chmod -R a+w /usr/local/rbenv
```

Rails, Pumaをインストール
```
# gem update --system
# gem install bundler
# gem install nokogiri -- --use-system-libraries
# gem install --no-ri --no-rdoc rails
# gem install --no-ri --no-rdoc puma
```

nvm + yarn をインストール
```
# git clone git://github.com/creationix/nvm.git /usr/local/nvm
# echo "if [[ -s /usr/local/nvm/nvm.sh ]];" >> /etc/profile
# echo " then source /usr/local/nvm/nvm.sh" >> /etc/profile
# echo "fi" >> /etc/profile
# source /etc/profile
# nvm install v8.4.0
# chmod -R a+w /usr/local/nvm
# npm install -g yarn
```

nginx をインストール
```
# yum install nginx
# # user を vagrantに変更
# vi /etc/nginx/nginx.conf

#user nginx;
user vagrant;

# chmod -R a+w /var/log/nginx/
```

mysql をインストール
```
# # mariadbのライブラリがあれば削除
# yum remove mariadb-libs
# rm -rf /var/lib/mysql/
# yum localinstall http://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
# yum -y install mysql-community-server mysql-community-devel
#
# # my.cnf の文字コードはutf8mb4
# # MySQL起動
# systemctl start mysqld.service
#
# # 初期パスワードの確認
# grep "A temporary password" /var/log/mysqld.log

2018-01-27T17:01:37.752069Z 1 [Note] A temporary password is generated for root@localhost: [パスワードが表示されます]

# # パスワード変更。パスワードはdatabase.ymlで利用します。
# mysql_secure_installation
#

mysqlの設定は文字コードだけ変えます（開発環境なので簡易的です）

# cp /etc/my.cnf /etc/my.cnf.org
# vi /etc/my.cnf

[mysqld]
-- 追加
character-set-server=utf8mb4

-- 追加
[mysql]
character-set-server=utf8mb4

# systemctl restart mysqld.service

mysqlコマンドからMySQLサーバーにログインできることを確認しましょう
# mysql -uroot -p


```

ここまでで必要なミドルウェアのインストールが完了です。


## Railsプロジェクトのリポジトリを作成
vagrantユーザーにexitしてからリポジトリを作成していきます。
vagrantを利用しているので、ホストOSにマウントされている/vagrantディレクトリにリポジトリを作成します。

```
# exit
$ cd /vagrant/
$ rails new --database=mysql --skip-turbolinks --skip-test --skip-bundle --skip-javascript netshop

今回はturbolinkやtestを利用しません
また、初期はbundle installしないでプロジェクトを作成します
netshop はプロジェクト名です。簡易的なecサイトを構築してみたいと思います。
```

`rails new`のオプションは [こちら](http://railsdoc.com/rails) をご確認ください。

それでは各種設定をしていきます。

■ DB設定
```
$ cd netshop/
$ vi config/database.yml

default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: [MySQLのパスワード設定]
  socket: /var/lib/mysql/mysql.sock
```

■ puma設定
```
$ vi config/puma.rb

_proj_path = "#{File.expand_path("../..", __FILE__)}"
_proj_name = File.basename(_proj_path)
_home = ENV.fetch("HOME") { "/vagrant" }
_environment = ENV.fetch("RAILS_ENV") { "development" }

pidfile "#{_home}/#{_proj_name}/run/#{_proj_name}.pid"
bind "unix://#{_home}/#{_proj_name}/run/#{_proj_name}.sock"
directory _proj_path

ファイルのhead部分に追加

$ mkdir -p run
$ chmod a+w run

プロセスIDファイルの配置ディレクトリを作成
```

■ nginx設定
```
$ mkdir -p misc/nginx
$ vi misc/nginx development.conf

upstream netshop {
    server unix:///vagrant/netshop/run/netshop.sock fail_timeout=0;
}

server {
    listen 80;
    server_name netshop.local; # 開発環境のipアドレスもしくはホスト名を記述

    root /vagrant/netshop/public; # アプリケーション名を記述

    try_files $uri/index.html $uri @netshop; # アプリケーション名を記述

    location / {
        proxy_pass http://netshop; # アプリケーション名を記述
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_max_temp_file_size 0;
    }

    error_page 500 502 503 504 /500.html;
    client_max_body_size 4G;
    keepalive_timeout 10;
}

server_nameはご自身にあった環境の値を設定してください。

$ sudo ln -snf /vagrant/netshop/misc/nginx/development.conf /etc/nginx/conf.d/netshop.conf

nginxが設定ファイルを読み込むようにシンボリックリンクを /etc/nginx/conf.d/ に配置します

```

設定は以上となります。

## Railsを起動

まずはpumaを起動します。

```
$ sudo systemctl restart nginx
```

続いてpumaを起動します。
利用するgemはプロジェクト内にインストールします。

```
$ bundle install --path=vendor/bundle
$ bundle exec rails db:create
$ bundle exec puma 
```
