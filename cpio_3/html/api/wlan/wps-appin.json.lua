local dm = require('dm')
require('json')
local response = {}
--获取DB中的参数
wps_instance = "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS."

local errcode,wps = dm.GetParameterValues(wps_instance,
    {
        "DevicePin",
		"DefaultDevicePin"
    }
)
local wps_obj = wps[wps_instance]

if wps_obj["DevicePin"] == wps_obj["DefaultDevicePin"] then
    response.wpsappintype = 0
	response.wpsappin = ""
else
    response.wpsappintype = 1
	response.wpsappin = ""
end 
	
sys.print(json.xmlencode(response))
