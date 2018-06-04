local module = {}

module.data = [[
<!DOCTYPE html>
<html lang="en">
<head>
		<meta charset="utf-8" >
		<title>查看日志详细内容</title>
<style>
	body{margin:0;}body{font-family:"Helvetica 	Neue",Helvetica,"HiraginoSansGB","STHeitiSC-Light","MicrosoftYaHei",Arial,sans-serif;font-size:20px;line-height:1.43;}
	.tdOne{border:solid #D2A2CC; border-width:1px 1px 1px 1px;word-wrap:break-word; height:80%;}
	.tableOne{border:solid  #D0D0D0; border-width:1px 1px 1px 1px;table-layout:fixed;.tbItem{color : red;}}
</style>		
</head>
<br/>
<body>
	<div style="width:80%; height:600px;margin:auto auto;padding-top:80px">
	 <font color="#6A6AFF"><b>通信内容:</b></font>
		<table class="tableOne" border="1px" cellspacing="0" cellpadding="0" width="100%" height="100%";>
			<tr>
				<td class="tdOne" valign="top">
					<div class="ClassOne" style="overflow-y:scroll;height:600px;" id="ContentOne">
						<font size="4" face="宋体">
							<lbsModifyItem***Detail***lbsModifyItem>
						</font>
					</div>
				</td>
			</tr>			
		</table>
	</div>
</body>
</html>
]]


return module