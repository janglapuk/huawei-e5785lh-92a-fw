require('utils')

local objdomin = "InternetGatewayDevice.ManagementServer."
local maps = {
    supportedconnreqmethods = "SupportedConnReqMethods",
    connreqxmppconnection = "ConnReqXMPPConnection",
    connreqallowedjabberids = "ConnReqAllowedJabberIDs",
    connreqjabberid = "ConnReqJabberID",
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
if errcode ~= 0 then
   print("cwmp set errcode = ", errcode)
end

