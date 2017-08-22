require('dm')
require('json')
require('utils')
require('sys')

--sntp Manual set time Switch Data nodes  "InternetGatewayDevice.Time.X_TimeManualSetEnable"
--------------------check the status of sntp module switch--------------------
local errcode,SwitchValues= dm.GetParameterValues("InternetGatewayDevice.Time.",
        {"X_TimeManualSetEnable"})

if utils.toboolean(SwitchValues["InternetGatewayDevice.Time."]["X_TimeManualSetEnable"]) then
--print("sntp Manual set time Switch is on")
else
--print("sntp Manual set time Switch is off")
	local response = {}
	response.code = 100002
	response.message = ""
	sys.print(json.xmlencode(response,"error"))
	return	false
end

local errcode,val= dm.GetParameterValues("InternetGatewayDevice.Time.", {"X_TimeManualSetEnable"})

local obj = {}

obj.timesetswitch = val["InternetGatewayDevice.Time."]["X_TimeManualSetEnable"]

sys.print(json.xmlencode(obj))






















