---
layout: post
thumbnail: /images/uploads/screen_jekyll.png
title: 'Jekyllでjs, cssをminifyする'
description: 'digitalsparky/jekyll-minifierを利用してjs, cssをminifyする'
location: Tokyo
categories:
  - Blog
tags:
  - jekyll
  - jekyll-minifier
---
こんばんは、なかむです。  
jekyllはデフォルトだとjs, cssがminify（圧縮）されないみたいだったので、[digitalsparky/jekyll-minifier](https://github.com/digitalsparky/jekyll-minifier)を利用して簡単に実装します。

本当に簡単でplugin組み込みするだけでした・・・


# gemをインストール
`Gemfile`に`jekyll-minifier`を追加します。

```ruby

#Gemfile

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.6"
  gem 'jekyll-sitemap'
  gem 'jekyll-pwa-plugin'
  gem 'jekyll-minifier' <--- これを追加
end

```

続きて`bundle install`コマンドを実行し、gemをインストールします

```bash

$ bundle install 
or
$ bundle install --path vendor/bundler

```
※ プロジェクト配下にインストールするかどうかでコマンドを変えてください。

# _config.ymlに設定を追加
`_config.yml`ファイルの`plugins`に`jekyll-minifier`の設定を追加します。

```yaml

# _config.yml
plugins:
  - jekyll-feed
  - jekyll-sitemap
  - jekyll-minifier <--- これを追加

```

ここまで準備できたらあとはjekyllをbuild & 起動し直すだけです。
js, cssが圧縮してるか確認してみましょう。

さらに詳しく知りたい方は、以下のgithubリポジトリをご確認ください。

<https://github.com/digitalsparky/jekyll-minifier>
