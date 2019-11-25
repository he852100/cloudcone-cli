# cloudcone-cli
cloudcone命令行工具. 用于 https://api.cloudcone.com.

## 安装
```
$ curl -sSLO https://github.com/he852100/cloudcone-cli/raw/master/cloudcone-cli
$ chmod +x cloudcone-cli
```

## 使用
使用前需要设置`CC_KEY`和 `CC_HASH`环境变量。 或者在脚本中指定`CC_KEY=[...] CC_HASH=[...] cloudcone-cli [...]`参数.

```text
使用:
    cloudcone-cli [action] [id] [选项 ...]

可用操作:
    boot <启动>
    graphs <图表>
    info <虚拟机详细信息>
    reboot <重启>
    shutdown <关机>
    status <状态>

仅适用于计算实例的操作:
    list	<已建虚拟机列表>
    list-os	<可用os列表>
    create              --payload	<创建虚拟机>
    reinstall-os        --payload	<重新安装系统>
    reset-password      --payload	<重置密码>
    resize              --payload	<修改虚拟机大小>

选项:
    -C, --compute       计算实例（默认）
    -D, --dedicated     专用实例
    -d, --payload       有效载荷随请求发送
    -h, --help          显示用法
    -v, --version       打印版本
```
省略`--payload`以获取交互式表单。

如果希望结果易读, 可以使用管道传送到 `| python -m json.tool` 等json解析工具。


