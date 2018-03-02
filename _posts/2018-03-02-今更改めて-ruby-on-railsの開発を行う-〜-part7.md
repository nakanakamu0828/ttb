---
layout: post
thumbnail: /images/uploads/rails.png
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


## categoriesテーブルに親IDとなるparent_idカラムを追加

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



