local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.firewall."
local maps = {
    whitelist_display="WhiteListDisplay",
	ipv6_enable="Ipv6Enable",
	url_whitelist_display="UrlWhiteListDisplay",
}

function SetObjParamInputs(domain, data, maps)
    local inputs = {}
    for	k, v in	pairs(maps) do
	local param = {}
		if nil ~= data and nil ~= data[k] then
			param["key"] = v
			param["value"] = data[k]
			table.insert(inputs, param)
		end
    end
    return inputs
end

local param = SetObjParamInputs(objdomin, data,	maps)
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)
if 0 ~= errcode then                                                    
    print("set firewall featureswitch errcode = ",errcode)                           
end   