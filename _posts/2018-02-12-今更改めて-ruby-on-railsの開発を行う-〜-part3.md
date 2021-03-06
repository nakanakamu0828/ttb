---
layout: post
thumbnail: /images/uploads/ruby_on_rails.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part3
description: コンポーネント指向で画面を構築していく
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
---
こんばんは、なかむです。

前回に引き続きRailsの開発を進めていきたいと思います。
コンポーネントごとに画面を作成していきます。
前回確認用として作成したapplication.cssは不要になります。削除してください。

```bash

$ rm -f frontend/packs/application.css

```

# アプリの初期設定

アプリ全体で共通利用するフォルダを作成します。
今回は`init`とします。

```bash

$ mkdir -p frontend/init
$ touch frontend/init/index.js
$ touch frontend/init/index.css

```

`frontend/packs/application.js`にinitのimportを追加します。

```javascript

// frontend/packs/application.js
import "init";

```

`frontend/init/index.js`, `frontend/init/index.css`は以下のように作成します。

```javascript

// frontend/init/index.js
import "./index.css";

```

```css

/* frontend/init/index.css */
@import "normalize.css/normalize.css"; 

body {
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-size: 16px;
  line-height: 24px;
}

```

`normalize.css`を`frontend/init/index.css`の最初に読み込み、ブラウザ依存のCSSをリセットします。

# コンポーネント作成

コンポーネントは、`layouts`, `pages`, `components`の３種類を用意したいと思います。

* layouts : 共通デザインを定義
* pages : ページごとのデザインを定義
* components : ページ内のパーツごとのデザインを定義。複数ページで共通利用が可能

まず最初に作成するレイアウトのテンプレートを`site`と呼ぶことにします。
各画面で共通利用するレイアウトのデザインです。

```bash

$ mkdir -p frontend/{layouts,pages,components}
$ mkdir -p frontend/layouts/site
$ touch frontend/layouts/site/{_site.html.erb,site.css,site.js}

```

各ファイルの内容は以下のように定義します。

```javascript

// frontend/layouts/site/site.js
import "./site.css";

```

```css

/* frontend/layouts/site/site.css */
.site {
    height: 100vh;
    width: 700px;
    margin: 0 auto;
    overflow: hidden;
}

```

```html

<!-- frontend/layouts/site/_site.html.erb -->
<div class="site">
  <%= yield %>
</div>

```

続いて前回作成したHome画面のコンポーネントを作成します。
ページ毎のコンポーネントになります。

```bash

$ mkdir -p frontend/pages/home
$ touch frontend/pages/home/{_show.html.erb,home.css,home.js}

```

各ファイルの内容は以下のように定義します。

```javascript

// frontend/pages/home/home.js
import "./home.css";

```

```css

/* frontend/pages/home/home.css */
.home h1 {
    font-size: 1.2rem;
    font-weight: bold;
}

```

```html

<!-- frontend/pages/home/_show.html.erb -->
<div class="home">
    <h1>Home page</h1>
    <p>Hello from our first component!</p>
</div>

```

`init`と同様で作成したコンポーネントは、`frontend/packs/application.js`にてimportします。

```javascript

// frontend/packs/application.js
import "init";
// 以下を追加
import "layouts/site/site";
import "pages/home/home";

```

前回作成したHome画面のhtml　`app/views/homes/show.html.erb`　を以下のように変更します。

```html

<!-- app/views/homes/show.html.erb -->
<%= render "layouts/site/site" do %>
  <%= render "pages/home/show" %>
<% end %>

```

`site`レイアウトを使用して`home`の画面を表示するようにコンポーネントを読み込みます。
ここまでできたらサーバーを再び起動し、以下の画面が表示さるか確認してください。

![Rails サンプル画面](/images/uploads/screen_rails_sample_20180212003646.png)


今回は`layouts`, `pages`の２つのみで、`components`に触れませんでしたが、複数の画面で利用するUIパーツなど`components`として切り出して利用したいと考えています。  
こちらに関しては実装を進めていく上でリファクタリングを進めながら切り出していきたいと思います。

今回の成果物は [こちら](https://github.com/nakanakamu0828/netshop/tree/v0.3) をご確認ください。
