local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.dialup.profile.2."

function SetObjParamInputs(domain, data, maps)
    local inputs = {}
    for k, v in pairs(maps) do
        local param = {}
		if nil ~= data and nil ~= data[k] then
			param["key"] = v    
			if v == "dialup_num" and "" == data[k] then
				data[k] = "*99#"
			end
			if v == "auth_mode" and "" == data[k] then
				data[k] = 2
			end
			if v == "username" or v == "password" then
				param["value"] = sys.decodeXMLPara(data[k])
			else
				param["value"] = data[k]
			end
			table.insert(inputs, param)
		end
    end
    return inputs
end

if nil ~= data and nil ~= data["profile"] then
	local maps1 = {
		{"index", 1}, 
		{"service", 2},
		{"ip_is_static", 0},
		{"ip_address", ""},
		{"ipv6_address", ""},
		{"dns_is_static", 0},
		{"primary_dns", ""},                          
		{"secondary_dns", ""},
		{"primary_ipv6_dns", ""},
		{"secondary_ipv6_dns", ""},
		{"read_only", 0}
	}
	local errcode1, paramErrs = dm.SetObjToDB(objdomin, maps1)
	if errcode1 ~= 0 then
	   print("cwmp set errcode1 = ", errcode1)
	end
	
	local maps2 = {
		profile_name = "profile_name" ,	
		apn = "apn", 
		dialup_num = "dialup_num", 
		username = "username", 	
		password = "password",
		auth_mode = "auth_mode",
		ip_type = "ip_type"
	}
	
	local switchpara = SetObjParamInputs(objdomin,data["profile"], maps2)	
	local errcode2, paramErrs= dm.SetObjToDB(objdomin, switchpara)
	if errcode2 ~= 0 then
	   print("cwmp set errcode2 = ", errcode2)
	end
end
