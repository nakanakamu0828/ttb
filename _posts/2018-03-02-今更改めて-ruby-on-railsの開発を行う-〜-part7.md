---
layout: post
thumbnail: /images/uploads/ruby_on_rails.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part7
description: 自己結合のテーブル・モデルをRailsで利用する
location: Tokyo
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
---
こんにちは、なかむです。  
今回は自己結合するテーブルをRailsで扱う方法をまとめていきます。  
前回の多言語対応時に作成したcategoriesテーブルに親子関係を持たせ、自己結合するようにします。  
テーブル構造は以下のER図からご確認ください。

![ER図](/images/uploads/screen_er_2018030205523.png)

# categoriesテーブルに親IDとなるparent_idカラムを追加

マイグレーションファイルを作成します

```
$ rails g migration AddColumnParentIdToCateogry
```

マイグレーションファイルの内容は以下のようにします。

```db/migrate/20180301xxxxxx_add_column_parent_id_to_cateogry.rb
# db/migrate/20180301xxxxxx_add_column_parent_id_to_cateogry.rb
class AddColumnParentIdToCateogry < ActiveRecord::Migration[5.1]
  def change
    add_reference :categories, :parent, index: true, unsigned: true, default: nil, after: :state
    add_foreign_key :categories, :categories, column: :parent_id
  end
end
```

マイグレーションファイルが作成できたらDBに反映します

```
$ rails db:migrate
```

DBのcategoriesテーブルは以下のようになります

```
mysql> show create table categories\G
*************************** 1. row ***************************
       Table: categories
Create Table: CREATE TABLE `categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `state` tinyint(1) NOT NULL DEFAULT '1',
  `parent_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_categories_on_parent_id` (`parent_id`),
  CONSTRAINT `fk_rails_82f48f7407` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8
1 row in set (0.00 sec)
```

※ 制約名を定義した方がいいですね・・・

# Modelを修正

Modelに親子関係が保持できるように`belong_to`、`has_many`の記述を追加します。以下のようなModelに変更してください。

```app/models/category.rb
# app/models/category.rb
class Category < ApplicationRecord
    translates :name

    has_many :children, :class_name => "Category", :foreign_key => "parent_id", dependent: :destroy
    belongs_to :parent, :class_name => "Category", :foreign_key => "parent_id", optional: true

    # ***************************************
    # 以下のメソッドはUI表示の制御に利用します
    # ***************************************

    # 
    # 引数で指定されたカテゴリが親かどうかの判定
    # 
    def parents?(category)
        current_category = self
        while !current_category.nil?
            return true if current_category.id == category.id 
            current_category = current_category.parent
        end
        false
    end

    # 
    # 親カテゴリーの一覧を取得します
    # 
    def parents
        parents = []
        current_category = self
        while !current_category.parent.nil?
            parents << current_category.parent
            current_category = current_category.parent
        end
        parents.reverse
    end
end
```

# 親子関係のデータを作成

seedのスクリプトを変更して、categoriesテーブルに親子関係のデータを作成していきます。`db/seed.rb`を以下のように変更してください。

```db/seed.rb
# db/seed.rb
[
    {
        en: 'Mens',
        ja: '男性',
        children: [
            { en: 'Outer', ja: 'アウター'},  
            { en: 'Tops', ja: 'トップス'},
            { en: 'Accessory', ja: 'アクセサリー'},
            { en: 'Pants', ja: 'パンツ'},
            { en: 'Watch', ja: '時計'},
            { en: 'Shoes', ja: '靴'},
            { en: 'Bag', ja: 'バッグ'},
            { en: 'Others', ja: 'その他'}
        ]
    },
    {
        en: 'Womens',
        ja: '女性',
        children: [
            { en: 'Outer', ja: 'アウター'},  
            { en: 'Tops', ja: 'トップス'},
            { en: 'Accessory', ja: 'アクセサリー'},
            { en: 'Pants', ja: 'パンツ'},
            { en: 'Watch', ja: '時計'},
            { en: 'Shoes', ja: '靴'},
            { en: 'Bag', ja: 'バッグ'},
            { en: 'Others', ja: 'その他'}
        ]
    },
    { en: 'Children', ja: '子供' },
    { en: 'Babies', ja: '赤ちゃん' }
].each do |d|
    I18n.locale = :en
    data = Category.create(name: d[:en])

    I18n.locale = :ja
    data.name = d[:ja]
    data.save!

    if d[:children]
        d[:children].each do |c|
            I18n.locale = :en
            child = Category.create(name: c[:en])

            I18n.locale = :ja
            child.name = c[:ja]
            child.save!
                
            data.children <<  child
        end
        data.save!
    end
end
```

既にDBにデータが登録してある場合、レコードを削除します。  
続いてseedを実行します

```
$ rails db:seed
```

エラーなしで実行できたことを確認した後、categoriesテーブル、category_translationsテーブルのデータを確認してみてください。

# カテゴリーページの作成

カテゴリーの親子関係を表示するカテゴリー詳細ページを作成してみましょう。まずは、railsコマンドでcontrollerを用意します

```
$ rails g controller categories
```

次にそれぞれ必要なファイルを作成していきます
`app/controllers/categories_controller.rb`のshowメソッドが詳細ページとなります。

```app/controllers/categories_controller.rb
# app/controllers/categories_controller.rb
class CategoriesController < ApplicationController
    def show
        @category = Category.where(state: true).find(params[:id])

 　 　 　#　将来的には、カテゴリーに紐づく商品を取得する
    end
end
```

`config/routes.rb`にカテゴリー詳細ページのルーティングを追加

```config/routes.rb
# config/routes.rb
Rails.application.routes.draw do
  resources :categories, only: [:show]
  root to: "homes#show"
