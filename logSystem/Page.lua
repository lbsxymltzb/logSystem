local mysql = require "resty.mysql"
local md = require "HtmlModule"
local mdFaileHtml = require "HtmlModuleConnSqlFailed"
local htmlFailed  = mdFaileHtml.data
require "publicFunction"
local cjson = require "cjson"
local strHtmlMoudle = md.data
local db, err = mysql:new()
if not db then
	ngx.say("failed to instantiate mysql: ", err)
	return
end

db:set_timeout(10000) -- 1 sec

-- or connect to a unix domain socket file listened
-- by a mysql server:
--     local ok, err, errcode, sqlstate =
--           db:connect{
--              path = "/path/to/mysql.sock",
--              database = "ngx_test",
--              user = "ngx_test",
--              password = "ngx_test" }

local ok, err, errcode, sqlstate = db:connect{
	host = g_host,
	port = g_port,
	database = g_database,
	user = g_user,
	password = g_password,
	charset = g_charset,
	max_packet_size = g_max_packet_size,
}

--debug
if not ok then
	--ngx.say("failed to connect: ", err, ": ", errcode, " ", sqlstate)
	ngx.say(htmlFailed)
	return
end

-- run a select query, expected about 10 rows in
-- the result set:
--res, err, errcode, sqlstate =
--	db:query("select * from cats order by id asc", 10)

--Phare data
--http://192.168.157.131:8080/LuaName?RequestType=Search&AccNo=123&OperationType=GetHis&State=Sucess
tbDbData = {
	strOptType = ngx.var.arg_SelectType,
	numPage = ngx.var.arg_CurrentPage,
	strHisId = ngx.var.arg_HisId,
	strState = ngx.var.arg_SelectState,
	strRequest = ngx.var.arg_RequestType,
	strTime = ngx.var.arg_STime,
	strMaxPage = ngx.var.arg_MaxPage
}

if tbDbData.strState then
	local temp = tostring(tbDbData.strState)
	tbDbData.strState = temp == 'Sucess' and '0' or temp == 'Failed' and '1'
end
if tbDbData.strOptType then 
	local temp = tostring(tbDbData.strOptType)
	tbDbData.strOptType = temp == 'GetHis' and '预约登记' or temp == 'JiaoHao' and '叫号' 
		or temp =='State' and '状态' or temp == 'Report' and '报告' or temp =='HealthyExem' and '体检'
end

tbDbSql = {
	type = tbDbData.strOptType,
	hisid = tbDbData.strHisId,
	status = tbDbData.strState,
	time = tbDbData.strTime,
}

for i,j in pairs(tbDbSql) do
	if string.match(tostring(j),"[Ff][Aa][Ll][Ss][Ee]") then 
		tbDbSql[i] = nil
	elseif j == "" then 
		tbDbSql[i] = nil
	end
end

