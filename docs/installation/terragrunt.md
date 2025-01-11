# Terragruntのインストール手順

## Terragruntとは？

gruntworks社が提供しているterraformの拡張機能。
詳細は[公式ドキュメント](https://terragrunt.gruntwork.io/)を参照。

使用できるResource情報は[コチラ](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)。
基本はこれを見て使用するResourceを確認する。

## 導入するメリット・デメリットについて
メリット
- planやapplyの時間の短縮  
変更した部分のみplanやapplyをすることで、リソースが多くなってきても処理時間が増えにくくなります。  
または不要なリソースのみdestroyかけることも簡単に可能、もちろん全てのリソースをPlan/Applyかけることも可能。

- 規模が大きくなってもどこにリソースが存在するか把握しやすい  
カテゴリ分けを適切に行うことで、どのディレクトリに何のサービスが記述されているかが把握しやすくなります。

- ライフサイクルが違うリソースを分けることができる  
頻繁に変更が入りやすいアプリケーションなどのリソースと、ほとんど変更されないDBやネットワークなどのリソースを分けることで、意図しない変更が加わるのを防ぐことができます。

デメリット
- sharedディレクトリのファイルを各ディレクトリに配置するのが面倒
- 依存関係の管理の負担
- ディレクトリごとにplan, applyするのが面倒
- モジュールごとにbackendの設定を記述するのが手間

上記のデメリットについては解消した状態が現在のGit環境になる。  
とはいえ、全体のTerraform構成を変更したい場合(envのlocal引数を増やしたいなど)はこういった部分を考慮して変更する必要がある

## インストール

Terragrunt社公式のインストール手順は[コチラ](https://terragrunt.gruntwork.io/docs/getting-started/install/)

### インストール手順

```
$ sudo wget -q -O /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.38.6/terragrunt_linux_amd64
$ sudo chmod 755 /usr/local/bin/terragrunt
```

### Terragruntのバージョン確認

```
$ terragrunt -version
terragrunt version v0.38.6
```
