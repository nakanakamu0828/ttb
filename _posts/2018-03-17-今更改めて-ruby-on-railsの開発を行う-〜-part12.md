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
  - sitemap.xml
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
## 設定ファイル生成
以下のコマンドで設定ファイル`config/sitemap.rbを作成します。
```bash
      
$ rails sitemap:install

```

## sitemap.rb設定例

```ruby

# URLベースを指定。本番でしか利用しないので、本番のURLを直接記載で問題ない気がします。
SitemapGenerator::Sitemap.default_host = "http://www.example.com"

SitemapGenerator::Sitemap.create do

  # '/items' を追加する
  add items_path, :priority => 0.7, :changefreq => 'daily'

  # '/items/:id' を追加する
  Item.find_each do |item|
    add item_path(item), :lastmod => item.updated_at
  end

end

```
※ こちらの例はリポジトリには含めていません。

## sitemap.xml.gz生成
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

# cronで定期的にサイトマップXMLを更新する
`whenever`を利用してサイトマップXMLを更新したいと思います。  
インストールやセットアップについては、以前の投稿 [Rails、cronでバッチを開発するなら「Whenever」](/programming/2018/03/05/rails-cronでバッチを開発するなら-whenever.html) で利用方法をまとめています。ご確認ください。


生成コストも低いので毎時更新するように設定します。`config/schedule.rb`ファイルに以下の設定を追加します。

```ruby

every :hour, at: 00 do
    rake '-s sitemap:refresh'
end

```

本番サーバーにてサイトマップXMLを生成するように`whenever`の設定をしてみましょう。


# 最後に
どのようなサイトマップXMLが効果的なのか、今後別途調査していきたいと思っています。

今回の成果物は [こちら](https://github.com/nakanakamu0828/netshop/tree/v0.12) になります。
