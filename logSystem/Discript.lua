local mysql = require "resty.mysql"
local md = require "HtmlModuleDetail"
local strHtmlMoudle = md.data
local db, err = mysql:new()
if not db then
	ngx.say("failed to instantiate mysql: ", err)
	return
end

db:set_timeout(3000) -- 1 sec

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

if not ok then
	ngx.say("failed to connect: ", err, ": ", errcode, " ", sqlstate)
	return
end

-- run a select query, expected about 10 rows in
-- the result set:
--res, err, errcode, sqlstate =
--	db:query("select * from cats order by id asc", 10)

--Phare data
--http://192.168.157.131:8080/LuaName?RequestType=Search&AccNo=123&OperationType=GetHis&State=Sucess
tbDbData = {
	strOptType = ngx.var.arg_OperationType,
	numPage = ngx.var.arg_CurrentPage,
	strAccNo = ngx.var.arg_AccNo,
	strState = ngx.var.arg_State,
	strRequest = ngx.var.arg_RequestType,
	strTime = ngx.var.arg_OperationTime,
	strLogId = ngx.var.arg_LogId,
}

tbDbSql = {
	strOptType = 'type',
	strAccNo = 'checkNo',
	strState = 'status',
	strTime = 'time',
	strLogId = 'id',
}

local detailFlg =tbDbData.strRequest or "detailother"
detailFlg = detailFlg == "detailother" and "responsecontent" or detailFlg == "detailyz" and "remark"

if tbDbData.strState then 
	local temp = tostring(tbDbData.strState)
	tbDbData.strState = temp == 'Sucess' and '0' or temp == 'Failed' and '1'
end
if tbDbData.strOptType then 
	local temp = tostring(tbDbData.strOptType)
	ngx.say('temp?',temp)
	tbDbData.strOptType = temp == 'GetHis' and '预约登记' or temp == 'JiaoHao' and '叫号' 
		or temp =='State' and '状态' or temp == 'Report' and '报告' or temp =='HealthyExem' and '体检'
end

local strSql = ''
for i,j in pairs(tbDbSql) do
	if tbDbData[i] then 
		strSql = strSql..j.."='"..tostring(tbDbData[i]).."' and "
	end
end

if strSql == nil or strSql == '' then 
	strSql = 'select * from loginfo'
else
	strSql = string.sub(strSql,1,-5)
	strSql = 'select * from loginfo where '..strSql
end

res, err, errcode, sqlstate =
	db:query(strSql)
if not res then
	ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
	ngx.say("sql: ",strSql)
	return
end

local cjson = require "cjson"
require "publicFunction"

local strHtml = CreateDiscript(res,detailFlg,strHtmlMoudle)

ngx.say(strHtml)

--fd = io.open("/usr/local/openresty/nginx/luaCode/discript.html","w")
--fd:write(strHtml)
--fd:close()

--ngx.say('url?',ngx.var.url)

-- put it into the connection pool of size 100,
-- with 10 seconds max idle timeout
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
