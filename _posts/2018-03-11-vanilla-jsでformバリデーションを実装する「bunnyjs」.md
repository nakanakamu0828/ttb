---
layout: post
thumbnail: /images/uploads/screen_20180311184030.png
title: Vanilla JSでformバリデーションを実装する「BunnyJs」
description: jqueryを利用したくない。でもhtml5のデフォルトバリデーションだけでは物足りない。そんな時は「BunnyJs」。ES6で実装します。
location: Hong Kong
categories:
  - Programming
tags:
  - javascript
  - es6
  - bunnyjs
---
こんにちは、なかむです。\
今回は[bunnyjs](https://github.com/Mevrael/bunny)というライブラリを利用して、vanilla js（pure js）のformバリデーションを実装していきます。

<https://bunnyjs.com/>

\[前提条件として]

* npmを利用してフロントエンドのモジュールを管理
* parcelを利用してbuildとサーバー起動を行う

# プロジェクトディレクトリの作成

```bash
$ mkdir -p sample-bunnyjs
$ cd sample-bunnyjs
```

# インストール

bunnyjsを試すためにまずは必要なライブラリをインストールしていきましょう

## parcelをインストール

```bash
    
$ npm install -g parcel-bundler
```

## buildに必要なライブラリをインストール

```bash
$ npm init
$ npm install babel-preset-env -D
$ npm install node-sass -D
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

## bunnyjsインストール

```bash
$ npm install bunnyjs --save
```

## Bootstrap4インストール

今回はCSSフレームワークのbootstrap4を利用してformを簡単に調整します。  

```bash
$ npm install bootstrap --save
```

※スタイルだけ利用して、jqueryなどjsは読み込みません。

これで準備は完了です。

# 各ファイルを作成

## ディレクトリとファイルを作成する

```bash
$ mkdir -p {src,public}
$ mkdir -p src/{js,scss,images}
$ touch src/index.html
$ touch src/js/app.js
$ touch src/scss/style.scss
```

## エントリーポイントとなるsrc/index.html

```html
<html lang="ja">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>Flickity Sample</title>
</head>
<body>
    <div class="container">
        <h1>bunnyjs</h1>
        <form id="form1" method="POST" novalidate="">
        
            <div class="form-group has-danger">
                <label for="name">Name</label>
                <input type="text" name="name" id="name" class="form-control" placeholder="Name" required="" minlength="6" maxlength="18">
            </div>
        
            <div class="form-group has-danger">
                <label for="password">Password</label>
                <input type="password" name="password" id="password" class="form-control" placeholder="Password" required="" minlength="6" maxlength="18">
            </div>
        
            <div class="form-group has-danger">
                <label for="password_confirmation">Confirm Password</label>
                <input type="password" name="password_confirmation" id="password_confirmation" class="form-control" placeholder="Password again" required="" minlength="6" maxlength="18">
            </div>
        
            <div class="form-group has-danger">
                <label for="email">E-mail</label>
                <input type="email" name="email" id="email" class="form-control" placeholder="E-mail" required="" maxlength="18" data-ajax="/api/users/email-exists/?q={value}">
            </div>
        
            <div class="form-group has-danger">
                <label for="select">Select</label>
                <select name="select" id="select" class="c-select form-control" required="">
                    <option value="" selected="">Select option</option>
                    <option value="1">One</option>
                    <option value="2">Two</option>
                    <option value="3">Three</option>
                </select>
            </div>
        
            <div class="form-group has-danger">
                <label for="photo">Photo</label>
                <input type="file" name="photo" accept="image/jpeg, image/png" id="photo" class="form-control" placeholder="Photo" required="" maxfilesize="1" mindimensions="500x500">
            </div>
        
            <div class="form-group">
                <label for="about">About</label>
                <textarea name="about" id="about" class="form-control"></textarea>
            </div>
        
            <div class="form-group has-danger">
                <label class="c-input c-radio">
                    <input name="agree" type="radio" value="1" required="">
                    <span class="c-indicator"></span>
                    I agree with Terms of Service
                </label>
            </div>
        
            <input type="submit" class="btn btn-primary" value="Submit">
        
        </form>
    </div>
    <script src="js/app.js"></script>
</body>
</html>
```

## src/js/app.js

```javascript
import '../scss/style.scss';
import { Validation } from 'bunnyjs/src/Validation';



Validation.ui.config = {

    classInputGroup: 'form-group',
    classInputGroupError: 'was-validated',
    classLabel: 'form-control-label',
    tagNameError: 'div',
    classError: 'invalid-feedback',
    selectorInput: '[name]'

};

Validation.init(document.getElementById('form1'));
```

## src/scss/style.scss

```scss
@import "../../node_modules/bootstrap/scss/bootstrap.scss";
```

\#parcelで起動

```bash
$ parcel src/index.html -d public
```

ブラウザで http://localhost:1234/ を開きます。未入力で"Submit"ボタンを押下し、requiredのエラーが出るかどうかご確認ください。

![デモ画面 : BunnyJs](/images/uploads/screen_20180311183818.png)
