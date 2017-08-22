require('dm')
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
    utils.xmlappenderror("100002")
	return	false
end

if nil == data then
	return
end

function check_parameter()
if nil ~= data.timesetswitch then
	if data.timesetswitch == "0" or data.timesetswitch == "1"  then
	    return true
	else 
	    print("Set timesetswitch err")
	    return false
	end
end
end

if false == check_parameter() then
	print("check_parameter err")
	utils.xmlappenderror(9003)
	return
end

print("timesetswitch:"..data.timesetswitch)
local errcode = dm.SetParameterValues("InternetGatewayDevice.Time.X_TimeManualSetEnable", data.timesetswitch)
if errcode == 0 then
	print("Update Sntp X_TimeManualSetEnable success.")
else
	print("Update Sntp X_TimeManualSetEnable fail.")
end






















