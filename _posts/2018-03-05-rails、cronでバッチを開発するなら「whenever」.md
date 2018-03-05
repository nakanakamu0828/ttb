---
layout: post
thumbnail: /images/uploads/ruby_on_rails.png
title: Rails、cronでバッチを開発するなら「Whenever」
description: railsにwheneverをインストールし、セットアップしていきます。
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
  - whenever
---
こんにちは、なかむです。  

今回はRailsのプロジェクトに、[javan/whenever](https://github.com/javan/whenever)を組み込んでいきます。 　
定期バッチを利用する為に、wheneverを利用しています。

## インストール

`Gemfile`に以下の設定を追加
```
gem 'whenever', require: false
```

`bundle install`コマンドでインストール

```
$ bundle install
or
$ bundle install --path=vendor/bundle
```

※ 環境に合わせてプロジェクト配下にインストールするかどうかでコマンドを選択してください。


## 設定ファイルの作成
以下のコマンドを実行することで、設定ファイルが作成されます。
```
bundle exec wheneverize .
```

`./config/schedule.rb`ファイルが作成されたことを確認してください。  
今回はサンプルを記載します

```config/schedule.rb
require File.expand_path(File.dirname(__FILE__) + "/environment")
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"


# 1分毎に実行
# every 1.minute do
# end

# 1分毎に実行
# every 1.hours do
# end

# 毎時間 00分に実行
#every :hour, at: 00 do
#end

# 毎日5時に実行
#every 1.day, :at => '5:00 am' do
#end

# 毎日4時半と6時半に実行
#every 1.day, at: ['4:30 am', '6:00 pm'] do
#end

# 27~31日の00:00に実行
#every '0 0 27-31 * *' do
#end

# コマンド実行例
#every 1.minute do
#  runner "MyModel.process"
#  rake "my:rake:task"
#  command "/usr/bin/my_command"
#end
```

## cronへの反映
■ 設定を確認する
```
$ bundle exec whenever
```

■ 設定反映  
□ development（開発環境）  
```
bundle exec whenever --update-crontab
```


□ production（商用環境）  
```
RAILS_ENV=production bundle exec whenever --update-crontab
```

■ 設定削除  
```
bundle exec whenever --clear-crontab
```
