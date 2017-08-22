local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.dialup.connectmode."
local maps = {
	Auto="Auto",
	Manual="Manual",
}

function SetObjParamInputs(data, maps)
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

if nil ~= data and nil ~= data["ConnectMode"] then
	local param = SetObjParamInputs(data["ConnectMode"], maps)		
	local errcode, paramErrs = dm.SetObjToDB(objdomin,param)
	if 0 ~= errcode then 
		print("errcode:",errcode)
	end
end
