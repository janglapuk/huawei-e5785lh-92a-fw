require('dm')
require('json')
require('utils')
require('sys')

--bridgemode module display switch data nodes "InternetGatewayDevice.Services.X_BridgeMode.DisplayEnable"
--------------------check the status of bridgemode module display switch--------------------
local errcode,SwitchValues= dm.GetParameterValues("InternetGatewayDevice.Services.X_BridgeMode.",
        {"DisplayEnable"})

if utils.toboolean(SwitchValues["InternetGatewayDevice.Services.X_BridgeMode."]["DisplayEnable"]) then
--print("bridgemode  module display switch is on")
else
--print("bridgemode  module display switch is off")
	local response = {}
	response.code = 100002
	response.message = ""
	sys.print(json.xmlencode(response,"error"))
	return	false
end

local errcode,val= dm.GetParameterValues("InternetGatewayDevice.Services.X_BridgeMode.", {"ModeStatus"})

local obj = {}

obj.bridgemode = utils.toboolean(val["InternetGatewayDevice.Services.X_BridgeMode."]["ModeStatus"])
-----cwmp
obj.cwmpshareinternet = 0
----voice	
obj.voiceshareinternet = 0

sys.print(json.xmlencode(obj))