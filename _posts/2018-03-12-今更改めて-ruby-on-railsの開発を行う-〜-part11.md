---
layout: post
thumbnail: /images/uploads/ruby_on_rails.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part11
description: meta-tagsを導入してSEO対策をしよう
location: Hong Kong
categories:
  - Programmin
tags:
  - ruby
  - ruby on rails
  - meta-tags
---
こんにちは、なかむです。

今回は[kpumuk/meta-tags](https://github.com/kpumuk/meta-tags)というgemを利用して、SEO対策を行いたいと思います。

# meta-tags インストール
まずはGemfileにrack-attackの設定を追加します
```ruby
      
# Gemfile
gem 'meta-tags'

```
    
続いてbundle installコマンドを実行し、ライブラリをインストールしてください。
```bash

$ bundle install
or
$ bundle install --path=vendor/bundle

```
※ 環境に合わせてプロジェクト配下にインストールするかどうかでコマンドを選択してください。


# セットアップ
以下のコマンドで初期化ファイル`config/initializers/meta_tags.rb`を作成します。

```bash

$ rails g meta_tags:install

```

今回は以下のような内容にしました。
```ruby

MetaTags.configure do |config|
  config.title_limit        = 70
  config.description_limit  = 300
end

```
* title_limit : タイトルタグの文字数
* description_limit : metaのdescriptionの文字数

※ googleの検索エンジンはkeywodsをみていないようなので今回はスルーします。

# 各ファイルの設定
今回はhelperを利用してmeta_tagsのデフォルトの値を設定したいと思います。`app/helpers/application_helper.rb`に以下のメソッドを追加します。


## app/helpers/application_helper.rb

```ruby

# app/helpers/application_helper.rb
def default_meta_tags
    sitename = I18n.t('site.sitename')
    title = I18n.t('site.meta_tag.title', { sitename: sitename })
    description = I18n.t('site.meta_tag.description', { sitename: sitename })
    {
        site: title,
        title: title,
        description: description,
        charset: 'utf-8',
        keywords: [],
        reverse: true,
        og: {
        url: request.url,
        title: title,
        description: description,
        site_name: site,
        type: 'article',
        },
        twitter: {
        card: 'summary',
        site: '@nakanakamu0828',
        title: title.presence || site,
        description: description,
        image: image
        }
    }
end

```

翻訳ファイルにmeta_tag用の設定を追加します。

## config/locales/defaults/ja.yml
```yaml

# config/locales/defaults/ja.yml
ja:
  site:
    # 以下を追加
    sitename: "Online Shop"
    meta_tag:
      title: "%{sitename}: ショッピングを楽しむWEBサイトです"
      description: "ショッピングサイト「%{sitename}」は、素早く、簡単に色々なものを購入できるショッピングサイトです。"
 　 # ここまで
    title: "オンラインショップ"
  date:
    formats:
      default: "%Y/%m/%d"
      long: "%Y年%m月%d日(%a)"
      short: "%m/%d"
  time:
    formats:
      default: "%Y/%m/%d %H:%M:%S"
      long: "%Y年%m月%d日(%a) %H時%M分%S秒 %z"
      short: "%y/%m/%d %H:%M"

```


## config/locales/defaults/en.yml
```yaml

# config/locales/defaults/en.yml
en:
  site:
    # 以下を追加
    sitename: "Online Shop"
    meta_tag:
      title: "%{sitename}: The Shopping Website"
      description: "This is %{sitename}. The fast and easy way to buy almost anything."
 　 # ここまで
    title: "Online Shop"
  date:
    formats:
      default: "%m/%d/%Y"
      long: "%B %d, %Y"
      short: "%m.%d.%y"
  time:
    formats:
      default: "%m/%d/%Y %H:%M:%S"
      long: "%B %d, %Y %H時%M分%S秒 %z"
      short: "%m.%d.%y %H:%M"

```
※ 内容は仮となります。


## meta_tag設定
続いて、レイアウトhtmlにmeta_tagの読み込みを追加します。  
`app/views/layouts/application.html.erb`にタグを追加します。meta_tagライブラリがtitleタグを生成するので、titleタグは削除しましょう。

```html

<!-- app/views/layouts/application.html.erb -->
<%= display_meta_tags default_meta_tags %>

```

## 各ページでtitle, descriptionを変更
以下のように各ページのhtmlに設定することで、title, descriptionを変更することができます。

```html

<% set_meta_tags title: "ログインページ" %>
<% set_meta_tags description: "Online Shop のログインページです" %>

```


