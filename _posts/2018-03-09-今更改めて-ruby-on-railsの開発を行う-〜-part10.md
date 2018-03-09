---
layout: post
thumbnail: /images/uploads/ruby_on_rails.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part10
description: Dos攻撃を防ぐためにrack-attackを導入しよう
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
  - rack-attack
---
こんにちは、なかむです。

今回は[kickstarter/rack-attack](https://github.com/kickstarter/rack-attack)というgemを利用して、Dos攻撃に対する対策を取りたいと思います。nginxなどWEBサーバー側での対策が必要だと思いますが、Saasのサービスなどを利用している場合、WEBサーバー側で設定することができません。今回はアプリケーションサーバーとなるRails側の対策を行なっていきます。


# rack-attack インストール
まずはGemfileにrack-attackの設定を追加します

```ruby

# Gemfile
gem 'rack-attack'

```

続いてbundle installコマンドを実行し、ライブラリをインストールしてください。

```bash

$ bundle install
or
$ bundle install --path=vendor/bundle

```
※ 環境に合わせてプロジェクト配下にインストールするかどうかでコマンドを選択してください。


# セットアップ
`config/application.rb`でrack-attackを有効化します。  
`class Application < Rails::Application`の中に以下の行を追加してください。

```ruby

# config/application.rb
config.middleware.use Rack::Attack

```

`config/initializers/rack_attack.rb`を作成し設定を行います。

```ruby

# config/initializers/rack_attack.rb

class Rack::Attack
  # your custom configuration...
end

```

#　アクセス制限 : ブラックリスト設定

```ruby

# 1.2.3.4からのアクセスを拒否する
Rack::Attack.blocklist('block 1.2.3.4') do |req|
  '1.2.3.4' == req.ip
end

# BadUAが含まれたUserAgentからのログイン画面アクセスを拒否する
Rack::Attack.blocklist('block bad UA logins') do |req|
  req.path == '/login' && req.post? && req.user_agent == 'BadUA'
end

```
例えば、管理画面のアクセス制限や対象外の国からのアクセスを防ぐのに利用できます。

# アクセス制限 : ホワイトリスト設定

```ruby

Rack::Attack.safelist('allow from localhost') do |req|
   '127.0.0.1' == req.ip || '::1' == req.ip
end

```

# アクセス制限 : アクセス回数による制御

```ruby

# 同一IPアドレスからのリクエストを5回/秒に制限
Rack::Attack.throttle('req/ip', limit: 5, period: 1.second) do |req|
  req.ip
end

# 同一IPアドレスからのリクエストを100回/分に制限
Rack::Attack.throttle('req/ip', :limit => 100, :period => 1.minutes) do |req|
  req.ip
end


```

アタックや過度なクローリングの対策として組み込んでみましょう。
他にも制限された際のレスポンスを変更したり、トラッキングしたりできるようです。実際に利用した確認してみてください。


今回の成果物は [こちら](https://github.com/nakanakamu0828/netshop/tree/v0.10) になります。  
`rack-attack`の設定部分はコメントアウトしています。
