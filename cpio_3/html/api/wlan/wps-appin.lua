local utils = require('utils')
local web = require('web')
local dm = require('dm')
local paras = {}

local wps_instance2 = "InternetGatewayDevice.X_Config.Wifi.Radio.2.Ssid.1.WPS."
local errcode2, wps2 = dm.GetParameterValues(wps_instance2,
	{
		"DefaultDevicePin"
	}
)
if nil ~= data and nil ~= data.wpsappintype then
	if '1' == data.wpsappintype then
	    --生成一个随机pin码
	    local newpin = web.genappin()
		utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS.WpsMode", "ap-pin")
		utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS.DevicePin", newpin)
		if(nil ~= wps2) then
			utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.2.Ssid.1.WPS.WpsMode", "ap-pin")
			utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.2.Ssid.1.WPS.DevicePin", newpin)
		end
	elseif '0' == data.wpsappintype then
	    --获取默认pin码
		local wps_instance = "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS."
		local errcode, wps = dm.GetParameterValues(wps_instance,
			{
				"DefaultDevicePin"
			}
		)

		local wps_obj = wps[wps_instance]
		
		utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS.WpsMode", "ap-pin")
		utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS.DevicePin", wps_obj["DefaultDevicePin"])
		if(nil ~= wps2) then
			utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.2.Ssid.1.WPS.WpsMode", "ap-pin")
			utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Radio.2.Ssid.1.WPS.DevicePin", wps_obj["DefaultDevicePin"])
		end
	end
end

--将随机的pin码或者默认PIN码生效
local errcode, NeedReboot, paramerr =  dm.SetParameterValues(paras)

utils.xmlappenderror(errcode)
