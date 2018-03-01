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

