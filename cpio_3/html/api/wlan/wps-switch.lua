local utils = require('utils')
require('dm')

local paras = {}
local errcode, radionum, radioarray = dm.GetObjNum("InternetGatewayDevice.X_Config.Wifi.Radio.{i}")
local wps_enable = data["wpsenable"]
if nil ~= data and nil ~= data["wpsenable"] then
	utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS.Enable", wps_enable)
	utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS.WpsMode", "none")
        if 2 == radionum then
            utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.2.Ssid.1.WPS.Enable", wps_enable)
            utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.2.Ssid.1.WPS.WpsMode", "none")
        end
end
if nil ~= data and nil ~= data["appinenable"] then
	local appin1_enable_path = "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS.ApPinEnable"
	local appin2_enable_path = "InternetGatewayDevice.X_Config.Wifi.Radio.2.Ssid.1.WPS.ApPinEnable"
	local appin_enable = data["appinenable"]
	
    utils.add_one_parameter(paras, appin1_enable_path, appin_enable)
	if 2 == radionum then
        utils.add_one_parameter(paras, appin2_enable_path, appin_enable)
    end
end
local errcode, NeedReboot, paramerr = dm.SetParameterValues(paras)

utils.xmlappenderror(errcode)