local web       = require("web")
local json      = require("json")
local utils     = require('utils')

--volte Manual set time Switch Data nodes  "InternetGatewayDevice.Services.VoiceService.1.X_VolteDisplay"
--------------------check the status of volte module switch--------------------
local errcode,SwitchValues= dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.",
        {"X_VolteDisplay"})

if utils.toboolean(SwitchValues["InternetGatewayDevice.Services.VoiceService.1."]["X_VolteDisplay"]) then
--print("volte ManualSetDisplay Switch is on")
else
--print("volte ManualSetDisplay Switch is off")
	local response = {}
	response.code = 100002
	response.message = ""
	sys.print(json.xmlencode(response,"error"))
	return	false
end

local errcode,values= dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.", {"X_VolteEnable"})
obj = values["InternetGatewayDevice.Services.VoiceService.1."]

local response = {}
response.volte_enable = obj["X_VolteEnable"]
sys.print(json.xmlencode(response))