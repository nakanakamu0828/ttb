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

`app/views/layouts/application.html.erb`にmetaタグとfontawesomeのjs読み込みを追加

```app/views/layouts/application.html.erb
<!DOCTYPE html>
<html>
  <head>
    <title>Netshop</title
    <meta name="viewport" content="width=device-width, initial-scale=1"> <-- 追加
    <%= csrf_meta_tags %>
    <%= stylesheet_pack_tag 'application' %>
    <script defer src="https://use.fontawesome.com/releases/v5.0.0/js/all.js"></script> <-- 追加
  </head>

  <body>
    <%= yield %>
    <%= javascript_pack_tag "application" %>
  </body>
</html>
```

`frontend/layouts/site/_site.html.erb`にベースとなるレイアウトを作成します。

```frontend/layouts/site/_site.html.erb
<!-- frontend/layouts/site/_site.html.erb -->
<div class="site">
  <section class="hero is-info">
    <div class="hero-head">
      <nav class="navbar">
        <div class="container">
          <div class="navbar-brand">
            <a class="navbar-item title" style="margin-bottom: 0;">
              Online Shop
            </a>
            <span class="navbar-burger burger" data-target="navbarMenuHeroB">
              <span></span>
              <span></span>
              <span></span>
            </span>
          </div>
          <div id="navbarMenuHeroB" class="navbar-menu">
            <div class="navbar-end">
              <a class="navbar-item is-active">
                Home
              </a>
              <a class="navbar-item">
                Login
              </a>
              <a class="navbar-item">
                <i class="fas fa-shopping-cart"></i>
              </a>
            </div>
          </div>
        </div>
      </nav>
    </div>

    <div class="hero-body">
      <div class="container has-text-centered">
        <div class="field is-grouped">
          <div class="control has-icons-left is-expanded">
            <input value="" name="text" class="input is-flat required is-medium" placeholder="search shop item" required="" type="text">
            <span class="icon is-small is-left">
              <i class="fas fa-search"></i>
            </span>
          </div>
          <div class="control">
            <input value="Search" name="submit" id="mc-embedded-subscribe" class="button is-white is-outlined is-medium" type="submit">
          </div>
        </div>
      </div>
    </div>

    <div class="hero-foot">
      <nav class="tabs is-boxed is-fullwidth">
        <div class="container">
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
        </div>
      </nav>
    </div>
  </section>
  
  <%= yield %>

  <footer class="footer">
    <div class="container">
      <div class="content">
        <p>
          © Online Shop <%= Time.now.year %>. 
        </p>
      </div>
    </div>
  </footer>
</div>
```

ホーム画面のデザインを変更します。frontend/pages/home/_show.html.erbを以下のように修正します。

```frontend/pages/home/_show.html.erb
<div class="home">
    <section class="section">
        <div class="container">
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
                            <img src="https//bulma.io/images/placeholders/1280x960.png" alt="Placeholder image">
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

ここまで変更したらサーバーを起動しなおしましょう。\
以下の画面が表示されれば成功です。

![オンラインショップ](/images/uploads/screen_online_shop.png)



今回の成果物は \[こちら](https://github.com/nakanakamu0828/netshop/tree/v0.4) をご確認ください。
