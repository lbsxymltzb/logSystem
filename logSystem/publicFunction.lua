
local cjson = require "cjson"

tbRevers = {b = 'b',"/b",br = "br","/br","/font",fron='font size="4" face="宋体"'}

local decodeURI
do
    local char, gsub, tonumber = string.char, string.gsub, tonumber
    local function _(hex) return char(tonumber(hex, 16)) end

    function decodeURI(s)
		if s == nil then
			return ""
		end
        s = gsub(s, '%%(%x%x)', _)
		s = gsub(s, '+', " ")
        return s
    end
end

-----------------------------------------------------
-- 函数功能:将字符串中的魔法字符转义
-- 函数参数:parameter[1]:带魔法字符的字符串
-- 返回值:转义之后的字符串,比如 str="%^" 返回 str="%%%^"
-----------------------------------------------------
function modifyMegicChar(str)
	local str = string.gsub(tostring(str),"[%^%$%(%)%%%.%[%]%*%+%-%?]",function(c)
			return '%'..c
		end
	)
	return str
end

function modfyHtml(str,strTab,strN)
	local tbMegic = {
		[1] = '<',
		[2] = '>',
	}
	local tbChange = {
		[1] = '&lt',
		[2] = '&gt',
	}

	local tb = {}

	newStr = modifyItem(str,strTab,strN)
	
	for i=1,#tbMegic do 
		newStr = string.gsub(newStr,tbMegic[i],tbChange[i])
	end
	for i,j in pairs(tbRevers) do
		--newStr = string.gsub(newStr,modifyMegicChar('&ltbr&gt'),'<br>')
		newStr = string.gsub(newStr,modifyMegicChar('&lt'..j..'&gt'),'<'..j..'>')
	end
	--newStr = string.gsub(newStr,modifyMegicChar('&lt'),'<')
	--newStr = string.gsub(newStr,modifyMegicChar('&gt'),'>')
	return newStr
end

