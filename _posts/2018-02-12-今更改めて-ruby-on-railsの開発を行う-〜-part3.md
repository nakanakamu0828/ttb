---
layout: post
thumbnail: /images/uploads/rails.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part3
description: コンポーネント指向で画面を構築していく
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
---
こんにちは、なかむです。

前回に引き続きRailsの開発を進めていきたいと思います。
コンポーネントごとに画面を作成していきます。
前回確認用として作成したapplication.cssは不要になります。削除してください。

```
$ rm -f frontend/packs/application.css
```

## アプリの初期設定

アプリ全体で共通利用するフォルダを作成します。
今回は`init`とします。

```
$ mkdir -p frontend/init
$ touch frontend/init/index.js
$ touch frontend/init/index.css
```

`frontend/packs/application.js`にinitのimportを追加します。

```frontend/packs/application.js
import "init";
```

`frontend/init/index.js`, `frontend/init/index.css`は以下のように作成します。

```frontend/init/index.js
// frontend/init/index.js
import "./index.css";
```

```frontend/init/index.css
/* frontend/init/index.css */
@import "normalize.css/normalize.css"; 

body {
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-size: 16px;
  line-height: 24px;
}
```

`normalize.css`を`frontend/init/index.css`の最初に読み込み、ブラウザ依存のCSSをリセットします。

## コンポーネント作成

コンポーネントは、`layouts`, `pages`, `components`の３種類を用意したいと思います。

* layouts : 共通デザインを定義
* pages : ページごとのデザインを定義
* components : ページ内のパーツごとのデザインを定義。複数ページで共通利用が可能

まず最初に作成するレイアウトのテンプレートを`site`と呼ぶことにします。
各画面で共通利用するレイアウトのデザインです。

```
$ mkdir -p frontend/{layouts,pages,components}
$ mkdir -p frontend/layouts/site
$ touch frontend/layouts/site/{_site.html.erb,site.css,site.js}
```

各ファイルの内容は以下のように定義します。

```frontend/layouts/site/site.js
// frontend/layouts/site/site.js
import "./site.css";
```

```frontend/layouts/site/site.css
/* frontend/layouts/site/site.css */
.site {
    height: 100vh;
    width: 700px;
    margin: 0 auto;
    overflow: hidden;
}
```

```frontend/layouts/site/_site.html_erb
<!-- frontend/layouts/site/_site.html.erb -->
<div class="site">
  <%= yield %>
</div>
```

続いて前回作成したHome画面のコンポーネントを作成します。
ページ毎のコンポーネントになります。

```
$ mkdir -p frontend/pages/home
$ touch frontend/pages/home/{_show.html.erb,home.css,home.js}
```

各ファイルの内容は以下のように定義します。

```frontend/pages/home/home.js
// frontend/pages/home/home.js
import "./home.css";
```

```frontend/pages/home/home.css
/* frontend/pages/home/home.css */
.home {}
.home h1 {
    font-size: 1.2rem;
    font-weight: bold;
}
```

```frontend/pages/home/_show.html_erb
<!-- frontend/pages/home/_show.html.erb -->
<div class="home">
    <h1>Home page</h1>
    <p>Hello from our first component!</p>
</div>
```

続いて前回作成したHome画面のhtmlの`app/views/homes/show.html.erb`を以下のように変更します。

```app/views/homes/show.html.erb
<!-- app/views/homes/show.html.erb -->
<%= render "layouts/site/site" do %>
  <%= render "pages/home/show" %>
<% end %>
```

`site`レイアウトを使用して`home`の画面を表示します。
ここまでできたらサーバーを再び起動し、以下の画面が表示さるか確認してください。

![Rails サンプル画面](/images/uploads/screen_rails_sample_20180212003646.png)


今回は`layouts`, `pages`の２つのみで、`components`に触れませんでしたが、複数の画面で利用するUIパーツなど`components`として切り出して利用したいと考えています。  
こちらに関しては実装を進めていく上でリファクタリングを進めながら切り出していきたいです。
