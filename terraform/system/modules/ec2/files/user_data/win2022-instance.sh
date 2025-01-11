<powershell>
# プロキシ設定
$env:http_proxy="proxy.jp.ricoh.com:8080"
$env:https_proxy="proxy.jp.ricoh.com:8080"
New-ItemProperty -LiteralPath "HKCU:Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -PropertyType "DWord" -Value "1" -Force
New-ItemProperty -LiteralPath "HKCU:Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyServer" -PropertyType "String" -Value "proxy.jp.ricoh.com:8080" -Force
New-ItemProperty -LiteralPath "HKCU:Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyOverride" -PropertyType "String" -Value "169.254.169.254;*.local;localhost;<local>" -Force
Get-ItemProperty -LiteralPath "HKCU:Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable"
Get-ItemProperty -LiteralPath "HKCU:Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyServer"
Get-ItemProperty -LiteralPath "HKCU:Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyOverride"

netsh winhttp set proxy proxy-server = "proxy.jp.ricoh.com:8080" bypass-list = "169.254.169.254;*.local;localhost"
netsh winhttp show proxy

# ホスト名変更

[string]$token = Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token-ttl-seconds" = "21600"} -Method PUT -Uri http://169.254.169.254/latest/api/token
[string]$osname = Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token" = $token} -Method GET -uri http://169.254.169.254/latest/meta-data/tags/instance/Name
Rename-Computer -NewName $osname

</powershell>
