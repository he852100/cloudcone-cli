# cloudcone-cli
cloudcone命令行工具. 用于 https://api.cloudcone.com。

## 安装
```
$ curl -sSLO https://github.com/he852100/cloudcone-cli/raw/master/powershell/cloudcone-cli.ps1
$ chmod +x cloudcone-cli.ps1
```

## 使用
使用前需要设置`CC_KEY`和 `CC_HASH`环境变量。 或者在脚本中指定`CC_KEY=[...] CC_HASH=[...] cloudcone-cli [...]`参数.

```text
使用:
    cloudcone-cli -name [操作] -id [id] [选项 ...]

可用操作:
    boot	<启动>
    graphs	<图表>
    info	<虚拟机详细信息>
    reboot	<重启>
    shutdown	<关机>
    status	<状态>

仅适用于计算实例的操作:
    list	<已建虚拟机列表>
    list-os	<可用os列表>
    create     	<创建虚拟机>
    reinstall	<重新安装系统>
    reset-password	<重置密码>
    resize              <修改虚拟机大小>
示例:
	cloudcone-cli -Name info|%{$_.__data.instances}
	(cloudcone-cli -Name info).__data.instances
	cloudcone-cli -Name reset-password	<重置密码>
	cloudcone-cli.ps1 -Name info|ConvertTo-Json	<输出json>
```
省略`-id *`以获取交互式表单。



