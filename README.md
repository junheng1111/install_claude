# 配置claude code
## 1. 下载VSCode
1. 输入连接 https://code.visualstudio.com
2. 下载vscode
3.  安装vscode, 一直下一步，但是注意 当图片中的 添加到PATH,不要进行勾选。
   ![
   ](image-5.png)
## 2. Install_claude
1. 打开PowerShell
`powershell -ExecutionPolicy Bypass -File .\install_claude.ps1`
## 3. 安装CC Switch
1. 点击这个项目中CC-Switch-v3.13.0-Windows.msi，进行安装
2. 安装成功进入CC Switch后，添加配置
![alt text](image-3.png)
1. 添加配置![alt text](image-4.png)
## 4. 在Vscode中 安装 claude code 插件
![alt text](image/1.png)
![alt text](image/image.png)
输入图片中的内容
![alt text](image.png)
```
"claudeCode.environmentVariables": [
        {
            "name": "ANTHROPIC_BASE_URL",
            "value": "URL"
        },
        {
            "name": "ANTHROPIC_AUTH_TOKEN",
            "value": "TOKEN"
        }
]
```
**VScode中 的claude code 输入的url和token 和CC switch中输入的url 和Key 是一致的**

https://docs.qq.com/sheet/DZHdsZnFDRnJsb09j?tab=BB08J2
