local utils = require('utils')
local objdomin = "InternetGatewayDevice.Services.X_DmsService."
local maps = {
    enable="Enable",     
}

function SetObjParamInputs(domain, data, maps)
    local inputs = {}
    for k, v in pairs(maps) do
        local param = {}
        param["key"] = v      
        param["value"] = data[k]
        table.insert(inputs, param)
    end
    return inputs
end
local paras = {{"Enable", data["enable"]}}	
--local param = SetObjParamInputs(objdomin, data, maps)
local errcode, paramErrs = dm.SetObjToDB(objdomin,paras)
return errcode, paramErrs