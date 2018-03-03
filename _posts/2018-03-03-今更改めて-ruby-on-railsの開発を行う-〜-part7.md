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
```

## `rails c`でGeoIPを確認
`rails c`でコンソールを起動し、GeoIPを利用してホスト/IPアドレスの位置情報を取得してみます

```
$ rails c
irb(main):001:0>
irb(main):002:0> geoip = GeoIP.new(Rails.root.join( "data/geoip/GeoIP.dat"))
irb(main):003:0> code = c.country_code2.downcase
=> "jp"
irb(main):004:0> tz = TZInfo::Country.get(c.country_code2)
=> #<TZInfo::Country: JP>
irb(main):005:0> tz.zone_identifiers
=> ["Asia/Tokyo"]

```
「IPアドレスから位置（国）の情報を取得→国情報からtimezoneを取得」という流れでデータを取得しています。

## WEBサイトの初期アクセス時にtimezoneを設定する
続いてはWEBサイト側で実装していきましょう。








