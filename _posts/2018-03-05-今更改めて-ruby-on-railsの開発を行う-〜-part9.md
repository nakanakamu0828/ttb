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
まずは`Gemfile`に`sorcery`の設定を追加します

## sorceryインストール

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

続いてDBをセットアップします。
migrationを利用してuserテーブルを作成します。
```
$ rails db:migrate
```

## ユーザー登録機能
それではユーザー登録機能を作成していきます。
`rails`コマンドを利用してcontrollerを作成しましょう。

```
$ rails g controller users/registrations
```

`new`メソッドで新規登録画面の表示を行い、`create`メソッドで登録します。`app/controllers/users/registrations_controller.rb`を以下のように修正しましょう。

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

Userモデルにバリデーションを追加します。
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

続いてviewを用意していきます。  
以下のコマンドを実行してディレクトリとファイルを用意しましょう。  
今回も`frontend`ディレクトリ配下にコンポーネントとして用意していきます。
```
$ mkdir -p app/views/users/registrations
$ touch app/views/users/registrations/new.html.erb
$ mkdir -p frontend/pages/user/registration
$ touch frontend/pages/user/registration/_new.html.erb
```

`app/views/users/registrationsnew.html.erb`ファイルは以下のようにコンポーネントを用意します。
```app/views/users/registrations/new.html.erb
<!-- app/views/users/registrations/new.html.erb -->
<%= render "layouts/site/site" do %>
  <%= render "pages/user/registration/new" %>
<% end %>
```

コンポーネントの`_new.html.erb`に登録フォームをコーディングしていきます。
```
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

[補足]  
ヘッダーに用意しているロケーション切り替えのselectが原因で、新規登録でバリデーションに引っかかった場合、５００エラーが出てしまいました。
メニュー部分は以下のように修正しました。
```frontend/layouts/site/_site.html.erb
<!-- frontend/layouts/site/_site.html.erb -->
<option data-url="<%= url_for Rails.application.routes.recognize_path(request.url).merge({ only_path: false, locale: locale }) %>"<%= I18n.locale == locale ? ' selected' : '' %>><%= locale %></option>
↓
<option data-url="<%= url_for(Rails.application.routes.recognize_path(request.get? ? request.url : url_for(:back)).merge({ only_path: false, locale: locale })) %>"<%= I18n.locale == locale ? ' selected' : '' %>><%= locale %></option>
```


`config/routes.rb`に新規登録ページのルーティングを記載します
```config/routes.rb
# config/routes.rb
namespace :users, module: :users do
  resources :registrations, only: [:new, :create]
end
```

以下のようにlink_toメソッドを利用することで、新規登録ページのリンクが作成されます。適した場所にリンクを配置してください。
```
<%= link_to 'singup', new_users_registration_path %>
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




