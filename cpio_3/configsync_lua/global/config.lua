local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.global."
local maps = {
    homepage="homepage",
    default_language = "default_language",
    lteca_display = "lteca_display",
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
        print("set  global errcode = ",errcode)                           
end  

if nil ~= data["homedeviceinfo"] then
param = {
            {"boottimeenable",data["homedeviceinfo"]["boottime"]}
        }
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)
    if 0 ~= errcode then
        print("set homedeviceinfo errcode = ",errcode)
    end
end  
return errcode, paramErrs
