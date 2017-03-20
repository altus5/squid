Squid の導入（SSLキャッシュ機能付き）
==================================

centos7 へのインストールを想定しています。  
ホスト＝proxy.altus5.local にインストールする手順になっています。

## デプロイ

./deploy.sh で配置します。
root で実行してください。

デプロイ先のディレクトリの構成は、このようなになります。
```
/opt
  /certs             ・・・SSLの証明書
    altus5.local.ca.pem        ・・・独自CAの証明書。すでに存在する場合は、上書きしません。
    altus5.local.ca-key.pem    ・・・同上
    proxy.altus5.local.pem     ・・・サーバー証明書。上書きします。
    proxy.altus5.local-key.pem ・・・同上
  /cfssl             ・・・SSLの証明書を作成するための設定ファイル
    /conf
      ca-config.json
      ca-csr.json
      proxy.altus5.local.json
  /squid             ・・・Squid を実行する場所
    /data              ・・・キャッシュデータの保存場所
    squid.conf
    docker-compose.yml
    
```

## 起動

```
cd /opt/squid
docker-compose up -d
```
`docker-compose logs` でエラーがないことを、 確認します。

## クライアント側の設定

任意のクライアント端末で行います。  
dockerクライアントがプロキシーを向くための設定です。  
vagrantでvmを起動している場合は、vmの中で行ってください。  

### 独自CAの証明書インストール

証明書を取得します。
```
scp hoge@proxy.altus5.local:/opt/certs/altus5.local.ca.pem .
```

独自CAの証明書のインストールは、それぞれの環境に合わせて、行ってください。  
ここでは、centos7の場合について、説明します。
```
sudo cp altus5.local.ca.pem /usr/share/pki/ca-trust-source/anchors/altus5.local.ca.pem
sudo update-ca-trust extract
```

### プロキシーの設定

```
export http_proxy=proxy.altus5.local:3128
export https_proxy=proxy.altus5.local:3129
export no_proxy=127.0.0.1,localhost,.local
```

### テスト

```
curl -I https://www.google.co.jp/
```
`HTTP/1.1 200 OK` が表示されれば、OKです。もしも、`curl: (60) SSL certificate problem: unable to get local issuer certificate` と表示されたら、独自CAの証明書のインストールが間違っています。