function modifyItem(str,strTab,strN)
	local tbStackHead = {}
	local tbStackTail = {}
	local strMdHead = '(<%a+.->)'
	local strMdtail = '(</%a+.->)'
	local postT = 0
	local postH = 0
	local headT,tailT,valueT,headH,tailH,valueH	
	while true do
		headT,tailT,valueT = string.find(str,strMdtail,postT)
		if headT then 
			local strItemName = getIteName(valueT)
			if strItemName then 
				tbStackTail[#tbStackTail + 1] = {name = strItemName, count = #tbStackTail + 1}
				if #tbStackHead ~= 0 and tostring(tbStackHead[#tbStackHead].name) == tostring(tbStackTail[#tbStackTail].name) then
					local strTempHead = string.sub(str,1,headT-1)
					local strTempTail = string.sub(str,tailT+1, -1)
					local strAdd = strTab	
					strAdd = strN..string.rep(strAdd,tbStackHead[#tbStackHead].count)
					str = strTempHead..strAdd..valueT..strTempTail
					tbStackHead[#tbStackHead] = nil
					tbStackTail[#tbStackTail] = nil	
					postT = tailT + #strAdd
				else
					postT = tailT
				end				
			end
		else
			break
		end

		if #tbStackTail > 0 then			
			while true do 			
				headH,tailH,valueH = string.find(str,strMdHead,postH)
				if headH == nil then
					break
				else
					local strTempHead = string.sub(str,1,headH-1)
					local strTempTail = string.sub(str,tailH+1, -1)
					local strAdd = strTab
					local strItemName = getIteName(valueH)
					local strEmpty = '(<'..strItemName..'/>)'
					if string.match(valueH,strEmpty) then		
						strAdd = strN..string.rep(strAdd,#tbStackHead+1)
						str = strTempHead..strAdd..valueH..strTempTail	
						postH = tailH + #strAdd
						postT = postT + #strAdd	
					else
						if strItemName then
							tbStackHead[#tbStackHead + 1] = {name = strItemName, count = #tbStackHead + 1}
						end
						strAdd = strN..string.rep(strAdd,tbStackHead[#tbStackHead].count)					
						str = strTempHead..strAdd..valueH..strTempTail
						postH = tailH + #strAdd
						postT = postT + #strAdd						
						if tostring(tbStackHead[#tbStackHead].name) == tostring(tbStackTail[#tbStackTail].name) then 
							tbStackHead[#tbStackHead] = nil
							tbStackTail[#tbStackTail] = nil	
							break
						else					
						end
					end
				end		
			end
		end
	end
	return str
end

function getIteName(value)
	local head,tail,tmpvalue = string.find(value,'%s')
	if head then 
		value = string.sub(value,1,head-1)..'>'
	end
	strItemNameT = string.match(value,'</(%a+.-)>')
	strItemNameH = string.match(value,'<(%a+.-)>')
	strItemNameH = strItemNameH and string.gsub(strItemNameH,'/','')
	local res = strItemNameT or strItemNameH
	if res then 
		return res
	else
		error('cant getIteName ['..value..']')
	end	
end

function jjj(str,key)
	local res = ''
	local strMatch = tostring(key).."=([^&]*)"
	 --ngx.say('str ?',str)
	 --ngx.say('match ? ',strMatch)
	local count = 0
	for c in string.gmatch(str,strMatch) do 
		count = count + 1
		res = res..c..'&ltbr&gt'
	end
	--ngx.say('count ?',count)
	--ngx.say('res ?', res)
	return res
end

function getValue(str)
	res = ''
	for a,b,c in string.gmatch(str, '%*(.-)%*(.-)%*(.-)%*') do
		if string.match(a,"(show)") then 
			res = res.."&lt/br&gt".."&lt"..tbRevers.fron.."&gt".."&lt"..tbRevers.b.."&gt"..b.."&lt/b&gt".."&lt/font&gt"
			--res = res..b
		else
			res = res.."&lt".."/br".."&gt&nbsp&nbsp"..b
		end
	end
	return res
end

--------------------------------------------------------------------------
-- 函数功能:将一个字符串转换成大小写通用匹配模式,比如lbs -> [lL][bB}[sS]
-- 函数参数:parameter[1]:非空的字符串
-- 返回值:return[1]:成功返回非空字符串,失败返回nil,return[2]:返回错误信息
--------------------------------------------------------------------------
function aToAa(str) 
	if str == "" or str == nil then 
		return nil,"parameter[1] is nil"
	else
		str = string.gsub(str,'%a',function(c) 
			return string.format('[%s%s]',string.upper(c),string.lower(c))
			end
		)
		return str
	end
end

function getData(tbDBdata,numShowCount,urlType)
	local tbData = {}
	local count = 0
	if numShowCount > #tbDBdata then numShowCount=#tbDBdata end
	count = count + 1
	for i=1,numShowCount do 
		local tbBody = 
		{
			[1] = '',
			[2] = 'id',
			[3] = 'patientName',
			[4] = 'checkNo',
			[5] = 'hisid',
			[6] = 'status',
			[7] = 'time',
			[8] = 'type',
			[9] = '',
		}
		for i1 = 2,8 do 
			local tempData = tostring(tbDBdata[i][tbBody[i1]])
			if tempData then 
				if #tempData > 100 then
					tbBody[i1] = string.sub(tempData,1,100)
					--tbBody[i] = tempData
				elseif string.match(tempData,aToAa("null")) then
					tbBody[i1] = ' '
				else
					tbBody[i1] = tempData
				end				
			else
				tbBody[i1] = ''
			end
		end
		tbBody[1] = i
		tbBody[9] = i
		tbBody[6] = tostring(tbBody[6]) == '0' and '成功' or tostring(tbBody[6]) == '1' and '失败'
		tbData[i] = tbBody
	end
	return tbData
end

function ModifyPage(str,num)
	local strUp = '"UpPageFunc('..num..')"'
	local strDown = '"DownPageFunc('..num..')"'
	str = string.gsub(str,'"UpPageFunc.-"',strUp)
	str = string.gsub(str,'"DownPageFunc.-"',strDown)
	return str
end

function CreateItem(tbJs,strHtmlMod,numShowCount,numPage)
	local res = getData(tbJs,numShowCount)
	local strShow = ''
	for i,j in ipairs(res) do 
		if type(j) == "table" then 
			for  i1, j1 in ipairs(j) do 
				if i1 == 2 then 
					strShow = strShow..'<td id="'..i..'" class="text-center">'..j1..'</td>'
				elseif i1 == 3 then 
					strShow = strShow..'<td class="text-wordbreak text-center">'..j1..'</td>'					
				elseif i1 == 9 then 
					--local temp = '<td><input type="button" name="DetailLog1" value="平台" onclick="disCript(1)" class="btn btn-gray" style="text-align:left" /><input type="button" name="DetailLog2" value="医真" onclick="disCript(1)" class="btn btn-gray" style="text-align:right" /></td>'					
					local temp = [[<td class="text-center"><input type="button" name="DetailLog" value="平台" onclick="detailother(1)" class="btn btn-gray"  />
						<input type="button" name="DetailLog" value="医真" onclick="detailyz(1)" class="btn btn-gray" /></td>]]
					temp = string.gsub(temp,'onclick="detailother.-"','onclick="detailother('..i..')"')
					temp = string.gsub(temp,'onclick="detailyz.-"','onclick="detailyz('..i..')"')
					strShow = strShow..temp
				else
					strShow = strShow..'<td class="text-center">'..tostring(j1).."</td>"
				end
			end
		end
		strShow = "<tr>"..strShow.."</tr>"
	end	
	return strShow
end

function CreateHtml(tbJs,strHtmlMod,numShowCount,numPage)
	local strShow = CreateItem(tbJs,strHtmlMod,numShowCount,numPage)
	strHtmlMod = ModifyPage(strHtmlMod,numPage)
	strHtmlMod = string.gsub(strHtmlMod,'<lbsModifyItem%*%*%*%*%*%*lbsModifyItem>',strShow)
	strHtmlMod = string.gsub(strHtmlMod,'<lbsModifyItem%*%*%*'..'.-'..'%*%*%*lbsModifyItem>','')
	
	--if strIpPort == nil then strIpPort = '127.0.0.1:8080' end
	--return string.gsub(strHtmlMod, 'http://%d+.%d+.%d+.%d+:%d+','http://'..tostring(strIpPort))
	return string.gsub(strHtmlMod, 'globalUrl="http://%d+.%d+.%d+.%d+:%d+"','globalUrl="http://'..tostring(strIpPort)..'"')
end

function CreateDiscript(tbRes,detailFlg,strHtmlDetail)
	strTmpContent = ""
	for i=1,#tbRes do 
		--strTmpRequest = tostring(tbRes[i]['requestcontent'])
		strTmpContent = tostring(tbRes[i][detailFlg])
		--ngx.say(strTmpContent)
	end

	if strTmpContent ~= nil and strTmpContent~= '' then 
		
		strTmpContent = getValue(decodeURI(strTmpContent))
		if #strTmpContent > 1 and detailFlg == "responsecontent" then
			strTmpContent = modfyHtml(strTmpContent,'&nbsp&nbsp','&ltbr&gt')
		else
			for i,j in pairs(tbRevers) do
				strTmpContent = string.gsub(strTmpContent,modifyMegicChar('&lt'..j..'&gt'),'<'..j..'>')
			end
		end
	end

	strHtmlTemp = string.gsub(strHtmlDetail,'<lbsModifyItem%*%*%*Detail%*%*%*lbsModifyItem>',modifyMegicChar(strTmpContent))
	if strIpPort == nil then strIpPort = '127.0.0.1:8080' end
	return string.gsub(strHtmlTemp, 'globalUrl=http://%d+.%d+.%d+.%d+:%d+','globalUrl=http://'..tostring(strIpPort)) or strHtmlTemp

end

function modifyYear(str)
	temp = string.gsub(str,'[-/]','')
	local year = tonumber(string.sub(temp,1,4))
	local month = tonumber(string.sub(temp,5,6))
	local day = tonumber(string.sub(temp,7,8))
	
	local oldYear = tonumber(year)
	local oldMontth = tonumber(month)
	local oldDay = tonumber(day)
	
	if day == nil then 
		if month == 12 then 
			month = 1
			year = year + 1
			day = 1
			oldDay = 1
		else
			oldDay = 1
			day = 1
			month = oldMontth + 1
		end
		return oldYear..'-'..oldMontth..'-'..oldDay,year..'-'..month..'-'..day
	end
	
	tb = {
		['01'] = 'afasdfasdf'
	}
	local tbMonMax = {
		[1] = 31,
		[3] = 31,
		[5] = 31,
		[7] = 31,
		[8] = 31,
		[10] = 31,
		[12] = 31,	
		[4] = 30,	
		[6] = 30,	
		[9] = 30,	
		[10] = 30,	
		[11] = 30,
	}
	
	if tonumber(month) == 2 then 	
		if tonumber(year) % 4 ==0  and tonumber(year) % 100 ~= 0 then 
			tbMonMax[2] = 29
		else
			tbMonMax[2] = 28
		end
	end
	
	print('max',tbMonMax[tonumber(month)])
	
	if tonumber(day) + 1 > tbMonMax[tonumber(month)] then 
		if tostring(month) == '12' then
			month = 1
			day = 1
			year = tonumber(year) + 1
		else
			month = month + 1
			day = 1
		end
	else
		day = day + 1
	end	
	
	return oldYear..'-'..oldMontth..'-'..oldDay,year..'-'..month..'-'..day
end

function getIdList(tbDbSql,strDown,strTop)
	local redis = require "resty.redis"
	local cjson = require "cjson"
	local red = redis:new()

	red:set_timeout(1000) -- 1 sec

	-- or connect to a unix domain socket file listened
	-- by a redis server:
	--     local ok, err = red:connect("unix:/path/to/redis.sock")

	local ok, err = red:connect("127.0.0.1", 6379)
	if not ok then
	    ngx.say("failed to connect: ", err)
	    return
	end

	local tb = {}
	local res, err = red:get("sqldata")
	if not res then
	    ngx.say("failed to get sqldata: ", err)
		return
	end
	local sqldata = "["..string.sub(res,2,-1).."]"
	local tb = {}

	tb = cjson.decode(sqldata)
	local i = #tb
	local strIdlist = ""
	--ngx.say("i ? ", i)
	local count = 0
	local begin = tonumber(strDown)
	local stop = tonumber(strTop)
	while (i >= 1) do
		local flg = true 
		for key,value in pairs(tbDbSql) do
			if tostring(tb[i].key) ~= value then 
				flg = false
				break
			end
		end
		if flg then 
			count = count + 1
			if i > begin and i <= begin+stop then 
				strIdlist = strIdlist..tb[i].id..","
			end
		end
		i = i - 1
	end

	ngx.say("count ? ",count)

	-- put it into the connection pool of size 100,
	-- with 10 seconds max idle time
	local ok, err = red:set_keepalive(10000, 100)
	if not ok then
	    ngx.say("failed to set keepalive: ", err)
	    return
	end
end

-- get id down and top
function getTopDownPage(tbDbData,strSize)
	if tbDbData.numPage then 
		--tbDbData.numPage = tonumber(tbDbData.numPage)
		if tostring(tbDbData.strRequest) == 'DownPage' then 
			strTop = 20
			strDown = tonumber(tbDbData.numPage) * 20
			numPage = tbDbData.numPage + 1
		elseif tostring(tbDbData.strRequest) == "UpPage" then 
			if tonumber(tbDbData.numPage) == 1 then 
				strTop = 20
				strDown = 0
				numPage = 1
			else
				strTop = 20
				strDown = tonumber(tbDbData.numPage -2) * 20
				numPage = tbDbData.numPage - 1
			end
		elseif tostring(tbDbData.strRequest) == "FirstPage" then 
			strDown = 0
			strTop = 20
		elseif tostring(tbDbData.strRequest) == "LastPage" then 
			if tonumber(strSize) % 20 == 0 then 
				strDown = tonumber(strSize) - 20
				strTop = 20		
			else	
				strDown = tonumber(strSize) - tonumber(strSize) % 20
				strTop = tonumber(strSize) % 20
			end
		else
		end
		return strDown,strTop
	else
		ngx.say("bad result: ","CurrentPage is null")
		return
	end
end