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

fd  = io.open("/home/lbs/sqldata.txt","w")
fd:write(sqldata)
fd:close()

local tb = {}

tb = cjson.decode(sqldata)
local i = #tb
ngx.say("i ? ", i)
local count = 0

while (i >= 1) do
	if tb[i].status==0 then
		count = count + 1
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

-- or just close the connection right away:
-- local ok, err = red:close()
-- if not ok then
--     ngx.say("failed to close: ", err)
--     return
-- end
