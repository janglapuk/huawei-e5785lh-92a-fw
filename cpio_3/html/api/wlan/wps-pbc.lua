local utils = require('utils')
require('dm')

local paras = {}
local wps_mode = "pbc"
if nil ~= data and nil ~= data["WPSMode"] then
	if(1 == data["WPSMode"])then
	    wps_mode = "pbc"
	end
end

if(nil ~= data["ssidindex"] and '4' <= data["ssidindex"]) then
	utils.xmlappenderror(100005)
else
	if(nil == data["ssidindex"] or '0' == data["ssidindex"]) then
		utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS.WpsMode", wps_mode)
	else
		utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.2.Ssid.1.WPS.WpsMode", wps_mode)
	end

	local errcode, NeedReboot, paramerr = dm.SetParameterValues(paras)
	utils.xmlappenderror(errcode)
end
