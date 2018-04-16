---
layout: post
thumbnail: /images/uploads/command_nodebrew_1.png
title: Macのnode.jsをnodebrewで管理する
description: Macにnode.jsをnodebrewで管理する
location: Hong kong
categories:
  - Infrastructure
tags:
  - mac
  - node.js
  - nodebrew
---
こんにちは、なかむです。  
今回はNode.jsの管理を`nodebrew`に移行しようと思います。  

# 既にnode.jsがインストールされている場合削除します
## node.jsがインストールされているか確認
以下のコマンドでnode.jsがインストールされているか確認してください。  
バージョンが表示されればインストールされている状態になります。

```command

$ node -v

```

私の環境では、homebrewで既にnode.jsがインストールされていました。  
homebrewでインストールされているものは削除していきます。


## npmのアンインストール
以下のコマンドからアンインストールしてください。

```command

$ sudo npm uninstall npm -g

```


## yarnのアンインストール
yarnを利用しているPJもあるので、yarnを先にアンインストールしておきます。以下のコマンドからアンインストールしてください。

```command

$ brew uninstall yarn

```


## node.jsのアンインストール
以下のコマンドからアンインストールしてください。

```command

$ brew uninstall --force node

```
※ node.jsを複数バージョンで管理している場合、`--force`オプションをつけて全てのバージョンを削除しましょう。


それぞれどのようにnodeをインストールしたかによってアンインストールの方法も変わってきます。皆さんの環境に合わせて方法を模索しましょう。今回はhomebrewからインストールした場合のアンインストール方法でした。  

# nodebrewインストール
[公式github](https://github.com/hokaccha/nodebrew)を参考にしてインストールしていきます。

以下のコマンドからインストールしましょう
```command

$ curl -L git.io/nodebrew | perl - setup
$ vi ~/.bash_profile

#以下を追加（nodebrewにパスを通します）
export PATH=$HOME/.nodebrew/current/bin:$PATH

$ source ~/.bash_profile

# nodebrew helpでヘルプの詳細が見れればインストールは完了です
$ nodebrew help

```

# node.jsインストール
以下のコマンドからnode.jsをインストールします。  
元の環境がv8だったので今回は8系の最新となるv8.11.1をインストールします。

```command

$ nodebrew install v8.11.1
$ nodebrew use v8.11.1

```
2018/04/16時点では、`v9.11.1`が最新となっています。  
`nodebrew ls-remote`で確認することができます。

# yarnインストール
以下のコマンドからyarnをインストールします。

```command

$ npm install -g yarn

```

以上でnodebrewへの移行が完了です。

# 最後に
最近色々なPJに参加させて頂き思うのが、Macに環境を作ってしまうとPJによってバージョンが異なったりするので依存関係の解消が大変・・・  
PHPやRubyでWEB開発する際は、Docker, Vagrantを利用してコンテナ or 仮想環境を作った方がいいですよね。
Mac内ではシンプルにフロントエンドの開発ライブラリのみにしようとしています。
