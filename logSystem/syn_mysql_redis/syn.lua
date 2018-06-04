local redis = require "resty.redis"
local cjson = require "cjson"
local mysql = require "resty.mysql"
local syn = require "synPublicFunc"
local red,db
local g_cfg_maxsize = 6

--connect to redis
red = redis:new()
red:set_timeout(1000) -- 1 sec
local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.say("failed to connect redis : ", err)
    return
end

--connect to mysql
db, err = mysql:new()
if not db then
	ngx.say("failed to instantiate mysql: ", err)
	return
end
db:set_timeout(10000) -- 1 sec
local errcode, sqlstate
ok, err, errcode, sqlstate = db:connect{
	host = g_host,
	port = g_port,
	database = g_database,
	user = g_user,
	password = g_password,
	charset = g_charset,
	max_packet_size = g_max_packet_size,
}
if not ok then
	ngx.say("failed to connect mysql : ", err, ": ", errcode, " ", sqlstate)
	return
end

--some variable
local time, time_cfg, red_maxid, sql_maxid
local tb_cfg = {} --timecfg struct
local tb_sql_res = {} --select (targ column) where id > red_maxid

--get system time
time = os.date("%Y-%m-%d")
--debug
ngx.say("time : ",time)
--debug

--exists time cfg
ok, err = red:exists(time..".cfg")
if tonumber(ok) == 0 then 
	local tb_timecfg = {name = "1", res_size = g_cfg_maxsize}
	local str_timecfg = cjson.encode(tb_timecfg)
	ok, err = red:set(time..".cfg",str_timecfg)
	if not ok then
    	ngx.say("failed to init  "..time..".cfg".." : ", err)
		return
	end
end

--get current time cfg struct
time_cfg, err = red:get(time..".cfg")
if not time_cfg then
    ngx.say("failed to get "..time..".cfg".." : ", err)
	return
end
tb_cfg = cjson.decode(time_cfg)
tb_cfg.name = tonumber(tb_cfg.name)
tb_cfg.res_size = tonumber(tb_cfg.res_size)
--debug
ngx.say("get current time.cfg name : ",tb_cfg.name)
ngx.say("get current time.cfg res_size : ",tb_cfg.res_size)
--debug

--get redis maxid
red_maxid, err = red:get("maxid")
if not red_maxid then
    ngx.say("failed to get redis maxid : ", err)
	return
end
red_maxid = tonumber(red_maxid)
--debug
ngx.say("get redis maxid : ",red_maxid)
--debug

--get mysql maxid
local str_maxid_sql = "select max(id) as maxid from "..g_tableName
res, err, errcode, sqlstate =
	db:query(str_maxid_sql)
if not res then
	ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
	ngx.say("sql: ",str_maxid_sql)
	return
end
sql_maxid = tonumber(res[1].maxid)
--debug
ngx.say("get mysql maxid : ",sql_maxid)
--debug

--if sql_maxid == red_maxid then return ,if sql_maxid < red_maxid then set red_maxid = sql_maxid
if sql_maxid == red_maxid then 
	ngx.say("sql_maxid == red_maxid not update !")
	return
elseif sql_maxid < red_maxid then 
	ngx.say("sql_maxid < red_maxid set red_maxid = sql_maxid")
	ok, err = red:set("maxid",sql_maxid)
	if not ok then
	    ngx.say("failed to set redis maxid : ", err)
		return
	end	 
end

--get tb_sql_res all data that id > red_maxid
local str_sql_cmd = "select id,patientName,checkno,hisid,status,time,type from "..g_tableName.." where id > "..red_maxid.." order by id desc"
res, err, errcode, sqlstate =
	db:query(str_sql_cmd)
if not res then
	ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
	ngx.say("sql: ",str_sql_cmd)
	return
