local module = {}

module.data = [[
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>日志阅读</title>
	<style>html{font-family:sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;}body{margin:0;}button,input,optgroup,select,textarea{margin:0;font:inherit;color:inherit;}button{overflow:visible;}button,select{text-transform:none;}button,html input[type="button"],input[type="reset"],input[type="submit"]{cursor:pointer;-webkit-appearance:button;}table{border-spacing:0;border-collapse:collapse;}td,th{padding:0;}*{-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;}*:before,*:after{-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;}html{font-size:10px;-webkit-tap-highlight-color:rgba(0,0,0,0);}body{font-family:"Helvetica Neue",Helvetica,"Hiragino Sans GB","STHeitiSC-Light","Microsoft YaHei",Arial,sans-serif;font-size:14px;line-height:1.43;color:#333;background-color:#343343;}a{text-decoration:none;color:#59bcda;}a:hover,a:focus{text-decoration:underline;color:#2a9abc;}a:focus{outline:thin dotted;outline:5px auto -webkit-focus-ring-color;outline-offset:-2px;}.clearfix:before,.clearfix:after{display:table;content:" ";}.clearfix:after{clear:both;}.container{margin-right:auto;margin-left:auto;padding:15px;background-color:#fff;}.container:before,.container:after{display:table;content:" ";}.container:after{clear:both;}@media (min-width:768px){.container{width:750px;}}@media (min-width:992px){.container{width:970px;}}@media (min-width:1200px){.container{width:1170px;}}.btn{display:inline-block;margin-bottom:0;border:1px solid transparent;border-radius:2px;padding:4px 6px;font-size:14px;font-weight:normal;line-height:1.43;text-align:center;vertical-align:middle;white-space:nowrap;background-image:none;cursor:pointer;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;touch-action:manipulation;}.btn:focus,.btn.focus,.btn:active:focus,.btn:active.focus,.btn.active:focus,.btn.active.focus{outline:thin dotted;outline:5px auto -webkit-focus-ring-color;outline-offset:-2px;}.btn:hover,.btn:focus,.btn.focus{text-decoration:none;color:#fff;}.btn:active,.btn.active{background-image:none;outline:0;-webkit-box-shadow:inset 0 3px 5px rgba(0,0,0,.125);box-shadow:inset 0 3px 5px rgba(0,0,0,.125);}.btn.disabled,.btn[disabled]{opacity:.65;-webkit-box-shadow:none;box-shadow:none;cursor:not-allowed;pointer-events:none;filter:alpha(opacity=65);}.btn-primary{border-color:#46c29d;color:#fff;background-color:#59c8a7;}.btn-primary:focus,.btn-primary.focus{border-color:#226652;color:#fff;background-color:#3bb38f;}.btn-primary:hover{border-color:#32987a;color:#fff;background-color:#3bb38f;}.btn-primary:active,.btn-primary.active{border-color:#32987a;color:#fff;background-color:#3bb38f;}.btn-primary:active:hover,.btn-primary:active:focus,.btn-primary:active.focus,.btn-primary.active:hover,.btn-primary.active:focus,.btn-primary.active.focus{border-color:#226652;color:#fff;background-color:#32987a;}.btn-primary:active,.btn-primary.active{background-image:none;}.btn-primary.disabled:hover,.btn-primary.disabled:focus,.btn-primary.disabled.focus,.btn-primary[disabled]:hover,.btn-primary[disabled]:focus,.btn-primary[disabled].focus{border-color:#46c29d;background-color:#59c8a7;}.btn-gray{border-color:#8b8b8b;color:#fff;background-color:#989898;}.btn-gray:focus,.btn-gray.focus{border-color:#4c4c4c;color:#fff;background-color:#7f7f7f;}.btn-gray:hover{border-color:#6d6d6d;color:#fff;background-color:#7f7f7f;}.btn-gray:active,.btn-gray.active{border-color:#6d6d6d;color:#fff;background-color:#7f7f7f;}.btn-gray:active:hover,.btn-gray:active:focus,.btn-gray:active.focus,.btn-gray.active:hover,.btn-gray.active:focus,.btn-gray.active.focus{border-color:#4c4c4c;color:#fff;background-color:#6d6d6d;}.btn-gray:active,.btn-gray.active{background-image:none;}.btn-gray.disabled:hover,.btn-gray.disabled:focus,.btn-gray.disabled.focus,.btn-gray[disabled]:hover,.btn-gray[disabled]:focus,.btn-gray[disabled].focus{border-color:#8b8b8b;background-color:#989898;}th{text-align:left;}.table{margin-bottom:15px;width:100%;max-width:100%;}.table>thead>tr>th,.table>thead>tr>td,.table>tbody>tr>th,.table>tbody>tr>td,.table>tfoot>tr>th,.table>tfoot>tr>td{border:1px solid #ddd;padding:6px;line-height:1.43;vertical-align:top;}.table>thead>tr>th{color:#426278;border-bottom:1px solid #ddd;vertical-align:bottom;background-color:#f6f8fa;}.table-middle>thead>tr>th,.table-middle>thead>tr>td,.table-middle>tbody>tr>th,.table-middle>tbody>tr>td,.table-middle>tfoot>tr>th,.table-middle>tfoot>tr>td{vertical-align:middle;}.input-group{display:table;border-collapse:separate;position:relative;}.input-group[class*="col-"]{float:none;padding-right:0;padding-left:0;}.input-group .form-control{float:left;position:relative;z-index:2;margin-bottom:0;width:100%;}.input-group-addon,.input-group-btn,.input-group .form-control{display:table-cell;}.input-group-addon:not(:first-child):not(:last-child),.input-group-btn:not(:first-child):not(:last-child),.input-group .form-control:not(:first-child):not(:last-child){border-radius:0;}.input-group-addon,.input-group-btn{width:1%;vertical-align:middle;white-space:nowrap;}.input-group-addon{border:1px solid #ccc;border-radius:2px;padding:4px 6px;font-size:14px;font-weight:normal;line-height:1;text-align:center;color:#555;background-color:#eee;}.input-group-addon.input-sm,.input-group-sm>.input-group-addon,.input-group-sm>.input-group-btn>.input-group-addon.btn{border-radius:1px;padding:5px 10px;font-size:12px;}.input-group-addon.input-lg,.input-group-lg>.input-group-addon,.input-group-lg>.input-group-btn>.input-group-addon.btn{border-radius:2px;padding:10px 16px;font-size:16px;}.input-group-addon input[type="radio"],.input-group-addon input[type="checkbox"]{margin-top:0;}.input-group .form-control:first-child,.input-group-addon:first-child,.input-group-btn:first-child>.btn,.input-group-btn:first-child>.btn-group>.btn,.input-group-btn:first-child>.dropdown-toggle,.input-group-btn:last-child>.btn:not(:last-child):not(.dropdown-toggle),.input-group-btn:last-child>.btn-group:not(:last-child)>.btn{border-top-right-radius:0;border-bottom-right-radius:0;}.input-group-addon:first-child{border-right:0;}.input-group .form-control:last-child,.input-group-addon:last-child,.input-group-btn:last-child>.btn,.input-group-btn:last-child>.btn-group>.btn,.input-group-btn:last-child>.dropdown-toggle,.input-group-btn:first-child>.btn:not(:first-child),.input-group-btn:first-child>.btn-group:not(:first-child)>.btn{border-top-left-radius:0;border-bottom-left-radius:0;}.input-group-addon:last-child{border-left:0;}.input-group-btn{position:relative;font-size:0;white-space:nowrap;}.input-group-btn>.btn{position:relative;}.input-group-btn>.btn+.btn{margin-left:-1px;}.input-group-btn>.btn:hover,.input-group-btn>.btn:focus,.input-group-btn>.btn:active{z-index:2;}.input-group-btn:first-child>.btn,.input-group-btn:first-child>.btn-group{margin-right:-1px;}.input-group-btn:last-child>.btn,.input-group-btn:last-child>.btn-group{margin-left:-1px;}.pager{list-style:none;margin:0;padding-left:0;text-align:center;}.pager:before,.pager:after{display:table;content:" ";}.pager:after{clear:both;}.pager li{display:inline;}.pager li>a,.pager li>span{display:inline-block;border:1px solid #ddd;border-radius:15px;padding:5px 14px;background-color:#fff;}.pager li>a:hover,.pager li>a:focus{text-decoration:none;background-color:#eee;}.pager .next>a,.pager .next>span{float:right;}.pager .previous>a,.pager .previous>span{float:left;}.pager .disabled>a,.pager .disabled>a:hover,.pager .disabled>a:focus,.pager .disabled>span{color:#777;background-color:#fff;cursor:not-allowed;}.pagination{display:inline-block;position:relative;margin-bottom:16px;border-radius:2px;padding-left:0}.pagination>li{display:inline}.pagination>li>a,.pagination>li>span{float:left;position:relative;margin-left:-1px;border:1px solid #ddd;padding:6px 12px;line-height:1.2;text-decoration:none;color:#59bcda;background-color:#fff}.pagination>li:first-child>a,.pagination>li:first-child>span{margin-left:0;border-top-left-radius:2px;border-bottom-left-radius:2px}.pagination>li:last-child>a,.pagination>li:last-child>span{border-top-right-radius:2px;border-bottom-right-radius:2px}.pagination>li>a:focus,.pagination>li>a:hover,.pagination>li>span:focus,.pagination>li>span:hover{border-color:#ddd;color:#2a9abc;background-color:#eee}.pagination>.active>a,.pagination>.active>a:focus,.pagination>.active>a:hover,.pagination>.active>span,.pagination>.active>span:focus,.pagination>.active>span:hover{z-index:2;border-color:#59bcda;color:#fff;background-color:#59bcda;cursor:default}.pagination>.disabled>a,.pagination>.disabled>a:focus,.pagination>.disabled>a:hover,.pagination>.disabled>span,.pagination>.disabled>span:focus,.pagination>.disabled>span:hover{border-color:#ddd;color:#777;background-color:#fff;cursor:not-allowed}.pagination-size,.pagination-goto{padding:0 13px;}.pagination-info{padding:5px 13px;}.pagination-wrap .pagination{margin:0;padding:0 13px;}.pagination-size .form-control,.pagination-goto .form-control{display:inline-block;}.pagination-size,.pagination-info,.pagination-goto{vertical-align:top;}.form-control{display:block;border:1px solid #ccc;border-radius:2px;padding:4px 6px;width:100%;height:30px;font-size:14px;line-height:1.43;color:#555;background-color:#fff;background-image:none;-webkit-box-shadow:inset 0 1px 1px rgba(0,0,0,.075);box-shadow:inset 0 1px 1px rgba(0,0,0,.075);-webkit-transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s;-o-transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s;transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s;}.form-control:focus{border-color:#59bcda;outline:0;}label{display:inline-block;max-width:100%;margin-bottom:5px;font-weight:700;}.col{width:250px;float:left;}.form-inline .form-group{display:inline-block;margin-bottom:15px;vertical-align:middle;}.form-inline .input-group{display:inline-table;vertical-align:middle;}.form-inline .form-control{display:inline-block;width:auto;vertical-align:middle;}.w-150px{width:150px !important;}.w-80px{width:80px !important;}.mr-15px{margin-right:15px;}.text-right{text-align:right;}.a{cursor:hand;}.text-wordbreak{word-break:break-all;word-wrap:break-word;}.text-center{text-align:center;}.inline{display:inline-block;}</style>
</head>

<body>
	<div class="LeftMode"></div>
	<div class="container">
		<div class="clearfix">
			<div class="form-inline">
				<div class="form-group mr-15px">
					<label>就诊卡号：</label>
					<div class="input-group w-150px">
						<input type="text" name="AccNoConTent" id="HisId" class="form-control w-150px" onkeypress="SearchKeyPress(event)" placeholder="请输入就诊卡号">
						<span class="input-group-btn">
							<button class="btn btn-primary" type="button" onclick="Search()">搜索</button>
						</span>
					</div>
				</div>

				<div class="form-group mr-15px">
					<label>操作类型：</label>
					<select id="SelectType" class="form-control w-150px" onchange="Search()">
						<option value="">请选择</option>
						<option value="GetHis">预约登记</option>
						<option value="JiaoHao">叫号</option>
						<option value="State">状态</option>
						<option value="Report">报告</option>
						<option value="HealthyExem">体检</option>
					</select>
				</div>

				<div class="form-group mr-15px">
					<label>状态：</label>
					<select id="SelectState" class="form-control w-150px" onchange="Search()">
						<option value="">请选择</option>
						<option value="Sucess">成功</option>
						<option value="Failed">失败</option>
					</select>
				</div>

				<div class="form-group">
					<label>操作时间：</label>
					<div class="input-group w-150px">
						<input type="date" name="" id="STime" class="form-control w-150px" value="" placeholder="日期如:20170102">
						<span class="input-group-btn">
							<button class="btn btn-primary" type="button" onclick="Search()">搜索</button>
						</span>
					</div>
				</div>
			</div>
		</div>

		<table class="table table-middle">
			<thead>
				<tr>
					<th width="50" class="text-center">序号</th>
					<th width="130" class="text-center">日志ID</th>
					<th width="140" class="text-wordbreak text-center">姓名</th>
					<th width="180" class="text-center">检查号</th>
					<th width="180" class="text-center">就诊卡号</th>
					<th width="90" class="text-center">状态</th>
					<th width="160" class="text-center">时间</th>
					<th width="100" class="text-center">类型</th>
					<th width="" class="text-center">操作</th>
				</tr>
			</thead>

			<tbody id="xmlItem">
			<lbsModifyItem******lbsModifyItem>
			</tbody>
		</table>
		<div class="pagination-wrap text-center">
			<ul class="pagination inline" id="currpage" title="1">
				<li class="first">
					<a href="javascript:;" onclick="pageSwitch(1)">首页</a>
				</li>
				<li class="prev">
					<a href="javascript:;" onclick="pageSwitch(2)">上一页</a>
				</li>
				<li class="next">
					<a href="javascript:;" onclick="pageSwitch(3)">下一页</a>
				</li>
				<li class="last">
					<a href="javascript:;" onclick="pageSwitch(4)">末页</a>
				</li>
			</ul>
			<div class="pagination-goto inline">
				<span class="inline">去第</span>
				<input type="text" id="PageNum" value="" class="form-control w-80px" onkeypress="JumpTargetPage()">
				<span class="inline">页</span>
			</div>
			<div class="pagination-info inline">
				<span id="showpage" title="<lbsModifyItem***numMaxPage***lbsModifyItem>"><lbsModifyItem***strMaxPage***lbsModifyItem></span> 页
		</div>
	</div>

	<script>
		var globalUrl="http://192.168.157.139:8080"
		function getArg(){
			var strArgData = {HisId:"",SelectType:"",SelectState:"",STime:""}
			var temp
			for (key in strArgData){
				strArgData[key] = document.getElementById(key).value
			}					
			return strArgData
		}
		
		function creatUrl(){
			var strArgData = getArg()
			var strUrl = ""
			for (key in strArgData){			
				strUrl = strUrl + key + "=" + strArgData[key] + "&"
			}	
			if (strUrl.charAt(strUrl.length - 1) == "&") {
				strUrl = strUrl.substring(0, strUrl.length - 1);
			}
			
			return strUrl
		}

		function detailother(id) {
			var CurrentUrl = globalUrl + '/Discript?RequestType=detailother&LogId=' + document.getElementById(id).innerText
			window.open(CurrentUrl);
		}
		
		function detailyz(id) {
			var CurrentUrl = globalUrl + '/Discript?RequestType=detailyz&LogId=' + document.getElementById(id).innerText
			window.open(CurrentUrl);
		}
		
		function pageSwitch(numPageType){
			var strType, numCurrPage, strJsonData
			var strCurrPage = document.getElementById("currpage").title
			var strMaxPageObj = document.getElementById("showpage")
			console.log("currpage ? ",strCurrPage)
			switch(numPageType)
			{
			    case 1:
			        strType = "&RequestType=FirstPage"
					numCurrPage = 1
			        break;
			    case 2:
			        strType = "&RequestType=UpPage"
			        if (parseInt(strCurrPage) == 1){ 
			        	numCurrPage = 1
						console.log("1 page return ")
						return
			        }
			    	else{
			       		numCurrPage = parseInt(strCurrPage) - 1
			       	}
			        break;
			    case 3:
			        strType = "&RequestType=DownPage"
			        numCurrPage = parseInt(strCurrPage) + 1
					if (numCurrPage > Math.ceil(parseInt(strMaxPageObj.title) / 20)){
						console.log("last page not down")
						return
					}
			        break;
			    case 4:
			        strType = "&RequestType=LastPage"
					numCurrPage = Math.ceil(parseInt(strMaxPageObj.title) / 20) 
					console.log("currpage ?",numCurrPage)
					if (parseInt(strCurrPage) >= Math.ceil(parseInt(strMaxPageObj.title) / 20)){
						console.log("strCurrPage " + strCurrPage + " max " + parseInt(strMaxPageObj.title) + " not last")
						return
					}
			        break;	    
			    default:
			    strType = "&RequestType=FirstPage"
			}

			document.getElementById("currpage").title = numCurrPage.toString()
			document.getElementById("PageNum").value = numCurrPage.toString()
			var strGetUrl = creatUrl()
			var strUrl = "/Page?" + "&MaxPage=" + strMaxPageObj.title + strType + "&CurrentPage=" + strCurrPage + "&" + strGetUrl	
			console.log("send ? ",strUrl)
			PageUseAjax(strUrl,numCurrPage.toString())
		}

		function JumpTargetPage(){
			var evt = window.event || e;
			if (evt.keyCode == 13) {
				var strMaxPageObj = document.getElementById("showpage")				 
				var numJumpPage = parseInt(document.getElementById("PageNum").value)
				
				if (numJumpPage == 1) {
					document.getElementById("currpage").title = 1				
					pageSwitch(1)
				}			
				else if (numJumpPage > Math.ceil(parseInt(strMaxPageObj.title) / 20)){
					alert('输入页数太大')
				}
				else{
					document.getElementById("currpage").title = numJumpPage - 1
					console.log("JumpTargetPage curr? ",document.getElementById("currpage").title)
					pageSwitch(3)
				}
			}
		}

		function SearchKeyPress(e){
			document.getElementById("PageNum").value = "1"
			document.getElementById("currpage").title = "1"
			var evt = window.event || e; 
			if (evt.keyCode == 13){
				var strGetUrl = creatUrl()
				var strUrl = "/Page?" + "&" + strGetUrl + "&CurrentPage=1" + "&RequestType=FirstPage"
				console.log("send url ",strUrl)
				PageUseAjax(strUrl,'1')
			}
		}		

		function Search(){
			document.getElementById("PageNum").value = "1"
			document.getElementById("currpage").title = "1"
			var strGetUrl = creatUrl()
			var strUrl = "/Page?" + "&" + strGetUrl + "&CurrentPage=1" + "&RequestType=FirstPage"
			console.log("send url ",strUrl)
			PageUseAjax(strUrl,'1')			
		}
		
		function PageUseAjax(strUrl,strCurrPage){
			var xmlhttp
			
			if (window.XMLHttpRequest){
				// IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
				xmlhttp=new XMLHttpRequest();
			}
			else{
				// IE6, IE5 浏览器执行代码
				xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
			}
			xmlhttp.onreadystatechange=function(){
				if (xmlhttp.readyState==4 && xmlhttp.status==200){
					var strJsonData = xmlhttp.responseText;
					g_strJsonData = strJsonData
					var strMaxPageObj = document.getElementById("showpage")
					strJsonData = JSON.parse(strJsonData)				
					strMaxPageObj.title = strJsonData["size"]
					console.log("strMaxPageObj.title? ",strMaxPageObj.title)
					ModifyMaxPageSize(strCurrPage)
					document.getElementById("xmlItem").innerHTML=strJsonData["xmlItem"];	
				}
			}
			xmlhttp.open("GET",strUrl,true);
			xmlhttp.send();
		}

		function ModifyMaxPageSize(strCurrPage){
			console.log("enter modify")
			var strMaxPageObj = document.getElementById("showpage")
			var numSize = parseInt(strMaxPageObj.title)
			if (numSize == 0){
				strMaxPageObj.innerHTML = "0/0"
				document.getElementById("PageNum").value = 0
			}
			else{
				strMaxPageObj.innerHTML = strCurrPage + "/" + Math.ceil(numSize / 20)	
			}
		}
	</script>
</body>

</html>
]]

return module