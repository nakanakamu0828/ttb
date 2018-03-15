---
layout: post
thumbnail: /images/uploads/screen_vuetifyjs_20180315113113.png
title: VueのCSSフレームワーク「Vuetify」を利用してNuxt.jsプロジェクトを作る
description: >-
  VueのCSSフレームワーク「Vuetify」を利用してマテリアルデザインのプロジェクトを作成します。Nuxt.js用のプロジェクトでSSRで開発していきます。
location: Hong Kong
categories:
  - Programming
tags:
  - javascript
  - vuejs
  - nuxtjs
  - vuetify
---
こんにちは、なかむです。

今回は、[Vuetify](https://vuetifyjs.com/ja/) を利用して、Nuxt.jsのプロジェクトを作成していきます。

# vueコマンドを利用してNuxt.jsプロジェクト作成する

Vuetifyは、用途ごとにテンプレートを用意してくれています。今回はNuxt.jsのテンプレートを利用します。

![Vuetify](/images/uploads/screen_vuetify_20180315114254.png)


以下のコマンドからプロジェクトを作成します

```bash
$ vue init vuetifyjs/nuxt my-vuetify

? Project name my-vuetify
? Project description Nuxt.js + Vuetify.js project
? Author
? Use a-la-carte components? Yes

   vue-cli · Generated "my-vuetify".

   To get started:

     cd my-vuetify
     npm install # Or yarn
     npm run dev

$ cd my-vuetify
$ npm install
```

