---
layout: post
thumbnail: /images/uploads/screen_aws_elasticache_1.png
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
開発環境なので、バックアップやレプリケーションなどは行いません。最小リソースでまずは試してみます。

# Redis用のセキュリティグループ作成

インバウンドには、接続元となるEC2のグループIDを指定してください。

![セキュリティグループ設定](/images/uploads/screen_aws_elasticache_secure_20180212175742.png)

# Redisのインスタンス作成
ElastiCacheのTOPから「今すぐ始める」ボタンを押下し設定していきます。

![Redis作成 設定1](/images/uploads/screen_aws_elasticache_redis_1.png)

![Redis作成 設定2](/images/uploads/screen_aws_elasticache_redis_2.png)

![Redis作成 設定3](/images/uploads/screen_aws_elasticache_redis_3.png)

![Redis作成 設定4](/images/uploads/screen_aws_elasticache_redis_4.png)

セキュリティグループは最初に作成したEC2からの接続を許可したものを選択します。こちらが間違っているとRedisにアクセスできません。

# EC2からRedisに接続できるか確認
Redisクライアントが入っていない場合、以下のコマンドからインストールします。

```bash

# yum install -y redis --enablerepo=epel

```

続いてRedisへの接続を確認します。  
Redisのホスト名はAWSのコンソールから確認してください。  
"プライマリエンドポイント"というところです。

```bash

$ redis-cli -h [host]

```

接続できればRedisの環境構築は完了です。

簡単ではありますが、今回はAWSのRedis環境構築をまとめてみました。
今後はRedisを活用し、サイトのパフォーマンス向上を目指していきたいと思います。
