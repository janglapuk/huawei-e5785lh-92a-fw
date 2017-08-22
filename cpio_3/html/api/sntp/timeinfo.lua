local utils = require('utils')
local sys = require('sys')

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

local domain = "InternetGatewayDevice.Time."

if nil == data then
	return
end

--异常判断
if nil == data.firstserver then
	return
end
if nil == data.secondserver then
	return
end
if nil == data.localtimezonename then
	return
end
if nil == data.timezoneidx then
	return
end
local errcode,values = dm.GetParameterValues("InternetGatewayDevice.Time.",{"Enable"})
local val = values["InternetGatewayDevice.Time."]["Enable"]
print("val= ",val)
if 1 == val then
local paras = {}
utils.add_one_parameter(paras, "InternetGatewayDevice.Time.NTPServer1", data.firstserver)
utils.add_one_parameter(paras, "InternetGatewayDevice.Time.NTPServer2", data.secondserver)
utils.add_one_parameter(paras, "InternetGatewayDevice.Time.LocalTimeZoneName", data.localtimezonename)
utils.add_one_parameter(paras, "InternetGatewayDevice.Time.X_Label", data.timezoneidx)
utils.print_paras(paras)
local errcode = dm.SetParameterValues(paras)
if errcode ~= 0 then
	print("Set timeinfo err")
	utils.xmlappenderror(errcode)
	return
end
end
utils.xmlappenderror(errcode)


