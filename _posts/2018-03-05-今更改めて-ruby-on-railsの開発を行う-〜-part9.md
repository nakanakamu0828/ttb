---
layout: post
thumbnail: /images/uploads/ruby_on_rails.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part9
description: sorceryを利用したユーザー認証処理
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
  - sorcery
---
こんにちは、なかむです。

今回はsorceryを利用したユーザー認証処理を実装していきます。
まずは`Gemfile`に`sorcery`の設定を追加します

## sorceryインストール

```Gemfile
# Gemfile
gem 'sorcery'
```

続いて`bundle install`コマンドを実行し、ライブラリをインストールしてください。

```
$ bundle install
or
$ bundle install --path=vendor/bundle
```

※ 環境に合わせてプロジェクト配下にインストールするかどうかでコマンドを選択してください。

## sorceryのセットアップ

sorceryのテンプレートを作成します
```
$ rails g sorcery:install

      create  config/initializers/sorcery.rb
    generate  model User --skip-migration
      invoke  active_record
      create    app/models/user.rb
      insert  app/models/user.rb
      insert  app/models/user.rb
      create  db/migrate/20180305075527_sorcery_core.rb
```

※ 作成されたファイルを確認してみてください。
