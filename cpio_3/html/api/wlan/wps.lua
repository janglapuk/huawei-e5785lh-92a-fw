require('dm')
require('utils')
local paras = {}

if nil == data then
	return
end

if(nil == data["ssidindex"] or '0' == data["ssidindex"]) then
	utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS.WpsMode", "client-pin")
	utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS.ClientPin", data["WPSPin"])
else
	utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.2.Ssid.1.WPS.WpsMode", "client-pin")
	utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.2.Ssid.1.WPS.ClientPin", data["WPSPin"])
end

local errcode, NeedReboot, paramerr = dm.SetParameterValues(paras)
utils.xmlappenderror(errcode)