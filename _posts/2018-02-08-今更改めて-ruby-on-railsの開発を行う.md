---
layout: post
thumbnail: /images/uploads/rails.png
title: 今更改めて Ruby On Railsの開発を行う
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
* DBはMySQLを利用
* フロントエンドのライブラリはyarnで管理

## さっそくインストール
yumを最新にupdateしてから作業を進めていきます。
yumで必要なライブラリをインストール
```
$ # rootユーザーにswitchして作業を進めます
$ 
$ sudo su -
$ yum -y update
$ yum -y install git gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel libffi-devel libxml2 libxslt libxml2-devel libxslt-devel mysql mysql-devel ImageMagick ImageMagick-devel epel-release curl-devel
```

rbenvでrubyをインストールするので、まずはrbenvをインストール
```
$ git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
$ echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile
$ echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> /etc/profile
$ echo 'eval "$(rbenv init -)"' >> /etc/profile
$ source /etc/profile
$ git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
```

ruby2.5.0(執筆時点(2018/02/08)の最新)をインストール
```
$ rbenv install -v 2.5.0
$ rbenv global 2.5.0
$ rbenv rehash
$ chmod -R a+w /usr/local/rbenv
```

必要になるgemをインストール
```
$ gem update --system
$ gem install bundler
$ gem install nokogiri -- --use-system-libraries
$ gem install --no-ri --no-rdoc rails
$ gem install --no-ri --no-rdoc puma
```

nvm + yarn をインストール
```
$ git clone git://github.com/creationix/nvm.git /usr/local/nvm
$ echo "if [[ -s /usr/local/nvm/nvm.sh ]];" >> /etc/profile
$ echo " then source /usr/local/nvm/nvm.sh" >> /etc/profile
$ echo "fi" >> /etc/profile
$ source /etc/profile
$ nvm install v8.4.0
$ chmod -R a+w /usr/local/nvm
$ npm install -g yarn
```


