---
layout: post
thumbnail: /images/uploads/ruby_on_rails.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part8
description: timezoneを意識して開発をしよう
location: Tokyo
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
  - timezone
---
こんにちは、なかむです。  

今回はtimezoneについて学んでいきます。
日本向けにサービスを展開している際は、`Asia/Tokyo`に固定してしまうかと思います。
phpなら`php.ini`、Ruby On Railsなら`application.rb`に設定を記述しますね。

複数の国に対してサービス展開する際は、

* アクセス元からデフォルトとなるtimezoneを設定
* ユーザーにtimezoneを設定させる

というように利用者によってtimezoneを変える必要が出てきます。
まずは、アクセス元からtimezoneを取得する方法を学んでいきましょう。

[cjheath/geoip](https://github.com/cjheath/geoip) というライブラリを利用してIPアドレスから位置情報を取得します。  
そして、位置情報から適したtimezoneを設定してみましょう。

## `cjheath/geoip`インストール

`Gemfile`に`cjheath/geoip`を追加します。
```Gemfile
gem "geoip"
```

続いて`bundle install`コマンドを実行し、ライブラリをインストールしてください。

```
bundle install
or
bundle install --path=vendor/bundle
```
※ 環境に合わせてプロジェクト配下にインストールするかどうかでコマンドを選択してください。


## GeoIP.datファイルのセットアップ
Geoのデータベースファイルとして、GeoIP.datが用意されています。  
そちらをダウンロードしてプロジェクト内にセットアップしていきましょう。

```
$ mkdir -p data/geoip
$ cd data/geoip
$ wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
$ gzip -d GeoIP.dat.gz
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
$ gzip -d GeoLiteCity.dat.gz
```
※ 今回はCityの情報をメインで利用しますが、GeoIP.dat.gzも合わせてダウンロードしておきましょう。

## `rails c`でGeoIPを確認
`rails c`でコンソールを起動し、GeoIPを利用してホスト/IPアドレスの位置情報を取得してみます

```
$ rails c
irb(main):001:0> c = GeoIP.new('data/geoip/GeoLiteCity.dat').city('www.yahoo.co.jp')
irb(main):002:0> c.timezone
=> "Asia/Tokyo"
```
こちらは、Yahoo(www.yahoo.co.jp)のホスト名からtimezoneを取得した例になります。

## WEBサイトの初期アクセス時にtimezoneを設定する
続いてはWEBサイト側で実装していきましょう。  
どの画面にアクセスがあっても判定させたいので、`app/controllers/application_controler.rb`に処理を記載します。  
以下のように変更してください。

```app/controllers/application_controler.rb
# app/controllers/application_controler.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  prepend_view_path Rails.root.join("frontend")

  before_action :init_category
  before_action :init_timezone

  def init_category
    @categories = Category.where(state: true).where(parent: nil).order(id: :asc)
  end

  # 
  # セッションにtimezoneが設定されていない場合、GeoIPを利用してアクセス元のIPアドレスからtimezoneを設定する
  # 
  def init_timezone
    if session[:timezone].blank?
      c = GeoIP.new('data/geoip/GeoLiteCity.dat').city(request.remote_ip)
      Time.zone = c.timezone unless c.nil?

      session[:timezone] = Time.zone.name
    end
  end
end
```

将来的には、`init_timezone`メソッド内でユーザーのログインチェックを行い、ログインしている場合はユーザーが設定したtimezoneを反映という形に変更していきく予定です。

今回の実装はローカル環境では、timezoneの切り替えが確認できません。
開発サーバーを用意した際に確認してみましょう。
一旦、実装までをまとめさせて頂きました。


今回の成果物は [こちら](https://github.com/nakanakamu0828/netshop/tree/v0.8) をご確認ください。




