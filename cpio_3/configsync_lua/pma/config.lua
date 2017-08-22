local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.pma."
local maps = {
    enabled="enabled",
    sslmode = "sslmode",
    testmode = "testmode",	
    update_interval = "update_interval",
    pmaversion = "pmaversion",
    sleepvalue = "sleepvalue",
    retrytime = "retrytime",
    pds1 = "pds1",
	pds2 = "pds2",
    validnumber = "validnumber",
    validnumber2 = "validnumber2",
    validnet1 = "validnet1",
	validnet2 = "validnet2",
	validnet3 = "validnet3",
	
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
