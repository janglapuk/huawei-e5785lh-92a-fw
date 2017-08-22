require('dm')
require('json')
require('utils')
require('sys')

--sntp Manual set time Switch Data nodes  "InternetGatewayDevice.Time.X_TimeManualSetDisplay_Enabled"
--------------------check the status of sntp module switch--------------------
local errcode,SwitchValues= dm.GetParameterValues("InternetGatewayDevice.Time.",
        {"X_TimeManualSetDisplay_Enabled"})

if utils.toboolean(SwitchValues["InternetGatewayDevice.Time."]["X_TimeManualSetDisplay_Enabled"]) then
--print("sntp TimeManualSetDisplay Switch is on")
else
--print("sntp TimeManualSetDisplay Switch is off")
	local response = {}
	response.code = 100002
	response.message = ""
	sys.print(json.xmlencode(response,"error"))
	return	false
end

local errcode,val= dm.GetParameterValues("InternetGatewayDevice.Time.", {"X_TimeManualSetEnable","CurrentLocalTime"})

local obj = {}

obj.ManualSetEnable = val["InternetGatewayDevice.Time."]["X_TimeManualSetEnable"]

local s = val["InternetGatewayDevice.Time."]["CurrentLocalTime"]
    
      s = string.gsub(s, "-", "")
	
      s = string.gsub(s, "T", "")
	
      s = string.gsub(s, ":", "")
	 

obj.Time = s

sys.print(json.xmlencode(obj))

