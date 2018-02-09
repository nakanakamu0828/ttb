---
layout: post
thumbnail: /images/uploads/rails.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part2
description: 新しいRailsフロントエンド開発を実践してみる
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
---
こんばんわ、なかむです。  

前回はRuby On Railsの環境構築を行いました。  
今回は実際にRailsの開発環境を整備していきます。webpackを導入したので新しい概念で開発を行いたいと思い、

[新しいRailsフロントエンド開発（1）Asset PipelineからWebpackへ（翻訳）](https://techracho.bpsinc.jp/hachi8833/2017_12_26/49931)

を参考にさせて頂きます。
それでは初めてきましょう。


まずは、ブラウザ互換処理対策としてbrowserslistの設定を行います。
詳しくは、 [Autoprefixerの仕組み](https://qiita.com/morishitter/items/ffe56a2145f2b225675c) をご確認ください。  
プロジェクトルートに以下のファイルを作成します。

```
$ touch .browserslistrc
$ echo '> 1%' >> .browserslistrc
```

次に`application.rb`を開いて以下の行を追記します。

```config/application.rb
config.generators do |g|
  g.test_framework  false
  g.stylesheets     false
  g.javascripts     false
  g.helper          false
  g.channel         assets: false
end
```

`app/assets`は利用しないので削除します。
続いてシステムの構成を変更していきます。

1. `app/javascript`を`frontend`にディレクトリ名を変更し、プロジェクトルートに移動します。

```
$ mv app/javascript ./frontend
```

2. `application.html.erb`を以下のように変更します。

```app/views/layouts/application.html.erb
<!DOCTYPE html>
<html>
  <head>
    <title>Netshop</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_pack_tag 'application' %>
  </head>

  <body>
    <%= yield %>
    <%= javascript_pack_tag "application" %>%
  </body>
</html>
```

* `javascript_include_tag "application"` → `javascript_pack_tag "application"` に変更  
* `stylesheet_link_tag 'application', media: 'all'` → `stylesheet_pack_tag 'application'` に変更

3. `webpacker.yml` を以下のように変更します。

```config/webpacker.yml
default: &default
  source_path: frontend  <-- ここを修正
  source_entry_path: packs
  public_output_path: packs
  cache_path: tmp/cache/webpacker

```

4. frontendディレクトリ配下に置かれるパーシャルが読み込めるように、application_controller.rbを変更します。

```app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  prepend_view_path Rails.root.join("frontend") <-- 追加
end
```

5. JSコードやCSSコードの変更時にページを自動更新するために、Procfileを作成ます。また、foremanを利用するためインストールを行います。

```
$ touch Procfile
$ echo 'server: bundle exec puma' >> Procfile
$ echo 'assets: bin/webpack-dev-server' >> Procfile
$ gem install foreman
```
