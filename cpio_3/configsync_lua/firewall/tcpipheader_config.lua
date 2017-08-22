
local utils = require('utils')
local objdomin = "InternetGatewayDevice.Services.X_TCPIPHEADER."
local maps = {
    umts="Umts",
	eth_ipoe="EthernetIpoe",
	wifi_ipoe="WiFiIpoe",
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
    print("set tcpipheader errcode = ",errcode)                           
end   

