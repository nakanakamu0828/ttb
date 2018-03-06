---
layout: post
thumbnail: /images/uploads/ruby_on_rails.png
title: 今更改めて Ruby On Railsの開発を行う 〜 Part9
description: sorceryを利用したユーザー認証処理
location: Hong Kong
categories:
  - Programming
tags:
  - ruby
  - ruby on rails
  - sorcery
---
こんにちは、なかむです。

今回は[Sorcery/sorcery](https://github.com/Sorcery/sorcery)を利用したユーザー認証処理を実装していきます。  

## sorceryインストール

まずは`Gemfile`に`sorcery`の設定を追加します

```Gemfile
# Gemfile
gem 'sorcery'
```

続いて`bundle install`コマンドを実行し、ライブラリをインストールしてください。

```
$ bundle install
or
$ bundle install --path=vendor/bundle
```

※ 環境に合わせてプロジェクト配下にインストールするかどうかでコマンドを選択してください。



## sorceryのセットアップ

sorceryのテンプレートを作成します

```
$ rails g sorcery:install

      create  config/initializers/sorcery.rb
    generate  model User --skip-migration
      invoke  active_record
      create    app/models/user.rb
      insert  app/models/user.rb
      insert  app/models/user.rb
      create  db/migrate/20180305075527_sorcery_core.rb
```

※ 作成されたファイルを確認してみてください。

続いてDBをセットアップします。\
migrationを利用してuserテーブルを作成します。

```
$ rails db:migrate
```



## ユーザーの新規登録

それではユーザーの新規登録機能を作成していきましょう。\
`rails`コマンドを利用してcontrollerを作成します。

```
$ rails g controller users/registrations
```

`new`メソッドで新規登録画面の表示を行い、`create`メソッドで登録します。`app/controllers/users/registrations_controller.rb`を以下のように修正してください。

```app/controllers/users/registrations_controller.rb
# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        respond_to do |format|
            if @user.save
                format.html { redirect_to root_url, notice: 'User was successfully created.' }
                format.json { render :show, status: :created, location: @user }
            else
                format.html { render :new }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    private
        def user_params
            params.require(:user).permit(:email, :password, :password_confirmation)
        end
end
```

Userモデルにはバリデーションを追加します。

```app/models/user.rb
# app/models/user.rb
class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
end
```

続いてviewを用意していきます。\
以下のコマンドを実行してディレクトリとファイルを用意しましょう。\
今回も`frontend`ディレクトリ配下にコンポーネントとして用意していきます。

```
$ mkdir -p app/views/users/registrations
$ touch app/views/users/registrations/new.html.erb
$ mkdir -p frontend/pages/user/registration
$ touch frontend/pages/user/registration/_new.html.erb
```

`app/views/users/registrations/new.html.erb`ファイルは以下のようにコンポーネントを呼び出すように設定してください。

```app/views/users/registrations/new.html.erb
<!-- app/views/users/registrations/new.html.erb -->
<%= render "layouts/site/site" do %>
  <%= render "pages/user/registration/new" %>
<% end %>
```

コンポーネントの`_new.html.erb`には、登録フォームをコーディングしていきます。

```frontend/pages/user/registration/_new.html.erb
<!-- frontend/pages/user/registration/_new.html.erb -->
<div class="user-registration">
    <section class="section">
        <div class="container">
            <div class="columns">
                <div class="column is-half is-offset-one-quarter">
                    <div class="box">
                        <h1 class="title has-text-centered is-size-4">Signup</h1>
                        <hr>
                        <%= form_for(@user, url: users_registrations_path, html: { medhod: :post }) do |f| %>
                             <% if @user.errors.any? %>
                                <div class="notification is-danger">
                                    <ul>
                                        <% @user.errors.full_messages.each do |message| %>
                                            <li><%= message %></li>
                                        <% end %>
                                    </ul>
                                </div>
                            <% end %>
                            <div class="field">
                                <label class="label">Email</label>
                                <div class="control has-icons-left">
                                    <%= f.email_field :email, class: "input", placeholder: 'Email', autocomplete: :off %>
                                    <span class="icon is-small is-left">
                                        <i class="fas fa-envelope"></i>
                                    </span>
                                </div>
                            </div>
                            <div class="field">
                                <label class="label">Password</label>
                                <div class="control has-icons-left">
                                    <%= f.password_field :password, class: "input", placeholder: 'Password', autocomplete: :off %>
                                    <span class="icon is-small is-left">
                                        <i class="fas fa-key"></i>
                                    </span>
                                </div>
                            </div>
                            <div class="field">
                                <label class="label">Confirm Password</label>
                                <div class="control has-icons-left">
                                    <%= f.password_field :password_confirmation, class: "input", placeholder: 'Confirm Password', autocomplete: :off %>
                                    <span class="icon is-small is-left">
                                        <i class="fas fa-key"></i>
                                    </span>
                                </div>
                            </div>
                            
                            <hr>

                            <div class="field is-grouped is-grouped-centered">
                                <input type="submit" class="button is-primary  is-fullwidth" value="Submit">
                            </div>
                        <% end %>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
```

\[補足]\
ヘッダーに用意しているロケーション切り替えのselectが原因で、新規登録でバリデーションに引っかかった場合、５００エラーが出てしまいました。
メニュー部分は以下のように修正しました。

```frontend/layouts/site/_site.html.erb
<!-- frontend/layouts/site/_site.html.erb -->
<option data-url="<%= url_for Rails.application.routes.recognize_path(request.url).merge({ only_path: false, locale: locale }) %>"<%= I18n.locale == locale ? ' selected' : '' %>><%= locale %></option>
↓
<option data-url="<%= url_for(Rails.application.routes.recognize_path(request.get? ? request.url : url_for(:back)).merge({ only_path: false, locale: locale })) %>"<%= I18n.locale == locale ? ' selected' : '' %>><%= locale %></option>
```

バリデーションエラーを多言語化する為、翻訳ファイルを作成します。

```
$ touch config/locales/models/ja.yml
```

`config/locales/models/ja.yml`は以下のような内容にしてください。

```config/locales/models/ja.yml
ja:
  activerecord: &activerecord
    models:
      user: "ユーザー"
    attributes:
      user:
        id: "ID"
        email: "メールアドレス"
        crypted_password: "パスワード"
        salt: "Salt"
        created_at: "登録日時"
        updated_at: "更新日時"
    errors:
      models:
        user:
          attributes:
            email:
              blank: "が入力されていません。"
              taken: "は既に登録されています。"
            password:
              blank: "が入力されていません。"
              too_short: "が短すぎます。"
            password_confirmation:
              blank: "が入力されていません。"
              confirmation: "がパスワードと一致しません"
```

ルーティングファイル（`config/routes.rb`）に以下のような新規登録ページへのルーティングを追記します。

```config/routes.rb
# config/routes.rb
namespace :users, module: :users do
  resource :registrations, only: [:new, :create], :path_names => { new: 'signup' }
end
```

以下のようなlink_toメソッドを利用することで、新規登録ページのリンクが作成されます。適した場所にリンクを配置してください。

```
<%= link_to 'signup', new_users_registration_path %>
```

今回はヘッダーにリンクを追加します。`frontend/layouts/site/_site.html.erb`を修正します。

```frontend/layouts/site/_site.html.erb
<!-- frontend/layouts/site/_site.html.erb -->
<div id="navbarMenuHeroB" class="navbar-menu">
  <div class="navbar-end">
    <a class="navbar-item is-active">
      Home
    </a>
    <!-- 以下のリンクを追加 -->
    <%= link_to 'singup', new_users_registration_path, class: 'navbar-item' %>
    <!-- ここまで -->
    <a class="navbar-item">
      Login
    </a>
    <a class="navbar-item">
      <i class="fas fa-shopping-cart"></i>
    </a>
    ・・・
```

ここまでできたら新規登録画面は完了です。\
サーバーを再起動して画面を確認してみましょう。

![デモ：新規登録画面](/images/uploads/screen_demo_20180306120318.png)



## ユーザーログイン

次はログイン機能を実装していきます。\
`rails`コマンドを利用してcontrollerを作成します。

```
$ rails g controller users/sessions
```

`new`メソッドでログイン画面の表示、`create`メソッドでログイン処理を実装します。また`signout`メソッドを用意してログアウト処理を実装します。\
`app/controllers/users/sessions_controller.rb`を以下のように修正してください。

```app/controllers/users/sessions_controller.rb
# app/controllers/users/sessions_controller.rb
class Users::SessionsController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = login(login_params[:email], login_params[:password])
        if @user
            redirect_back_or_to(root_path, notice: 'Login successful')
        else
            flash.now[:alert] = 'Login failed'
            render action: 'new'
        end
    end

    def signout
        logout
        redirect_to(root_path, notice: 'Logged out!')
    end

    private
        def login_params
            params.require(:user).permit(:email, :password)
        end
end
```

続いてviewを用意していきます。\
以下のコマンドを実行してディレクトリとファイルを用意しましょう。\
新規登録と同様で`frontend`ディレクトリ配下にコンポーネントとして用意していきます。

```
$ mkdir -p app/views/users/sessions
$ touch app/views/users/sessions/new.html.erb
$ mkdir -p frontend/pages/user/session
$ touch frontend/pages/user/session/_new.html.erb
```

`app/views/users/sessions/new.html.erb`ファイルは以下のようにコンポーネントを呼び出すように設定してください。

```app/views/users/sessions/new.html.erb
<!-- app/views/users/sessions/new.html.erb -->
<%= render "layouts/site/site" do %>
  <%= render "pages/user/session/new" %>
<% end %>
```

コンポーネントの`_new.html.erb`には、ログインフォームをコーディングしていきます。

```frontend/pages/user/sessions/_new.html.erb
<!-- frontend/pages/user/sessions/_new.html.erb -->
<div class="user-session">
    <section class="section">
        <div class="container">
            <div class="columns">
                <div class="column is-half is-offset-one-quarter">
                    <div class="box">
                        <h1 class="title has-text-centered is-size-4">Signin</h1>
                        <hr>
                        <%= form_for(@user ||= User.new, url: users_sessions_path, html: { medhod: :post }) do |f| %>
                             <% if @user.errors.any? %>
                                <div class="notification is-danger">
                                    <ul>
                                        <% @user.errors.full_messages.each do |message| %>
                                            <li><%= message %></li>
                                        <% end %>
                                    </ul>
                                </div>
                            <% end %>
                            <div class="field">
                                <label class="label">Email</label>
                                <div class="control has-icons-left">
                                    <%= f.email_field :email, class: "input", placeholder: 'Email', autocomplete: :off %>
                                    <span class="icon is-small is-left">
                                        <i class="fas fa-envelope"></i>
                                    </span>
                                </div>
                            </div>
                            <div class="field">
                                <label class="label">Password</label>
                                <div class="control has-icons-left">
                                    <%= f.password_field :password, class: "input", placeholder: 'Password', autocomplete: :off %>
                                    <span class="icon is-small is-left">
                                        <i class="fas fa-key"></i>
                                    </span>
                                </div>
                            </div>
                            
                            <hr>

                            <div class="field is-grouped is-grouped-centered">
                                <input type="submit" class="button is-primary  is-fullwidth" value="Submit">
                            </div>
                        <% end %>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
```

ルーティングファイル（`config/routes.rb`）に以下のようなログインページとログアウトのルーティングを追記します。

```config/routes.rb
# config/routes.rb
  namespace :users, module: :users do
    resource :registrations, only: [:new, :create], :path_names => { new: 'signup' }

    ### ここから追加
    resource :sessions, only: [:new, :create], :path_names => { new: 'signin' } do
      get :signout, to: 'sessions#signout', as: :signout
    end
    ### ここまで

  end
```

登録と同様でヘッダーのリンクを追加しましょう。`frontend/layouts/site/_site.html.erb`を修正します。

```frontend/layouts/site/_site.html.erb
<!-- frontend/layouts/site/_site.html.erb -->
<div id="navbarMenuHeroB" class="navbar-menu">
 　<div class="navbar-end">
 　 　<a class="navbar-item is-active">
 　 　 　Home
 　 　</a>
 　 　<% if current_user %>
 　 　  <%= link_to 'Singout',  signout_users_sessions_path, class: 'navbar-item', method: :delete %>
 　 　<% else %>
 　 　  <%= link_to 'Singup', new_users_registrations_path, class: 'navbar-item' %>
 　 　  <%= link_to 'Singin', new_users_sessions_path, class: 'navbar-item' %>
 　 　<% end %>
 　 　<a class="navbar-item">
 　 　  <i class="fas fa-shopping-cart"></i>
 　 　</a>
    ・・・
```

ここまでできたらログイン/ログアウトの実装は完了です。\
サーバーを再起動して画面を確認してみましょう。
