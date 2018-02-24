---
layout: post
thumbnail: /images/uploads/rails.png
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
こんばんは、なかむです。  
引き続きRailsアプリの多言語対応を試していきたいと思います。  
今期は、[globalize/globalize](https://github.com/globalize/globalize)というgemを利用してModelを多言語化していきます。


## [globalize/globalize](https://github.com/globalize/globalize)のインストール

Gemfileに `gem 'globalize', git: 'https://github.com/globalize/globalize'` を追加して `bundle install` します。  
githubのURLを指定するのは、ActiveRecord5.1に対応してリポジトリを設定するためです。

##　多言語化するModelを作成
今回はネットショップのカテゴリーを多言語化したいと思います。  
railsコマンドからModelとマイグレーションファイルを作成します。

```
$ rails g model Category
```

`app/models/category.rb`モデルに翻訳対象項目を指定します

```app/models/category.rb
# app/models/category.rb
class Category < ApplicationRecord
    translates :name
end
```

マイグレーションファイルは以下のような内容に変更します

```db/migrate/20180224xxxxxx_create_categories.rb
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

```
$ rails db:migrate
```

DBを除いて、`categories`テーブルと`category_translations`テーブルが作成されていることを確認してください。

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

## seedを利用してデータをインポート
`db/seeds.rb`に初期データをインポートする処理を記載します。

```db/seeds.rb
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
```
$ rails db:seed
```

`category_translations`テーブルにデータが作成されていることを確認してください。

## Railsアプリでカテゴリーを動的表示させる

