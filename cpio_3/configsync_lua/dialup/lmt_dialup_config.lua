local utils = require('utils')

local dialupdomin = "InternetGatewayDevice.X_Config.X_lmt_dialup."
local umtsWandomin = ""

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

function parse_data_to_dialup(objdomin, data)
	local maps = {
		profile_connected_readonly_enable = "profile_connected_readonly_enable",
	}

	if nil ~= data then
		local param = SetObjParamInputs(data, maps)
		local errcode, paramErrs = dm.SetObjToDB(objdomin, param)
		if (0 ~= errcode) then
			print("errcode = "..errcode)
		end
	end
end


parse_data_to_dialup(dialupdomin, data)
