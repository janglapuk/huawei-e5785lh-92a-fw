local ledobjdomin = "InternetGatewayDevice.X_Config.led."

local maps = {
    enable="enable",
    sleep_timeout = "sleep_timeout",
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
print("led enable:",data["enable"])
local param = SetObjParamInputs(ledobjdomin, data, maps)
local errcode, paramErrs = dm.SetObjToDB(ledobjdomin,param)
if 0~= errcode then
	print("led errcode:",errcode)
end
