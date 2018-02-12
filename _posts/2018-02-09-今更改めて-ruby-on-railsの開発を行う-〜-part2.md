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
今回は実際にRailsの開発環境を整備していきます。webpackを導入したので新しい概念としてコンポーネント指向による開発を行いたいと思います。


[新しいRailsフロントエンド開発（1）Asset PipelineからWebpackへ（翻訳）](https://techracho.bpsinc.jp/hachi8833/2017_12_26/49931)

を参考にさせて頂きます。それでは初めていきましょう。

## システム構成の変更

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
    <%= javascript_pack_tag "application" %>
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

## セットアップの確認

新しい構成が機能するか確認していきます。
それではホーム画面用のリソースを生成します。

```
$ rails g controller homes
```

以下のようにcontroller, view, routes.rb, js, cssを追加・変更してください。

```config/routes.rb
Rails.application.routes.draw do
  root to: "homes#show" <-- 追加
end
```

```frontend/packs/application.js
import "./application.css";
document.body.insertAdjacentHTML("afterbegin", "Webpacker works!");
```

```frontend/packs/application.css
html, body {
  background: lightyellow;
}
```

```app/controllers/homes_controller.rb
class HomesController < ApplicationController

    def show
    end

end
```

`views/homes/show.html.erb`は空で作成します

## アプリ起動

```
$ bundle binstubs bundler --force
$ foreman start
```

![Rails サンプル画面](/images/uploads/screen_rails_sample_201802100114.png)

こちらの画面が表示できれば成功です。


## JSLint, CSSLintの導入
`package.json` にESLintを追加します。以下のように変更してください。

```package.json
{
  "name": "netshop",
  "private": true,
  "dependencies": {
    "@rails/webpacker": "^3.2.1"
  },
  "devDependencies": {
    "webpack-dev-server": "^2.11.1",
    // 以下を追加
    "babel-eslint": "^8.0.1",
    "eslint": "^4.8.0",
    "eslint-config-airbnb-base": "^12.0.1",
    "eslint-config-prettier": "^2.6.0",
    "eslint-import-resolver-webpack": "^0.8.3",
    "eslint-plugin-import": "^2.7.0",
    "eslint-plugin-prettier": "^2.3.1",
    "lint-staged": "^4.2.3",
    "pre-commit": "^1.2.2",
    "prettier": "^1.7.3"
  }
}
```

Lintの適応ルールとして`.eslintrc`ファイルを作成します。

```.eslintrc
{
  "extends": ["eslint-config-airbnb-base", "prettier"],
  "plugins": ["prettier"],
  "env": {
    "browser": true
  },
  "rules": {
    "prettier/prettier": "error"
  },
  "parser": "babel-eslint",
  "settings": {
    "import/resolver": {
      "webpack": {
        "config": {
          "resolve": {
            "modules": ["frontend", "node_modules"]
          }
        }
      }
    }
  }
}
```

次にCSSLintの設定です。  
`package.json`の`devDependencies`内に以下を追加します。
```package.json
"devDependencies": {
    ...
    "stylelint": "^8.1.1",
    "stylelint-config-standard": "^17.0.0"
}
```

Lintの適応ルールとして`.stylelintrc`ファイルも作成します。
```.stylelintrc
{
  "extends": "stylelint-config-standard"
}
```

`package.json`の`dependencies`配下にnormalize.cssを追加します。


次は`git hooks`を導入し、git commit時に自動チェックが走るようにしましょう。`package.json`に"scripts"を追加します。

```package.json
・・・
"scripts": {
  "lint-staged": "$(yarn bin)/lint-staged"
},
"lint-staged": {
  "config/webpack/**/*.js": [
    "prettier --write",
    "eslint",
    "git add"
  ],
  "frontend/**/*.js": [
    "prettier --write",
    "eslint",
    "git add"
  ],
  "frontend/**/*.css": [
    "prettier --write",
    "stylelint --fix",
    "git add"
  ]
},
"pre-commit": [
  "lint-staged"
],
・・・
```
これで、コミット時にstagedファイルのエラーがすべてチェックされ、自動整形されます。
ここまでできたら`yarn`で追加したライブラリをインストールしましょう

```
$ yarn
```

`frontend/packs/application.js`を修正し、`git add . && git commit -m "testing JS linting"`を実行します。  
チェック処理が実行されることを確認してください。


今回はここまでになります。  
次回は実際にコンポーネントの作成に入っていきたいと思います。

今回の成果物は [こちら](https://github.com/nakanakamu0828/netshop/tree/v0.2) をご確認ください。
