# tfenvを使ったTerraformのインストール手順

## tfenvとは？

[tfenv](https://github.com/tfutils/tfenv)は、実行するTerraformのバージョンをCLIで切り替えることが出来るツール

## tfenvのインストール

```
$ git clone https://github.com/tfutils/tfenv.git ~/.tfenv
$ echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
$ source ~/.bash_profile
```

## tfenvの使い方

### コマンド一覧

```
$ tfenv
tfenv 3.0.0
Usage: tfenv <command> [<options>]

Commands:
   install       Install a specific version of Terraform
   use           Switch a version to use
   uninstall     Uninstall a specific version of Terraform
   list          List all installed versions
   list-remote   List all installable versions
   version-name  Print current version
   init          Update environment to use tfenv correctly.
   pin           Write the current active version to ./.terraform-version
```

### インストール可能なTerraformのバージョンをリスト

```
$ tfenv list-remote
1.2.7
1.2.6
1.2.5
1.2.4
・・・
```

### Terraform v1.3.9をインストール

```
$ tfenv install 1.2.7
Installing Terraform v1.3.9
・・・
Installation of terraform v1.3.9 successful. To make this your default version, run 'tfenv use 1.2.7'
```

### Terraform v1.3.9に切替え

```
$ tfenv use 1.3.9
Switching default version to v1.3.9
Switching completed
```

### Terraformのバージョン確認

```
$ terraform --version
Terraform v1.3.9
on linux_amd64
```

※ Terraform v1.3.9が表示されればOK

### (おまけ) インストール済みのTerraformのバージョンを表示する

```
$ tfenv list
* 1.3.9 (set by /home/mori/ricoh_work/terraform-aws-modules/.terraform-version)
```

### (おまけ) Terraformのバージョンを切り替える

```
$ tfenv use 0.15.5
Switching default version to v0.15.5
Switching completed
$ terraform --version
Terraform v0.15.5
on linux_amd64
```
