---
layout: post
thumbnail: /images/uploads/screen_tinypng_api.png
title: Rubyを使ってTinypngのDeveloper APIで圧縮する方法
description: 今までTinypngのWEBサイトから圧縮処理をしていましたが、rubyのスクリプトに変更
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - tinyping
---
こんばんは、なかむです。

今回は、TinypingのDeveloper APIを利用して圧縮処理を行います。
ツールとしてうまく組み込むことで圧縮処理の効率化を行い、サービスへの負荷を減らすことが目的です。
Rubyを使ってスクリプトを作成していきます。

まずはAPI KEYをTinypingの [DEVELOPER API](https://tinypng.com/developers) ページから発行します。

1. 名前、メールアドレスを入力し、`Get your API key`ボタン押下
2. 入力したメールアドレスにTinypingからメールが届きます。その中のURLをクリックし、認証を完了させます。
3. ログイン後の画面にAPI KEYが表示されます

それではサンプルプロジェクトを作成します。

```
$ mkdir -p tinify-sample
$ cd tinify-sample
$ touch Gemfile
$ echo 'source "https://rubygems.org"' >> Gemfile
$ echo 'gem "tinify"' >> Gemfile
$ bundle install --path vendor/bundler
```

続いてスクリプト(tinify.rb)を作成します。
以下の内容でファイルを作成してください。

```tinify.rb
require "bundler/setup"
require "tinify"
Tinify.key = ENV["TINIFY_API_KEY"]

return if ARGV.empty?

filepath = ARGV[0]
return unless File.exists?(filepath)

source = Tinify.from_file(filepath)
source.to_file(filepath)
```

最初に作成したTinypingのAPI KEYを指定してスクリプトを実行します。

* 環境変数として TINIFY_API_KEY を指定します。
* スクリプトの第１引数に圧縮したい画像のパスを指定します。


```
$ TINIFY_API_KEY=[API KEY] ruby lib/tinify.rb [filepath]
```

実行が完了したら画像が圧縮しているか確認します。
他にもネット上の画像を圧縮し、ローカルに保存する機能などが用意されています。色々な機能を利用し、あなたにあったツールとして利用しましょう。
