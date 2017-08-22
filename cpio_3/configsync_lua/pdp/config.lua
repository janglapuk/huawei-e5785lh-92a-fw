local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.pdp."
local maps = {
    dial_channel1_roam_connect = "dial_channel1_roam_connect",
    dial_channel2_roam_connect = "dial_channel2_roam_connect",
    dial_channel3_roam_connect = "dial_channel3_roam_connect",	
}

function SetObjParamInputs(domain, data, maps)
    local inputs = {}
    for k, v in pairs(maps) do
        local param = {}
		if nil ~= data and nil ~= data[k] then
			param["key"] = v      
			param["value"] = data[k]
			table.insert(inputs, param)
		end
    end
    return inputs
end
	
local param = SetObjParamInputs(objdomin, data, maps)
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)
if 0 ~= errcode then                                                    
        print("set  pdp errcode = ",errcode)                           
end  
return errcode, paramErrs


