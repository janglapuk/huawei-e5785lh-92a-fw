require('dm')
require('json')
require('utils')
require('sys')

local errcode,pppCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}.", 
    {"X_NATType", "X_AutoFlag"});

local resp = {}
for k,v in pairs(pppCon) do
	if utils.toboolean(v["X_AutoFlag"]) then
		if v["X_NATType"] == "cone nat" then
			resp.NATType = 1
		else
			resp.NATType = 0
		end
		break
	end
end

sys.print(json.xmlencode(resp))