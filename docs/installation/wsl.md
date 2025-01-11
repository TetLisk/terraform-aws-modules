# WSL

## WSLについて
WidowsOS内でLinuxディストリビューションを実行できる機能

支給される我々のPCはWindowsになるため、この環境のようないろいろなPluginを使って簡略かしたりすることがWindowsでは難しい場合が多いです。  
なのでWSLを使用してWindows上でLinuxを使用したほうがより効率よく作業できると思っています。

## WSLの導入について

サイトを探せばいくらでもでてくるが、以下に基本的なインストール方法を記載する。  
[参考](https://devlog.grapecity.co.jp/wsl-2-setup/)

### WSLインストール手順
以下の手順は全て管理者権限で実行したPowershell上で実施する

- WSLのインストール  
`wsl --install`

- OSの再起動

- Ubutnuの起動及び初期設定  
`wsl`でUbuntu起動後画面の通りに初期設定を実施

- WSLのバージョン確認
    ```
    wsl -l -v
      NAME            STATE           VERSION
    * Ubuntu-20.04    Running         2
    ```
    ここでVersionが1になっている場合は、概ね問題は出ないがたまに固有のエラー等が出る場合があるため  
    次項のバージョンアップを実施したほうが良い

- WSLバージョンアップ
    ```
    wsl --set-version [distribution-name] 2
    wsl --set-default-version 2
    ```
