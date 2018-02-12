---
layout: post
thumbnail: /images/uploads/screen_bulma.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part4
description: bulmaを利用したデザインに変更
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
  - bulma
---
こんにちは、なかむです。

前回はコンポーネントを作成し、Ruby On Railsのフロントエンド環境を整備しました。
今回は、bulmaを組み込みベースとなるデザインを作成していきます。

## bulmaをインストール
yarnを利用してbulmaをインストールします。
```
yarn add bulma
```

`frontend/init/index.css`でbulmaのimportを追加します。
以下のように`frontend/init/index.css`を修正してください。

```frontend/init/index.css
@import "normalize.css/normalize.css";
@import "bulma/css/bulma.css";
```

## `site`コンポーネントのレイアウトをbulmaベースに変更
オンラインショップを意識して簡単なbulmaベースのレイアウトを作成します。