end
```

`app/views/categories/show.html.erb`にコンポーネントの読み込みを記載します。コンポーネントについてはあとで作成していきます。

```app/views/categories/show.html.erb
<%# app/views/categories/show.html.erb %>
<%= render "layouts/site/site" do %>
  <%= render "pages/category/show" %>
<% end %>
```

続いてコンポーネントを用意します

```
$ mkdir -p frontend/pages/category
$ touch frontend/pages/category/_show.html.erb
$ touch frontend/pages/category/category.js
$ touch frontend/pages/category/_category.css
```

レイアウトは以下のようにコーディングしていきます

```frontend/pages/category/_show.html.erb
<%# frontend/pages/category/_show.html.erb %>
<div class="cateogry">
    <%
        target_category = @category.parents.empty? ? @category : @category.parents.first %>
    <% if target_category.children.size > 0 %>
        <nav class="navbar has-shadow">
            <div class="container">
                <%= content_tag(:div, class: 'navbar-tabs') { target_category.children.each { |child| concat(link_to(child.name, category_path(child), class: @category && @category.id == child.id ? 'navbar-item is-tab is-active' : 'navbar-item is-tab')) } } %>
            </div>
        </nav>
    <% end %>
    <div class="breadcrumb-block">
        <div class="container">
            <nav class="breadcrumb has-succeeds-separator" aria-label="breadcrumbs">
                <ul>
                    <li><%= link_to 'Home', root_path %></li>
                    <% if @category.parents %>
                        <% @category.parents.each do |p| %>
                            <li><%= link_to p.name, category_path(p) %></li>
                        <% end %>
                    <% end %>
                    <li class="is-active"><a href="#" aria-current="page"><%= @category.name %></a></li>
                </ul>
            </nav>
        </div>
    </div>
    <section class="section">
        <div class="container">
            <h1 class="title"><%= @category.name %></h1>
            <div class="columns">
                <div class="column">
                    <div class="card">
                        <div class="card-image">
                            <figure class="image is-4by3">
                            <img src="https://bulma.io/images/placeholders/1280x960.png" alt="Placeholder image">
                            </figure>
                        </div>
                        <div class="card-content">
                            <div class="media">
                                <div class="media-content">
                                    <p class="title is-4">Item Name</p>
                                </div>
                            </div>
                            <div class="content">
                                <span>￥2,000</span><br>
                                <time datetime="2016-1-1">11:09 PM - 1 Jan 2016</time>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="column">
                    <div class="card">
                        <div class="card-image">
                            <figure class="image is-4by3">
                            <img src="https://bulma.io/images/placeholders/1280x960.png" alt="Placeholder image">
                            </figure>
                        </div>
                        <div class="card-content">
                            <div class="media">
                                <div class="media-content">
                                    <p class="title is-4">Item Name</p>
                                </div>
                            </div>
                            <div class="content">
                                <span>￥2,000</span><br>
                                <time datetime="2016-1-1">11:09 PM - 1 Jan 2016</time>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="column">
                    <div class="card">
                        <div class="card-image">
                            <figure class="image is-4by3">
                            <img src="https://bulma.io/images/placeholders/1280x960.png" alt="Placeholder image">
                            </figure>
                        </div>
                        <div class="card-content">
                            <div class="media">
                                <div class="media-content">
                                    <p class="title is-4">Item Name</p>
                                </div>
                            </div>
                            <div class="content">
                                <span>￥2,000</span><br>
                                <time datetime="2016-1-1">11:09 PM - 1 Jan 2016</time>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="column">
                    <div class="card">
                        <div class="card-image">
                            <figure class="image is-4by3">
                            <img src="https://bulma.io/images/placeholders/1280x960.png" alt="Placeholder image">
                            </figure>
                        </div>
                        <div class="card-content">
                            <div class="media">
                                <div class="media-content">
                                    <p class="title is-4">Item Name</p>
                                </div>
                            </div>
                            <div class="content">
                                <span>￥2,000</span><br>
                                <time datetime="2016-1-1">11:09 PM - 1 Jan 2016</time>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
```

```frontend/pages/category/category.js
// frontend/pages/category/category.js
import "./category.css";
```

```frontend/pages/category/category.css
/* frontend/pages/category/category.css */
.breadcrumb-block {
    padding: 1rem;
}
```

`frontend/packs/application.js`にて`category.js`の読み込み設定を追加してください。

```frontend/packs/application.js
import "init";
import "layouts/site/site";
import "pages/home/home";
// 以下を追加
import "pages/category/category";
```

続いてヘッダーメニューのリンクを修正します。  
親データのみヘッダーメニューに表示したいので`app/controllers/application_controller.rb`のcategoryデータ取得部分をparent_id が nilのもののみ取得するように変更します。  

```app/controllers/application_controller.rb
@categories = Category.where(state: true).order(id: :asc)
↓
@categories = Category.where(state: true).where(parent: nil).order(id: :asc)
```

`frontend/layouts/site/_site.html.erb`のメニュー部分もカテゴリー詳細にリンクするよう修正します。

```frontend/layouts/site/_site.html.erb
<%= content_tag(:ul) { @categories.each { |category| concat(content_tag(:li, link_to(category.name, '#'))) } } %>
↓
<%= content_tag(:ul) { @categories.each { |category| concat(content_tag(:li, link_to(category.name, category_path(category), class: defined?(@category) && @category.parents(category) ? 'is-active' : ''))) } } %>
```

ここまでできたらサーバーを再起動して画面を確認しましょう

![デモ画面](/images/uploads/screen_demo_20180302181142.png)

今回は親子関係のみですが、孫など更に階層を深くすることも可能です。
今回の成果物は [こちら](https://github.com/nakanakamu0828/netshop/tree/v0.7) をご確認ください。
