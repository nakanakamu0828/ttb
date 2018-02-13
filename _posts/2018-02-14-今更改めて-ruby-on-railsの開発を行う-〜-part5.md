---
layout: post
thumbnail: /images/uploads/screen_bulma.png
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

## 翻訳ファイルのディレクトリ構造を整理
モデル、view、それ以外に利用するdefaultの3ディレクトリを用意します。

```
$ mkdir -p config/locales/{defaults,models,views}
$ mv config/locales/en.yml config/locales/defaults/
```

デフォルトで用意されていた`config/locales/en.yml`は`config/locales/defaults/`に移動しておきます。


`app/controllers/application_controller.rb`に言語の判定と設定処理を追加します。

```app/controllers/application_controller.rb
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  ...

  before_action :set_locale

  def set_locale
    I18n.locale = extract_locale_from_tld || I18n.default_locale
  end

  # サブドメインからlocaleを取得する
  # 有効なlocaleが見つからない場合は、nilを返す
  def extract_locale_from_tld
    parsed_locale = request.subdomains.first
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
end
```

### ヘッダーに言語切り替えリンクを設置
今回はselectタグで言語を切り替えられるようにします。
ヘッダーに以下のselect文を追加してください。

```frontend/layouts/site/_site.html.erb
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



## 補足
今まで同様nginxをwebサーバーとして利用していう場合、設定ファイルにサブドメインへのサクセス設定を追加してください。
