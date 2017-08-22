require('dm')
require('utils')
require('sys')

if nil == data then
	return
end

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

function check_parameter()
	if nil ~= data.time and string.len(data.time) ~= 14 then
    print("check enable err")	
	return false
	end
	if nil ~= data.enable and string.len(data.enable) ~= 1 then
    print("check enable err")	
	return false
	end
    if nil ~= data.diffcalcEnable and string.len(data.diffcalcEnable) ~= 1 then
    print("check enable err")	
	return false
	end
end

if false == check_parameter() then
	print("check_parameter err")
	utils.xmlappenderror(9003)
	return
end



print("enable:"..data.time)
local errcode = dm.SetParameterValues("InternetGatewayDevice.Time.X_TimeManualSetTime", data.time)
if errcode == 0 then
	print("Update Sntp X_TimeManualSetTime success.")
else
	print("Update Sntp X_TimeManualSetTime fail.")
end

print("enable:"..data.enable)
local errcode = dm.SetParameterValues("InternetGatewayDevice.Time.X_TimeManualSetEnable", data.enable)
if errcode == 0 then
	print("Update Sntp X_TimeManualSetEnable success.")
else
	print("Update Sntp X_TimeManualSetEnable fail.")
end

print("enable:"..data.diffcalcEnable)
local errcode = dm.SetParameterValues("InternetGatewayDevice.Time.X_TimeDiffCalcEnable", data.diffcalcEnable)
if errcode == 0 then
	print("Update Sntp X_TimeDiffCalcEnable success.")
else
	print("Update Sntp X_TimeDiffCalcEnable fail.")
end


