local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.bluetooth." 
local maps = {
    enable="enable",
	btswitch="btswitch",
	wakeup_enable="wakeup_enable",
    bt_feature_basic = "bt_feature_basic",
    bt_feature_wakeup = "bt_feature_wakeup",
    bttype = "bttype",
}


function SetObjParamInputs(domain, data, maps)
    local inputs = {}
	print("set bluetooth errcode = ")  
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
        print("set bluetooth errcode = ",errcode)                           
end 
print("set bluetooth errcode") 
return errcode, paramErrs
