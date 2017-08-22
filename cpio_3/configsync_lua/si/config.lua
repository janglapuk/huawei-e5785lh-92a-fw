local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.si."
local maps = {
    enabled="enabled",
    firststart = "firststart",
    process = "process",
    usim = "usim",
    version = "version",
    sslmode = "sslmode",
    testmode = "testmode",	
    sleepvalue = "sleepvalue",
    retrytime = "retrytime",
    validnumber = "validnumber",
    validnumber2 = "validnumber2",
    switchapn = "switchapn",
    defaulturl = "defaulturl",
	
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
