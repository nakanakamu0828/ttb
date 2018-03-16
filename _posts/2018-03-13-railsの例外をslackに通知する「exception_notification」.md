---
layout: post
thumbnail: /images/uploads/slack_logo.png
title: Railsの例外をSlackに通知「exception_notification」
description: 「exception_notification」を利用して、Railsの例外をSlackに通知します。
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
  - slack
  - exception_notification
---
こんにちは、なかむです。  
今回はRailsの例外をSlackに通知したいと思います。  
「exception_notification」と「slack-notifier」の2つのgemを組み合わせて実装していきます。


# exception_notification, slack-notifier インストール

まずはGemfileに`exception_notification`, `slack-notifier`の設定を追加します
```ruby
   
# Gemfile
gem 'exception_notification'
gem 'slack-notifier'

```


続いてbundle installコマンドを実行し、ライブラリをインストールしてください。
```bash

$ bundle install
or
$ bundle install --path=vendor/bundle

```

※ 環境に合わせてプロジェクト配下にインストールするかどうかでコマンドを選択してください。

# セットアップ
以下のコマンドから設定ファイルのテンプレートを生成します。

```bash

$ rails g exception_notification:install

```
`config/initializers/exception_notification.rb`という設定ファイルが生成されます。  
以下のようなSlack通知用の設定に変更しましょう。

```ruby

# config/initializers/exception_notification.rb
require 'exception_notification/rails'

ExceptionNotification.configure do |config|
  config.add_notifier :slack, {
    :webhook_url => "webhooks url",
    :channel => "#グループ"
  }
end

```

# Slackから`webhooks url`を取得

1. `https://[利用するSlack名].slack.com/apps`をブラウザで開く
2. 検索窓から`Incoming WebHooks`を検索し選択します。
3. `Add Configuration`をクリック
4. `Post to Channel`にて対象のチャンネルを選択
5. URLが生成され、設定画面が表示されます。こちらのURLを`webhooks url`として利用します。アイコンや名称などご自身の環境に合わせて修正してください。

# application_controller.rbで例外をキャッチする
`application_controller.rb`に例外のハンドリング処理を追加します。以下はサンプルとなります。

```ruby

#app/controllers/application_controller.rb
rescue_from Exception, with: :server_error

...

def server_error(e)
  ExceptionNotifier.notify_exception(e, :env => request.env, :data => {:message => "error"})
  respond_to do |format|
    format.html { render template: 'front/errors/500', layout: 'front/layouts/error', status: 500 }
    format.all { render nothing: true, status: 500 }
  end
end

```
