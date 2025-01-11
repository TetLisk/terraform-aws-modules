#!/bin/bash

# rhel8 or 9 used

# プロキシ設定を /etc/profile に追記
export PROXY='http://proxy.jp.ricoh.com:8080'
export http_proxy=$PROXY
export HTTP_PROXY=$PROXY
export https_proxy=$PROXY
export HTTPS_PROXY=$PROXY
echo "PROXY='http://proxy.jp.ricoh.com:8080'" | sudo tee -a /etc/profile
echo "export http_proxy=\$PROXY" | sudo tee -a /etc/profile
echo "export HTTP_PROXY=\$PROXY" | sudo tee -a /etc/profile
echo "export https_proxy=\$PROXY" | sudo tee -a /etc/profile
echo "export HTTPS_PROXY=\$PROXY" | sudo tee -a /etc/profile

# プロキシ設定を /etc/yum.conf に追記
echo "proxy=http://proxy.jp.ricoh.com:8080" | sudo tee -a /etc/yum.conf
wait

# 環境変数を反映
source /etc/profile
. /etc/profile
sudo /bin/sh /etc/profile

# 環境変数を確認
printenv $HTTP_PROXY
printenv $HTTPS_PROXY
printenv $http_proxy
printenv $https_proxy

# yumのアップデート
sudo yum update -y

# インスタンスのアーキテクチャを取得
ARCH=$(uname -m)

# SSMエージェントのインストール
if [ "$ARCH" == "x86_64" ]; then
    sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
elif [ "$ARCH" == "aarch64" ]; then
    sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_arm64/amazon-ssm-agent.rpm
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# SSMエージェントの起動と有効化
sudo systemctl start amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent

TOKEN=`sudo curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
echo $TOKEN
HOSTNAME=`sudo curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/tags/instance/Name`
echo $HOSTNAME
sudo hostnamectl set-hostname $HOSTNAME
