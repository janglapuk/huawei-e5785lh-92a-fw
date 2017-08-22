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
	if nil ~= data.time and string.len(data.time) ~= 14 then
	print("check time err")
	return false
	end
	if nil ~= data.city and string.len(data.city) >63 then
    print("check city err")	
	return false
	end
	if nil ~= data.timezone and string.len(data.timezone) ~= 9 then
	print("check timezone err")
	return false
	end
end

if false == check_parameter() then
	print("check_parameter err")
	utils.xmlappenderror(9003)
	return
end

print("time:"..data.time)
local errcode = dm.SetParameterValues("InternetGatewayDevice.Time.X_TimeManualSetTime", data.time)
if errcode == 0 then
	print("Update Sntp X_TimeManualSetTime success.")
else
	print("Update Sntp X_TimeManualSetTime fail.")
end

print("timezone:"..data.timezone)
local errcode = dm.SetParameterValues("InternetGatewayDevice.Time.X_TimeManualSetZone", data.timezone)
if errcode == 0 then
	print("Update Sntp X_TimeManualSetZone success.")
else
	print("Update Sntp X_TimeManualSetZone fail.")
end

print("city:"..data.city)
local errcode = dm.SetParameterValues("InternetGatewayDevice.Time.X_TimeManualSetCity", data.city)
if errcode == 0 then
	print("Update Sntp X_TimeManualSetCity success.")
else
	print("Update Sntp X_TimeManualSetCity fail.")
end
