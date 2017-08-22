local web       = require("web")
local response = {}
local last_login_state,last_login_ipaddr,last_login_time = web.getHistoryLoginInfo()
response.last_login_state = last_login_state
response.last_login_ipaddr = last_login_ipaddr
response.last_login_time = last_login_time
sys.print(json.xmlencode(response))