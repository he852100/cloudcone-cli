[CmdletBinding(DefaultParameterSetName = "instances")]
param(
    [ValidateSet('graphs','boot','reboot','shutdown','Destroy','info','status','list-os','list',"reinstall","create","resize","reset-password")]
    [string] $Name,
    [int32] $id

)
$headers = @{
    "App-Secret" = "$CC_KEY"
    "Hash" = "$CC_HASH"
}
$changgui='graphs','boot','reboot','shutdown','Destroy','info','status','list-os','list'
$changgui1=$changgui + "reinstall","create","resize","reset-password"
If ($changgui1 -NotContains $Name){
Write-Host '用法:
    cloudcone-cli.ps1 -name [操作] -id [id] [选项 ...]

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
	cloudcone-cli.ps1 -Name info|ConvertTo-Json	<输出json>'
}elseif($Name){
$uri='https://api.cloudcone.com/api/v1/compute'
if(-not(($headers.'App-Secret'.length -gt 10) -and ($headers.Hash.Length -gt 10))  ){
Write-Host -ForegroundColor Black -BackgroundColor White "没有设置变量，请设置`$CC_KEY，`$CC_HASH临时变量，或在cloudcone-cli.ps1中指定"
break}
$instances=Invoke-RestMethod -Uri "$uri/list/instances" -Method get -Headers $headers|%{$_.__data.instances}
if($name -eq "resize"){
$post=@('cpu','ram','disk')
$nm=@("1","1024","20")
$note=@('CPU 核心数(1-16)','RAM in MB(512-16000)','硬盘空间（GB）')
}
if($name -eq "reinstall"){
#Invoke-RestMethod -Uri "$uri/list/os" -Method get -Headers $headers|%{$_.__data}|out-host
$post=@('os')
$nm=@("54")
$note=@('操作系统编号')
}
if($name -eq "reset-password"){
$post=@('password',"reboot")
$nm=@(";:.-/_:-,……-","false")
$note=@('修改密码')
}
if($name -eq "create"){
#Invoke-RestMethod -Uri "$uri/list/os" -Method get -Headers $headers|%{$_.__data}|out-host
$note=@('主机名','CPU 核心数(1-16)','RAM in MB(512-16000)','硬盘空间（GB）','ipv4数量(1-100)','操作系统','启用 SSD (1/0)','启用专用网络 (1/0)','启用 IPv6 (on/off)')
$post=@('hostname','cpu','ram','disk','ips','os','ssd','pvtnet','ipv6')
$nm=@("test.com","1","1024","20","1","54","0","1","on")
}
if("reinstall","create","resize","reset-password" -Contains $Name){
for($i=0;$i -lt ($post.Length);$i++){
if ("os" -eq $post[$i]){Invoke-RestMethod -Uri "$uri/list/os" -Method get -Headers $headers|%{$_.__data}|out-host}
$read=Read-Host $note[$i] "默认值："$nm[$i]
$var=if($read){$read}else{$nm[$i]}
$var1=$var1 + ("&" + $post[$i] + "=" + $nm[$i])
}
$var2=$var1 -replace "^."
if("create" -notContains $Name ){
if($instances.id -notContains $id ){
$instances | Format-Table id,distro,created,ips|out-host
Write-Host "请输入" -ForegroundColor DarkBlue -NoNewline; Write-Host "id:" -ForegroundColor black -BackgroundColor White -NoNewline; [int32]$id=Read-Host;
if($instances.id -notContains $id ){
Write-Host -ForegroundColor Black -BackgroundColor White "你输入的id无效，请重新执行命令"
break}
}}
$swi= switch ($name){
reinstall {"/$id/$name"}
create {"/$name"}
resize {"/$id/$name"}
reset-password {"/$id/reset/pass"}
}
$headers = $headers += @{'Content-Type' = 'application/x-www-form-urlencoded'}
irm $uri$swi -Method post -Headers $headers -body "$var2"|%{
$_.status
$_.message
$_.__data.instances
$_.__data}
}
if ($changgui -Contains $Name){
if("list","list-os" -notContains $Name ){
if($instances.id -notContains $id ){
$instances | Format-Table id,distro,created,ips|out-host
Write-Host "请输入" -ForegroundColor DarkBlue -NoNewline; Write-Host "id:" -ForegroundColor black -BackgroundColor White -NoNewline; [int32]$id=Read-Host;
if($instances.id -notContains $id ){
Write-Host -ForegroundColor Black -BackgroundColor White "你输入的id无效，请重新执行命令"
break}
}}
$swi= switch ($name){
graphs {"/$id/$name"}
boot {"/$id/$name"}
reboot {"/$id/$name"}
shutdown {"/$id/$name"}
Destroy {"/$id/$name"}
info {"/$id/$name"}
status {"/$id/$name"}
list-os {"/list/os"}
list {"/$name/instances"}}
irm $uri$swi -Method get -Headers $headers|%{
$_.status
$_.message
$_.__data.instances
$_.__data}
}}
