---
layout: post
thumbnail: /images/uploads/screen_rails_globalize_20180225122644.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part6
description: globalizeを利用してModelも多言語対応する
location: Tokyo
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
  - globalize
---
こんにちは、なかむです。  
引き続きRailsアプリの多言語対応を試していきたいと思います。  
今期は、[globalize/globalize](https://github.com/globalize/globalize)というgemを利用してModelを多言語化していきます。

# [globalize/globalize](https://github.com/globalize/globalize)のインストール

Gemfileに `gem 'globalize', git: 'https://github.com/globalize/globalize'` を追加して `bundle install` します。  
githubのURLを指定するのは、ActiveRecord5.1に対応したリポジトリの指定です。

#　多言語化するModelを作成
今回はネットショップのカテゴリーを多言語化したいと思います。  
railsコマンドからModelとマイグレーションファイルを作成します。

```bash

$ rails g model Category

```

`app/models/category.rb`モデルに翻訳対象項目を指定します

```ruby

# app/models/category.rb
class Category < ApplicationRecord
    translates :name
end

```

マイグレーションファイルは以下のような内容に変更します

```ruby

# db/migrate/20180224xxxxxx_create_categories.rb
class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories, unsigned: true do |t|
      t.string :name,  null: false, default: ""
      t.boolean :state, null: false, default: true
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Category.create_translation_table! name: :string
      end

      dir.down do
        Category.drop_translation_table!
      end
    end
  end
end

```

`Category.create_translation_table!`で各言語の翻訳カテゴリーを登録するテーブルを作成しています。
それではmigrateします

```bash

$ rails db:migrate

```

DBの中を覗いて、`categories`テーブルと`category_translations`テーブルが作成されていることを確認してください。

```mysql

mysql> desc categories;
+------------+---------------------+------+-----+---------+----------------+
| Field      | Type                | Null | Key | Default | Extra          |
+------------+---------------------+------+-----+---------+----------------+
| id         | bigint(20) unsigned | NO   | PRI | NULL    | auto_increment |
| name       | varchar(255)        | NO   |     |         |                |
| state      | tinyint(1)          | NO   |     | 1       |                |
| created_at | datetime            | NO   |     | NULL    |                |
| updated_at | datetime            | NO   |     | NULL    |                |
+------------+---------------------+------+-----+---------+----------------+
5 rows in set (0.00 sec)

mysql> desc category_translations;
+-------------+--------------+------+-----+---------+----------------+
| Field       | Type         | Null | Key | Default | Extra          |
+-------------+--------------+------+-----+---------+----------------+
| id          | bigint(20)   | NO   | PRI | NULL    | auto_increment |
| category_id | int(11)      | NO   | MUL | NULL    |                |
| locale      | varchar(255) | NO   | MUL | NULL    |                |
| created_at  | datetime     | NO   |     | NULL    |                |
| updated_at  | datetime     | NO   |     | NULL    |                |
| name        | varchar(255) | YES  |     | NULL    |                |
+-------------+--------------+------+-----+---------+----------------+
6 rows in set (0.00 sec)

```

# seedを利用してデータをインポート

`db/seeds.rb`に初期データをインポートする処理を記載します。

```ruby

# db/seeds.rb
[
    { en: 'Mens', ja: '男性' },
    { en: 'Womens', ja: '女性' },
    { en: 'Children', ja: '子供' },
    { en: 'Babies', ja: '赤ちゃん' }
].each do |d|
    I18n.locale = :en
    data = Category.create(name: d[:en])

    I18n.locale = :ja
    data.name = d[:ja]
    data.save!
end

```

それでは実行してみましょう

```bash

$ rails db:seed

```

`category_translations`テーブルにデータが作成されていることを確認してください。

# Railsアプリでカテゴリーを動的表示させる

ヘッダーメニューとしてカテゴリーを全画面に表示するので、`application_controller`に共通処理を実装します。

```ruby

# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  prepend_view_path Rails.root.join("frontend")


  ### 以下を追加
  before_action :init_category
  def init_category
    @categories = Category.where(state: true).order(id: :asc)
  end
  ### ここまで

end

```

view(`_site.html.erb`)も動的に変更されるように変更します。

```html

<!-- frontend/layouts/site/_site.html.erb -->
<ul>
  <li class="is-active">
    <a>Overview</a>
  </li>
  <li>
    <a>Ladies</a>
  </li>
  <li>
    <a>Mens</a>
  </li>
  <li>
    <a>Children</a>
  </li>
  <li>
    <a>Babies</a>
  </li>
</ul>

↓
<%= content_tag(:ul) { @categories.each { |category| concat(content_tag(:li, link_to(category.name, '#'))) } } %>

```

ここまでできたらサーバーを起動して言語切り替えでメニューが切り替わるか確認してください。

![英語ページ](/images/uploads/screen_rails_globalize_20180225093042.png)

**英語での画面表示**

![日本語ページ](/images/uploads/screen_rails_globalize_20180225093015.png)

**日本語での画面表示**

今後はますますグローバル社会になりそうですね。日本にも多くの外国人がやってくるでしょう。常に多言語対応を意識し開発を行うことで、外国人へのアプローチが可能となりサービスの幅も広がると思います。
また、日本人も日本にとどまらず海外で暮らす人が増えてくるでしょう。  
今から多言語、他通貨、timezoneを意識した開発をすることで将来に備えましょう。

今回の成果物は [こちら](https://github.com/nakanakamu0828/netshop/tree/v0.6) をご確認ください。
