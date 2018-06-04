local md = {}
cjson = require "cjson"
function md.get_subtb(srctb, num_count)
	local i = 1
	local tb_res = {}
	num_count = tonumber(num_count)
	while num_count > 0 do 
		table.insert(tb_res,srctb[#srctb])
		table.remove(srctb)
		num_count = num_count - 1
	end
	return tb_res
end

function md.append_data(red, redis_key, tbdata)
	local str_data = string.sub(cjson.encode(tbdata),2,-2)
	str_data = ","..str_data
	ok, err = red:append(redis_key,str_data)
	if not ok then
	    ngx.say("failed to save redis data : ", err)
		return false
	end
	return true
end

function md.set_strdata(red, redis_key, strdata)
	ok, err = red:set(redis_key,strdata)
	if not ok then
	    ngx.say("failed to set redis data : ", err)
		return false
	end
	return true
end

function md.set_tbdata(red, redis_key, tbdata)
	local str_data = cjson.encode(tbdata)
	ok, err = red:set(redis_key,str_data)
	if not ok then
	    ngx.say("failed to set redis data : ", err)
		return false
	end
	return true
end

return md