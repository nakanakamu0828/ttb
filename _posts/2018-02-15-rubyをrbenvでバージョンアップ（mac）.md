---
layout: post
thumbnail: /images/uploads/command_rbenv.png
title: rubyをrbenvでバージョンアップ（Mac）
description: Macでrubyを最新バージョンにアップグレードします。
location: Hong Kong
categories:
  - Infrastructure
tags:
  - ruby
  - rbenv
---
こんばんは、なかむです。
久しぶりに部屋にしまったままのMacBook Airを取り出しこの記事を書いています。

```
$ ruby -v
ruby 2.3.3p222 (2016-11-21 revision 56859) [universal.x86_64-darwin17]
```

あ、rubyのバージョンが古い・・・
最新版にアップグレードをしたい。

```
$ rbenv -version
-bash: rbenv: command not found
```

え！ rbenv入ってない・・・
最近はサーバーも全てrubyの環境はrbenvで管理しています。MacBook Airにはrbenvが入ってないことに少しビックリしました。

それではインストールしていきます。

```
$ brew update
$ brew install rbenv ruby-build
```

続いてrubyのバージョンを確認
```
$ rbenv install --list
```

今回は2.5.0をインストールします。
```
$ rbenv install 2.5.0
$ rbenv global 2.5.0
$ sudo gem install railties && rbenv rehash
```

環境によってはpathを通す必要があるかもしれません。
