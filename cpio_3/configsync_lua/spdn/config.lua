local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.spdn."
local maps = {
    enable="enable",
    testmode = "testmode",
    server_sbm1 = "server_sbm1",
    server_sbm2 = "server_sbm2",
    server_sbm3 = "server_sbm3",
    server_sbm4 = "server_sbm4",	
    spdnaddr = "spdnaddr",
	
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
    print("set update errcode = ",errcode)                           
end   
return errcode, paramErrs
