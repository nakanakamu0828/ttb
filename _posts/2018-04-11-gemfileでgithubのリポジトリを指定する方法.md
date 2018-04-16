---
layout: post
thumbnail: /images/uploads/ruby_on_rails.png
title: Gemfileでgithubのリポジトリを指定する方法
description: Gemfileでgithubのリポジトリを指定し、gemをインストールする際の記載方法をまとめます。
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
  - globalize
---
こんにちは、なかむです。  
Rails5.2が正式リリースされましたね。  
gemによっては、v5.2.0に対応できていないものもあります。  
以前私がブログで投稿した"Globalize"というgemも未対応のようです。

[Globalizeの記事はこちら](https://tech-talk-blog.ml/programming/2018/02/25/%E4%BB%8A%E6%9B%B4%E6%94%B9%E3%82%81%E3%81%A6-ruby-on-rails%E3%81%AE%E9%96%8B%E7%99%BA%E3%82%92%E8%A1%8C%E3%81%86-part6.html)


Globalizeをforkして一旦5.2.0で動作確認できるように対応しました。
その際に、Gemfileでgitのブランチを指定する方法を学んだのでメモを残します。


```bash

# Gemfile
gem 'globalize'

# githubのURLを指定
gem 'globalize', git: 'https://github.com/globalize/globalize'


# forkしたリポジトリを指定する
gem 'globalize', git: 'https://github.com/nakanakamu0828/globalize'

# forkしたリポジトリのブランチまで指定する
gem 'globalize', git: 'https://github.com/nakanakamu0828/globalize', branch: 'feature/v5.2.0'

```

"Globalize"については既にissues、PRがありました。
masterにマージされるまでの辛抱ですね。

https://github.com/globalize/globalize/issues/676
