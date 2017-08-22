require('dm')
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
    utils.xmlappenderror("100002")
	return	false
end

if nil == data then
	return
end

function check_parameter()
if nil ~= data.SntpSwitch then
	if data.SntpSwitch == "0" or data.SntpSwitch == "1"  then
	    return true
	else 
	    print("Set SntpSwitch err")
	    return false
	end
end
end

if false == check_parameter() then
	print("check_parameter err")
	utils.xmlappenderror(9003)
	return
end
print("SntpSwitch:"..data.SntpSwitch)
local errcode = dm.SetParameterValues("InternetGatewayDevice.Time.Enable", data.SntpSwitch)
if errcode == 0 then
	print("Update Sntp Enable success.")
else
	print("Update Sntp Enable fail.")
end






















