local utils = require('utils')
local objdomin = "InternetGatewayDevice.Time."

function SetObjParamInputs(domain, data, maps)
    local inputs = {}
    for	k, v in	pairs(maps) do
	local param = {}
		if nil ~= data and nil ~= data[k] then
			param["key"] = v      
			param["value"] = data[k]
			table.insert(inputs, param)
		end
    end
    return inputs
end

if nil ~= data["time_policy"] then

    local maps = {
	                sync_prior0 = "X_TimeSyncPrior0",
					sync_prior1 = "X_TimeSyncPrior1",
					sync_prior2 = "X_TimeSyncPrior2",
					sync_prior3 = "X_TimeSyncPrior3"
                 }
			  
    local para = SetObjParamInputs(objdomin,data["time_policy"],maps)	
	local errcode, paramErrs = dm.SetObjToDB(objdomin,para)
	if 0 ~= errcode then  
	    print("sntp_policy_errcode = ", errcode)
	end
end

