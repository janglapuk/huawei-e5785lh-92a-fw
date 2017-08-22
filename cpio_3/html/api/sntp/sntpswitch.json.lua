require('dm')
require('json')
require('utils')
require('sys')

--sntp module Switch Data nodes  "InternetGatewayDevice.Time.X_TimeServerDisplay_Enabled"
--------------------check the status of sntp module switch--------------------
local errcode,SwitchValues= dm.GetParameterValues("InternetGatewayDevice.Time.",
        {"X_TimeServerDisplay_Enabled"})

if utils.toboolean(SwitchValues["InternetGatewayDevice.Time."]["X_TimeServerDisplay_Enabled"]) then
--print("sntp module Switch is on")
else
--print("sntp module Switch is off")
	local response = {}
	response.code = 100002
	response.message = ""
	sys.print(json.xmlencode(response,"error"))
	return	false
end

local errcode,val= dm.GetParameterValues("InternetGatewayDevice.Time.", {"Enable"})

local obj = {}

obj.SntpSwitch = val["InternetGatewayDevice.Time."]["Enable"]

sys.print(json.xmlencode(obj))






