-- if get hisid then execute get info from mysql
if tbDbSql.hisid then 
	local tempTime = tbDbSql.time
	local strSerchTime
	local strDownTime,strUpTime
	if tempTime then
		strDownTime,strUpTime = modifyYear(tempTime)
		strSerchTime = 'time between '.."'"..tostring(strDownTime).."'"..' and '.."'"..tostring(strUpTime).."'"
	end	

	local strSql = ""
	for i,j in pairs(tbDbSql) do
		if i ~= "time" then
			strSql = strSql..i.."='"..j.."' and "
		end
	end

	strSqlTmp = string.sub(strSql,1,-5)
	--ngx.say('strSql not nil? ',strSqlTmp)
	if strSerchTime then 
		strSql = "select id from "..g_tableName.." where "..strSqlTmp.." and "..strSerchTime.." ORDER BY id DESC".." limit 0,".."500"
	else
		strSql = "select id from "..g_tableName.." where "..strSqlTmp.." ORDER BY id DESC".." limit 0,".."500"
	end
	--ngx.say("strSql id : ",strSql)

	local dbres, dberr, dberrcode, sqlstate =
		db:query(strSql)
	if not dbres then
		ngx.say("bad result: ", dberr, ": ", dberrcode, ": ", sqlstate, ".")
		ngx.say("sql: ",strSql)
		return
	end
	strSize = #dbres >= 2000 and 2000 or #dbres
	local strDown,strTop = getTopDownPage(tbDbData,strSize)
	if strSize == 0 then 
		local strItem = CreateItem(dbres,strHtmlMoudle,20,numPage)
		local tb = {xmlItem = strItem, size = strSize}
		ngx.say(cjson.encode(tb))	
	else
		local strIdlist = ""
		for i,j in pairs(dbres) do
			strIdlist = strIdlist..dbres[i].id..","
		end

		strIdlist = string.sub(strIdlist,0,-2) 
		strSql = "select id,patientName,checkNo,hisid,status,time,type from "..g_tableName.." where id in ("..strIdlist..")".." order by id desc limit "..tostring(strDown)..","..tostring(strTop)
		--ngx.say("strSql : ",strSql)

		dbres, dberr, dberrcode, sqlstate =
			db:query(strSql)
		if not dbres then
			ngx.say("bad result: ", dberr, ": ", dberrcode, ": ", sqlstate, ".")
			ngx.say("sql: ",strSql)
			return
		end
		local strItem = CreateItem(dbres,strHtmlMoudle,20,numPage)
		local tb = {xmlItem = strItem, size = strSize}
		ngx.say(cjson.encode(tb))	

		local ok, err = db:set_keepalive(10000, 100)
		if not ok then
			ngx.say("failed to set keepalive: ", err)
			return
		end
	end
	return 
end

--获取结果id列表
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

if tbDbSql.time then 
	tbDbSql.time = modifyYear(tbDbSql.time)
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
local count = 0
local tbMatch = {}
while (i >= 1) do
	local flg = true 
	for key,value in pairs(tbDbSql) do
		if tostring(tb[i][key]) ~= value then 
			flg = false
			break
		end
	end
	if flg then 
		count = count + 1
		tbMatch[count] = tb[i].id
	end
	i = i - 1
end
strSize = count>2000 and 2000 or count
--ngx.say("count ? ",count)
-- get id down and top
local strDown,strTop = getTopDownPage(tbDbData,strSize)

-- not get id then return
if not next(tbMatch) then 
	local strItem = CreateItem(tbMatch,strHtmlMoudle,20,numPage)
	local tb = {xmlItem = strItem, size = strSize}
	ngx.say(cjson.encode(tb))	
else
	-- get id list
	down = tonumber(strDown) + 1
	top = tonumber(strDown) + tonumber(strTop)
	top = top >= #tbMatch and #tbMatch or top
	--gx.say("down ? ",down, " top ? ",top)
	for i=down,top do
		strIdlist = strIdlist..tbMatch[i]..","
	end
	strIdlist = string.sub(strIdlist,0,-2)
	--ngx.say("id size : ",#tbMatch)
	local strResSql = "select id,patientName,checkNo,hisid,status,time,type from "..g_tableName.." where id in ("..strIdlist..")".." order by id desc"
	--ngx.say("strResSql : ",strResSql)
	dbres, dberr, dberrcode, sqlstate =
		db:query(strResSql)
	if not dbres then
		ngx.say("bad result: ", dberr, ": ", dberrcode, ": ", sqlstate, ".")
		ngx.say("sql: ",strResSql)
		return
	end
	local strItem = CreateItem(dbres,strHtmlMoudle,20,numPage)
	local tb = {xmlItem = strItem, size = strSize}
	ngx.say(cjson.encode(tb))
end

-- put it into the connection pool of size 100,
-- with 10 seconds max idle time
local ok, err = red:set_keepalive(10000, 100)
if not ok then
    ngx.say("failed to set keepalive: ", err)
    return
end

-- -- put it into the connection pool of size 100,
-- -- with 10 seconds max idle timeout
local ok, err = db:set_keepalive(10000, 100)
if not ok then
	ngx.say("failed to set keepalive: ", err)
	return
end

-- or just close the connection right away:
-- local ok, err = db:close()
-- if not ok then
--     ngx.say("failed to close: ", err)
--     return
-- end
