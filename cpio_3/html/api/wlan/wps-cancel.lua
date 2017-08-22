require('utils')
require('web')

local domain1 = "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.WPS."
local errcode1, wpsinfo1 = dm.GetParameterValues(domain1,
{
    "Status"
})
local domain2 = "InternetGatewayDevice.X_Config.Wifi.Radio.2.Ssid.1.WPS."
local errcode2, wpsinfo2 = dm.GetParameterValues(domain2,
{
    "Status"
})
if nil ~= data and nil ~= data.cancelwps then
	if("1" == data.cancelwps and (1 == wpsinfo1[domain1]["Status"] or 1 == wpsinfo2[domain2]["Status"])) then
	    web.cancelwps()
	    utils.xmlappenderror(0)
	else
	    utils.xmlappenderror(100005)
	end
end