end
tb_sql_res = res
--debug
ngx.say("get sql_res count : ",#tb_sql_res)
--debug

--input sql_res to reis
local insert_count = #tb_sql_res
local red_begin,red_end
local tb_temp = {}
while (insert_count > 0) do
	--ngx.say("======")
	--ngx.say("operate page : ",tb_cfg.name)
	if tb_cfg.res_size == 0 then
		--ngx.say("page : ",tb_cfg.name," full")
		tb_cfg.name = tb_cfg.name + 1	--cfg record next number
		tb_cfg.res_size = g_cfg_maxsize --init next number residue
		flg = insert_count - tb_cfg.res_size
		if flg <= 0 then --this number can save all count
			tb_temp = syn.get_subtb(tb_sql_res, insert_count) --get table from sql_res 
			tb_cfg.res_size = tb_cfg.res_size - insert_count  --residue is full so size is 0
			insert_count = 0
			--ngx.say("page : ",tb_cfg.name," < max save count : ",insert_count," next : ", 0, " data : ",cjson.encode(tb_temp))
			--ngx.say("save all")	
			--save date
			if not syn.append_data(red, time.."."..tb_cfg.name, tb_temp) then 
				return
			else
				--chage maxid now maxid is maxid(befor) + count(update)
				red_maxid = red_maxid + #tb_temp
				if not syn.set_strdata(red, "maxid", red_maxid) then 
					return 
				end
			end
			break
		else
			tb_temp = syn.get_subtb(tb_sql_res, tb_cfg.res_size)
			insert_count = insert_count - tb_cfg.res_size			
			--ngx.say("page : ",tb_cfg.name," > max save count : ",tb_cfg.res_size," next : ", insert_count," data : ",cjson.encode(tb_temp))			
			tb_cfg.res_size = 0	
			if not syn.append_data(red, time.."."..tb_cfg.name, tb_temp) then 
				return
			else
				red_maxid = red_maxid + #tb_temp
				if not syn.set_strdata(red, "maxid", red_maxid) then 
					return 
				end
			end
		end
	else
		flg = insert_count - tb_cfg.res_size
		if flg <= 0 then 
			tb_temp = syn.get_subtb(tb_sql_res, insert_count)
			tb_cfg.res_size = tb_cfg.res_size - insert_count
			insert_count = 0
			--ngx.say("page : ",tb_cfg.name," < maxsave count : ",insert_count," next : ", 0," data : ",cjson.encode(tb_temp))
			--ngx.say("save all")	
			if not syn.append_data(red, time.."."..tb_cfg.name, tb_temp) then 
				return
			else
				red_maxid = red_maxid + #tb_temp
				if not syn.set_strdata(red, "maxid", red_maxid) then 
					return 
				end			
			end		
			break
		else
			tb_temp = syn.get_subtb(tb_sql_res, tb_cfg.res_size)
			insert_count = insert_count - tb_cfg.res_size
			--ngx.say("page : ",tb_cfg.name," > max save count : ",g_cfg_maxsize," next : ", insert_count," data : ",cjson.encode(tb_temp))			
		    tb_cfg.res_size = 0	
			if not syn.append_data(red, time.."."..tb_cfg.name, tb_temp) then 
				return
			else
				if not syn.set_strdata(red, "maxid", red_maxid) then 
					return 
				end
				red_maxid = red_maxid + #tb_temp
			end 
		end
	end
end	
--after save
if not syn.set_tbdata(red, time..".cfg", tb_cfg) then 
	return 
end
--debug
--ngx.say("after insert tb_cfg ? ",cjson.encode(tb_cfg))
--ngx.say("red_maxid : ",red_maxid)
--debug


-- put it into the connection pool of size 100,
-- with 10 seconds max idle timeout
local ok, err = red:set_keepalive(10000, 100)
if not ok then
    ngx.say("failed to set keepalive: ", err)
    return
end
-- put it into the connection pool of size 100,
-- with 10 seconds max idle timeout
local ok, err = db:set_keepalive(10000, 100)
if not ok then
	ngx.say("failed to set keepalive: ", err)
	return
end
