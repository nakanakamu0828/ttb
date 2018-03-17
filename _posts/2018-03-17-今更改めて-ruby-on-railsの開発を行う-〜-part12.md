---
layout: post
thumbnail: /images/uploads/ruby_on_rails.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part12
description: sitemap_generatorを導入してサイトマップXMLを作成仕様
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
  - sitemap_generator
---
こんばんは、なかむです。  
今回は[kjvarga/sitemap_generator](https://github.com/kjvarga/sitemap_generator)というgemを利用して、サイトマップXMLを自動生成したいと思います。


# sitemap_generator インストール

まずはGemfileにsitemap_generatorの設定を追加します
```
            
# Gemfile
gem 'sitemap_generator'

```

続いてbundle installコマンドを実行し、ライブラリをインストールしてください。
```bash

$ bundle install
or
$ bundle install --path=vendor/bundle

```

※ 環境に合わせてプロジェクト配下にインストールするかどうかでコマンドを選択してください。


# セットアップ
以下のコマンドで設定ファイル`config/sitemap.rbを作成します。
```bash
      
$ rails sitemap:install

```    

以下のコマンドを実行することでサイトマップが生成されます。
```bash

$ rails sitemap:refresh

```

`public/sitemap.xml.gz`が生成されたことを確認してください。  
こちらのファイルは、git管理しません。.gitignoreに除外するよう設定しましょう。  
以下のように`.gitignore`へ追加することで除外できます。

```

# .gitignore
public/sitemap.xml.gz


```

