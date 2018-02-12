---
layout: post
thumbnail: /images/uploads/screen_aws_elasticache.png
title: AWSのElastiCacheでRedisを利用する
description: ElastiCacheを利用してRedisをインストールし、EC2から接続してみます
location: Hong Kong
categories:
  - Infrastructure
tags:
  - aws
  - elasticache
  - redis
---
こんにちは、なかむです。
今回はAWSのElastiCacheを利用してRedisの環境を構築したいと思います。
EC2から接続することを前提とします。

まずは、Redis用のセキュリティグループを作成します。
インバウンドには、接続元となるEC2のグループIDを指定してください。

![セキュリティグループ設定](/images/uploads/screen_aws_elasticache_secure_20180212175742.png)

続いてRedisを作成していきます。
