# 環境構築用Terraform

## Requirements

|Name                   |Version   |
|-----------------------|----------|
|terragrunt             |~> 0.39.1 |
|terraform              |~> 1.3.9  |
|terraform aws provider |~> 4.57.0 |

## 前提条件

このリポジトリのコードを使用するには、以下のソフトウェアがインストールされている必要があります。  
また、以下内容は全てWSLv2上のUbuntuで実施した内容になる為、その他環境についてはカバーできていないです。

- [AWS CLI](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2.html)
- [Terragrunt](./docs/installation/terragrunt.md)
- [Terraform](./docs/installation/tfenv.md)

Option(こちらはなくても環境の動作はするが入っていたほうが作業効率向上やメンバー内で内容を確認するうえで便利)
- [WLSv2(Ubuntu)](./docs/installation/wsl.md)
- [awsp](./docs/installation/awsp.md)
- [vscode](https://code.visualstudio.com/download)
- [git(windows)](https://gitforwindows.org/)

## 概要

この環境は多数の案件にメンバー個別で対応するため、Terraform構成に差分があるとレビューが必要な場合に負荷がかかる。  
これを解決するため構成を1通りにすることでレビューや新規作成する場合にも簡単に構築できる構成にした。

## 環境について

環境は以下のようなディレクトリ構成になっている  
実際はPJ毎にModuleのリソース構成等は異なるが、基本はこの形
```
terraform-aws-modules:.
│  .gitignore
│  .pre-commit-config.yaml
│  .terraform-version
├─.vscode
│      settings.json
└─terraform
    │  terragrunt.hcl
    └─system
        ├─environments # 環境別の環境設定
        │  ├─prod
        │  └─stg
        │      │  env.hcl　# Stgの環境設定ファイル
        │      │  Makefile
        │      ├─alb　# リソース別の環境設定
        │      │      terragrunt.hcl
        │      ├─ec2
        │      │      terragrunt.hcl
        │      └─rds
        │              terraform.tfvars
        │              terragrunt.hcl
        └─modules
            ├─alb　# リソース別のTfファイル
            │  │  acm.tf
            │  │  alb.tf
            │  │  data.tf
            │  │  main.tf
            │  │  outputs.tf
            │  │  route53.tf
            │  │  s3.tf
            │  │  variables.tf
            │  │  wafv2.tf
            │  └─files
            │      └─template
            │              alb_s3_bucket_policy.json.tpl
            │              default_iam_assume_role.json.tpl
            ├─ec2
            │  │  data.tf
            │  │  ec2.tf
            │  │  iam.tf
            │  │  main.tf
            │  │  outputs.tf
            │  │  variables.tf
            │  └─files
            │      ├─keypair
            │      └─template
            │              default_iam_assume_role.json.tpl
            └─rds
                    main.tf
                    outputs.tf
                    rds.tf
                    variables.tf

terraform-aws-resources:.
├─.vscode
│      settings.json　# vscodeを使う場合のセッティングファイル
│─ec2　# リソース事のResourceファイル群
│      main.tf
│      outputs.tf
│      variables.tf
・・・(量が多いの割愛)
```

## 構成や動作について

[前述](#環境について)した構成は大きく以下の役割で分けている

- terraform-aws-modules  
Resourcesのリソース情報を読み込むことで設定値はこっちのファイルだけに記入ができる。  
そのため、PJ毎のBranchの管理はこちらだけにできる。  
基本的に構築時編集するのはここのファイル群

- terraform-aws-resources  
こちらはModuleの元となるResource情報をまとめて全て引数にしている。  
利用するResourceがこちらに書いてあればModuleでそれを使用することができる  
基本的には編集しないが、使用したいリソースがない場合は追加することになる。  
追加する場合は`メンバーへの共有`はしてください、追加でPullする必要がでてきます。  
※ 現状使用できる全てのResourceを網羅しているわけではないので随時追加することになる

## applyやplan等の実行方法

環境設定にMakeファイルを作成しているため環境全体へのコマンドは  
簡略化したコマンドでterragrunt run-allなどができるようになっている

- init  
全体の場合`terraform-aws-modules/terraform/system/environments`配下で`make init`  
個別のリソースの場合`terraform-aws-modules/terraform/system/environments/dev/[コマンドを実行したいリソースディレクトリ]`配下で`terragrunt init`

- plan  
全体の場合`terraform-aws-modules/terraform/system/environments`配下で`make plan`  
個別のリソースの場合`terraform-aws-modules/terraform/system/environments/dev/[コマンドを実行したいリソースディレクトリ]`配下で`terragrunt plan`

- apply  
全体の場合`terraform-aws-modules/terraform/system/environments`配下で`make apply`  
個別のリソースの場合`terraform-aws-modules/terraform/system/environments/dev/[コマンドを実行したいリソースディレクトリ]`配下で`terragrunt apply`

- destroy  
全体の場合`terraform-aws-modules/terraform/system/environments`配下で`make destroy`  
個別のリソースの場合`terraform-aws-modules/terraform/system/environments/dev/[コマンドを実行したいリソースディレクトリ]`配下で`terragrunt destroy`


## 困ったときは

- 実行できていたTerraformにエラーが出てるが箇所が不明  
複数の環境を行き来したりしていてCacheに差分が出るとTerragruntコマンド実行時にエラーが発生することがある  
その場合は以下のようにしてCacheファイルを消してみて解決できるかやってみましょう。  
`terraform-aws-modules/terraform/system/environments`配下で`make clean`

- Resourceの引数がわからない  
基本的にTerraform公式のResource名と引数は同様にしているが、重複回避のために個別に命名した引数になっているResourceもあります。  
なので確認用にterraform-aws-resourcesもCloneしておき、対象のリソースのmain.tfとvariables.tfで確認することができます。

- その他  
Teamsでメンバー内に聞いてみましょう

## 手順書

実際の構築の流れを記載した手順を以下リンクに配置しています。
不明点、変更点があれば適宜修正をお願いいたします。
https://rfgricoh.sharepoint.com/teams/ZJG_003600/Lists/List/Attachments/40/Terraform%E8%AA%AC%E6%98%8E%E8%B3%87%E6%96%99.xlsx?web=1
