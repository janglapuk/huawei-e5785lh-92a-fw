local utils = require('utils')
local response = {}

-----------------check upnp display enable----------------------------
local domain = "InternetGatewayDevice.X_Config.upnp."
local errcode,upnp_display = dm.GetParameterValues(domain , {"upnp_portmapping_display"});
if nil~= upnp_display and nil ~= upnp_display[domain] and utils.toboolean(upnp_display[domain]["upnp_portmapping_display"]) then
    --print("upnp display enable")
else
    --print("upnp display disable")
	response.code = 100002
	response.message = ""
	sys.print(json.xmlencode(response,"error"))
	return	false
end

response.upnpportmappings = {}
local domain = "InternetGatewayDevice.Services.X_UPnP."
local errcode,upnp = dm.GetParameterValues(domain , {"Enable"});
local upnpconf = upnp[domain]

if true == utils.toboolean(upnpconf["Enable"]) then
	local pmlist = web.GetPortMappingList()
	if pmlist ~= nil then
	    for i=0, #pmlist do
	        table.insert(response.upnpportmappings, pmlist[i])
	    end
	end
end

sys.print(json.xmlencode(response))
