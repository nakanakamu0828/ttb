---
layout: post
thumbnail: /images/uploads/screen_site_multi_lang_en_20180214022016.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part5
description: 多言語のアプリに対応する
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
  - i18n
---
こんばんは、なかむです。  
今回はRailsアプリの多言語対応を試していきたいと思います。

## 言語の切り替え方法について

切り替え方法は大きく４つあります。

1. サブドメインから言語を選択
2. サブディレクトリから言語を選択
3. パラメータとして言語を選択
4. HTTPヘッダーのAccept-Languageから言語を選択（ブラウザの言語に依存）

今回は１の「サブドメインから言語を選択」を利用したいと思います。
システム的にはサブドメインで切り替える場合、サブドメイン毎にサーバーを分けることができるので分散させやすいというメリットもあります。

サブドメインによるlocaleの管理は、[subdomain_locale](https://github.com/semaperepelitsa/subdomain_locale) というgemを利用したいと思います。

## subdomain_localeのインストール

Gemfileに `gem "subdomain_locale"` を追加して `bundle install` します。

## Railsに言語設定を追加

`config/application.js`に利用する言語を設定していきます。

```config/application.js
config.i18n.enforce_available_locales = true
config.i18n.available_locales = 'en', 'ja'

config.default_locale = :en
config.i18n.default_locale = :en

# 翻訳ファイルのディレクトを追加
config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
```

今回は英語と日本語の２カ国語とします

## 翻訳ファイルのディレクトリ構造を整理

モデル、view、それ以外に利用するdefaultの3ディレクトリを用意します。

```
$ mkdir -p config/locales/{defaults,models,views}
$ mv config/locales/en.yml config/locales/defaults/
```

デフォルトで用意されていた`config/locales/en.yml`は`config/locales/defaults/`に移動しておきます。
また、`config/locales/defaults/ja.yml`ファイルも作成しておきましょう。内容は以下の通りです。

```config/locales/defaults/en.yml
en:
  site:
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

```config/locales/defaults/ja.yml
ja:
  site:
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

site.titleの部分は、言語切り替えの確認時に利用します。

### ヘッダーに言語切り替えリンクを設置

今回はselectタグで言語を切り替えられるようにします。
ヘッダーに以下のselect文を追加してください。

```frontend/layouts/site/_site.html.erb
<%# frontend/layouts/site/_site.html.erb %>
・・・
<a class="navbar-item">
 　<i class="fas fa-shopping-cart"></i>
</a>
<%# 以下を追加 %>
<div class="navbar-item">
  <div class="control has-icons-left">
    <div class="select is-small is-rounded">
      <select id="selectedLocale">
        <% [:en, :ja].each do |locale| %>
          <option data-url="<%= url_for Rails.application.routes.recognize_path(request.url).merge({ only_path: false, locale: locale }) %>"<%= I18n.locale == locale ? ' selected' : '' %>><%= locale %></option>
        <% end %>
      </select>
    </div>
    <span class="icon is-small is-left">
      <i class="fas fa-globe"></i>
    </span>
  </div>
</div>
・・・
```

javascriptを利用して、selectの値が変更された場合に画面を切り替えます。

```frontend/layouts/site/site.js
document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('selectedLocale').addEventListener('change', function () {
        var selectedOption = this.options[this.selectedIndex];
        var url = selectedOption.getAttribute('data-url');
        if (url) {
            location.href = url;
        }
    });    
});
```

## サイトタイトルを言語毎に切り替える

言語が正しく切り替わるかどうか、サイトのタイトルを変更してみましょう。
`frontend/layouts/site/_site.html.erb`のタイトル部分を以下のように修正してください。

```frontend/layouts/site/_site.html.erb
<%# frontend/layouts/site/_site.html.erb %>
<a class="navbar-item title" style="margin-bottom: 0;">
 　Online Shop
</a>
↓
<%= link_to root_url(locale: I18n.locale), t('site.title'), class: 'navbar-item title', style: 'margin-bottom: 0;' %>
```

ここまでできたら、サーバーを起動し画面を確認してみてください。

■ 英語版

![オンラインショップ 英語版](/images/uploads/screen_site_multi_lang_en_20180214022016.png)

■ 日本語版

![オンラインショップ 日本語版](/images/uploads/screen_site_multi_lang_ja_20180214022016.png)



## 補足

今まで同様nginxをwebサーバーとして利用していう場合、設定ファイルにサブドメインへのアクセス設定を追加してください。

```misc/nginx/development.conf
# misc/nginx/development.conf
server_name netshop.local;
↓
server_name netshop.local en.netshop.local ja.netshop.local;
```

## 参考URL
* [あなたはいくつ知っている？Rails I18nの便利機能大全！](https://qiita.com/Kta-M/items/bd4ba36a58ad602a9d8b)
* [Rails国際化 (I18n) API](https://railsguides.jp/i18n.html)
