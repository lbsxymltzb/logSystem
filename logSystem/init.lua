strIpPort = '192.168.157.131:8080'
g_host = "192.168.1.70"
g_port = '3306'
g_database = "lbs1"
g_user = "root"
g_password = "123456"
g_charset = "utf8"
g_max_packet_size = 1024 * 1024
g_tableName = "viewloginfo"
g_selectMaxBuf = '20000'

f = io.open("/home/lbs/html.txt","w")
f:write("hellow lbs ")
f:close()
