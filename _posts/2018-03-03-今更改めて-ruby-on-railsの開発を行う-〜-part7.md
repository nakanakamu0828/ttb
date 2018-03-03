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

まずは`Gemfile`に`cjheath/geoip`を追加します。
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





