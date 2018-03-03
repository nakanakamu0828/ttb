---
layout: post
thumbnail: /images/uploads/ruby_on_rails.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part7
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

というように利用者によってtimezoneの表示を変えるケースも出てきます。
まずは、アクセス元からtimezoneを取得する方法を学んでいきます。
