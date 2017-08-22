local dm = require('dm')
require('json')

--Á½¸öÐ¾Æ¬µÄWPS×´Ì¬ÏàÍ¬£¬Ö»±£´æÒ»¸öWPS×´Ì¬£¬Ö»ÐèÒª»ñÈ¡Ò»¸ö
local domain = "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS."
local errcode,wpsinfo = dm.GetParameterValues(domain , 
	{
		"Status"
	})
	
local conf = wpsinfo[domain]
local response = {}
response.State = conf["Status"]
sys.print(json.xmlencode(response))