local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.dialup.profile.3."
if nil ~= data and nil ~= data["profile"] then
    local profile_name
	local apn_flag
	local apn 
	local username 
	local password 
	local auth_mode
	
	profile_name = data["profile"]["profile_name"]
	apn = data["profile"]["apn"]
    if "" == data["profile"]["apn"]  then
	    apn_flag = 0
    else
		apn_flag = 1	
	end
	
	if "" == data["profile"]["dialup_num"]  then
		dialnum = "*99#"
	else		
		dialnum = data["profile"]["dialup_num"]
	end
	
	if "" == data["profile"]["username"]  then
		username = ""
	else		
		username = sys.decodeXMLPara(data["profile"]["username"])
	end
	if "" == data["profile"]["password"]  then
		password = ""
	else		
		password = sys.decodeXMLPara(data["profile"]["password"])
	end
	
	if "" == data["profile"]["auth_mode"]  then
		auth_mode = 2
	else
		auth_mode = data["profile"]["auth_mode"]
	end

	local newObj = {
		{"index", 1}, 
		{"service", 3}, 		
		{"profile_name", profile_name},	
		{"apn_is_static", apn_flag}, 
		{"apn", apn},	
		{"dialup_num", dialnum}, 
		{"username", username},	
		{"password", password}, 
		{"auth_mode", auth_mode},
		{"ip_is_static", 0},
		{"ip_address", ""},
		{"ipv6_address", ""},
		{"dns_is_static", 0},
		{"primary_dns", ""},                          
		{"secondary_dns", ""},
		{"primary_ipv6_dns", ""},
		{"secondary_ipv6_dns", ""},
		{"read_only", 0},
		{"ip_type", 0},
	}	
	local errcode, paramErrs= dm.SetObjToDB(objdomin, newObj)
	if errcode ~= 0 then
	   print("voice set errcode = ", errcode)
	end

end
