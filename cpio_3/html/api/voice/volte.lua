local web       = require("web")
local json      = require("json")
local utils     = require('utils')

if nil == data or nil == data.volte_enable then
    return
end

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

local enable = data.volte_enable

if '0' == enable or '1' == enable then
	local setValues = 
	{
	    {"InternetGatewayDevice.Services.VoiceService.1.X_VolteEnable", enable}
	}
	errval,needreboot, paramerror = dm.SetParameterValues(setValues)
    utils.xmlappenderror(errval)
else
    utils.xmlappenderror("100005")
end
