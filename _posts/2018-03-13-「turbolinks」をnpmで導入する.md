---
layout: post
thumbnail: /images/uploads/turbolinks-rails.png
title: 「turbolinks」をnpmで導入する
description: Railsで利用されている「turbolinks」を１から組み込んでみる
location: Hong Kong
categories:
  - Programming
tags:
  - javascript
  - turbolinks
---
こんばんは、なかむです。  
今回はRailsで採用されている[turbolinks](https://github.com/turbolinks/turbolinks)を１からnpmで利用していきます。  

https://www.npmjs.com/package/turbolinks

[前提条件として]  

* npmを利用してフロントエンドのモジュールを管理
* parcelを利用してbuildとサーバー起動を行う

# プロジェクトディレクトリの作成

```bash

$ mkdir -p sample-turbolinks
$ cd sample-turbolinks

```

# インストール

turbolinksを試すためにまずは必要なライブラリをインストールしていきましょう

## buildに必要なライブラリをインストール

```bash

$ npm init
$ npm install babel-preset-env -D
$ npm install node-sass -D
$ npm install parcel-bundler --save

```

## babelの設定ファイルを作成

```bash

$ touch .babelrc

```

## .babelrc

```

{
  "presets": [
    "env"
  ]
}

```

## turbolinksインストール

```bash

$ npm install turbolinks --save

```

これで準備は完了です。

# 各ファイルを作成

## ディレクトリとファイルを作成する

```bash

$ mkdir -p {src,public}
$ mkdir -p src/{js,scss,images}
$ touch src/index.html
$ touch src/next.html
$ touch src/js/app.js
$ touch src/scss/style.scss

```

## エントリーポイントとなるsrc/index.html

```html

<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>turbolinks Sample</title>
</head>
<body>
  <div class="container">
    <h1>Turbolinks</h1>
    <a href="next.html">Next</a>
    <a href="no-turbolinks.html" data-turbolinks="false">No Turbolinks</a>
  </div>
  <script src="js/app.js"></script>
</body>
</html>

```

## turbolinksを利用した遷移先となるsrc/next.html

```html

<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>turbolinks Sample - Next</title>
</head>
<body>
  <div class="container">
    <h1>Turbolinks - Next</h1>
    <a href="index.html">Prev</a>
  </div>
  <script src="js/app.js"></script>
</body>
</html>

```

## turbolinksを利用しない遷移先となるsrc/no-turbolinks.html

```html

<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>turbolinks Sample - No Turbolinks</title>
</head>
<body>
  <div class="container">
    <h1>No Turbolinks</h1>
    <a href="index.html" data-turbolinks="false">Prev</a>
  </div>
  <script src="js/app.js"></script>
</body>
</html>

```

## src/js/app.js

```javascript

import Turbolinks from 'turbolinks';
Turbolinks.start();

```

## src/scss/style.scss

今回はスタイル設定なし

# parcelで起動

```bash

$ parcel src/index.html -d public

```

ブラウザで http://localhost:1234/ を開きます。

![デモ画面 : git](/images/uploads/screen_demo_201803122358.gif)

今回の成果物は [こちら](https://github.com/nakanakamu0828/sample-turbolinks) になります。  
Netlifyでデモ環境を用意しています。以下のURLにてご確認ください。

<https://pedantic-spence-04ac89.netlify.com/>

