local mysql = require "resty.mysql"
local cjson = require "cjson"
local redis = require "resty.redis"
local md = require "HtmlModuleConnSqlFailed"
local htmlFailed = md.data
-- new redis
local red = redis:new()
require "publicFunction"
md = require "HtmlModule"
local strHtmlMod = md.data

-- get red count(id)
local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.say("failed to connect 127.0.0.1 : ", err)
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

local strSize = #tb
strSize = strSize or "1/100"
strSize = tonumber(strSize) >= 2000 and 2000 or strSize
--local numRemainder = tonumber(strSize) % 20
local numSize = math.ceil(tonumber(strSize) / 20)
if numSize == 0 then numSize = 1 end

strHtmlMod = string.gsub(strHtmlMod,'<lbsModifyItem%*%*%*'..'strMaxPage'..'%*%*%*lbsModifyItem>','1/'..tostring(numSize))
strHtmlMod = string.gsub(strHtmlMod,'<lbsModifyItem%*%*%*'..'numMaxPage'..'%*%*%*lbsModifyItem>',tostring(strSize))

--id list
local i = 0
local strId = ""
while (i<=19) do 
	strId = strId..tb[#tb-i].id..","
	i = i + 1
end
strId = string.sub(strId,0,-2)
local strSqlFindId = "select id,patientName,checkNo,hisid,type,status,time from "..g_tableName.." where id in ("..strId..")".." order by id desc"

--ngx.say(strSqlFindId)

-- select info from mysql where id in idlist
local db, dberr = mysql:new()
if not db then
	--ngx.say("failed to instantiate mysql: ", err)
	ngx.say(htmlFailed)
	return
end
db:set_timeout(100000) -- 1 sec
local dbok, dberr, dberrcode, sqlstate = db:connect{
	host = g_host,
	port = g_port,
	database = g_database,
	user = g_user,
	password = g_password,
	charset = g_charset,
	max_packet_size = g_max_packet_size,
}
if not dbok then
	--ngx.say("failed to connect: ", dberr, ": ", dberrcode, " ", sqlstate)
	ngx.say(htmlFailed)
	return
end
-- run a select query, expected about 10 rows in
-- the result set:
dbres, dberr, dberrcode, dbsqlstate =
	db:query(strSqlFindId)
if not dbres then
	ngx.say("bad result: ", dberr, ": ", dberrcode, ": ", sqlstate, ".")
	ngx.say("sql: ",strSqlFindId)
	return
end

local strHtml = CreateHtml(dbres,strHtmlMod,20,1)

ngx.say(strHtml)

-- -- put it into the connection pool of size 100,
-- -- with 10 seconds max idle timeout
local ok, err = db:set_keepalive(10000, 100)
if not ok then
	ngx.say("failed to set keepalive: ", err)
	return
end
-- put it into the connection pool of size 100,
-- with 10 seconds max idle time
local ok, err = red:set_keepalive(10000, 100)
if not ok then
    ngx.say("failed to set keepalive: ", err)
    return
end
