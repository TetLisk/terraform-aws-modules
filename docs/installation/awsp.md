# awspの概要

案件が増えていくとその案件毎にアクセスキーを発行している影響でAWS configure Profileの管理が大変になっていく  
そのため、以下のような簡略できるツールの導入をお勧めする。

## awspのインストール手順
```
npm install -g awsp
vi .bashrc
# some more ls aliases
alias awsp="source _awsp" # どこかに記載する
```

## awspの使い方

- aws profileの作成  
基本的には以下のように作成できる
    ```
    aws configure --profile [PJ-name]
    AWS Access Key ID [None]: 
    AWS Secret Access Key [None]: 
    Default region name [None]: 
    Default output format [None]:
    ```

- awspでの切り替え  
Profile作成後は基本的にexportコマンド等を使ってProfileを切り替えるというのが一般的だが  
awspコマンドにより以下のように簡略化ができる  
コマンドを実行すると対話形式になり、カーソルキーで選択できる。
    ```
    awsp
    AWS Profile Switcher
    ? Choose a profile (Use arrow keys)
      ricoh_poc
    ❯ recycle-system
      rits-sso-sap
      default
    ```

### awspコマンドが使えない場合
上記の設定だけだとうまくコマンドが使えない場合がある  
その場合は以下の設定を実施することで解決できることがある

- bash_profileの作成
    ```
    vi ~/.bash_profile
    ```
- 以下の内容を記載
    ```
    if [[ -f ~/.bashrc ]] ; then
                  . ~/.bashrc
    fi
    ```
- bash_profileの読み込み  
以下コマンドを実行  
    `source ~/.bash_profile`
- それでもうまくいかない場合  
ターミナルの再起動や、PCの再起動を実施
