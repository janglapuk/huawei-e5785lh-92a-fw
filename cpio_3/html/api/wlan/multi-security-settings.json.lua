local utils = require('utils')
require('dm')
require('web')
require('json')
require('utils')
local response = {}


local wifidomain = "InternetGatewayDevice.X_Config.Wifi."
local errcode1,wifi = dm.GetParameterValues(wifidomain, {"AutoCountrySwitch"})	

local basicdomain = "InternetGatewayDevice.X_Config.Wifi.Radio.1.Basic."                                                  
local errcode1,radiobasic = dm.GetParameterValues(basicdomain, {"Standard",
																	"CountryCode",
																	"AutoChannelEnable",
																	"Channel",
																	"PossibleChannels",
																	"OperatingFrequencyBand",
																	"OffTime",
																	"Ieee80211NBWControl",
																	"BitRate",
                                                                "PmfMode",
																	})																	
																	
local radiossiddomain = "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1."							
local errcode,radiossid = dm.GetParameterValues(radiossiddomain, {"Enable",
																	"IsolateControl",
																	"Wifioffenable",
																	"OffTime"
																	})

--获取客人wifi中的节点配置
local guestdomain = "InternetGatewayDevice.X_GUESTNETWORK."							
local errcode,guestnetwork = dm.GetParameterValues(guestdomain, {"GuestNetworkTimerType",
																	"GuestNetworkIsolateSsid",
																	"GuestNetworkIsAccessUI"
																	})																	
							
wifi = wifi[wifidomain]
radiobasic = radiobasic[basicdomain]
radiossid=radiossid[radiossiddomain]
if(nil ~= guestnetwork) then
	guestnetwork=guestnetwork[guestdomain]
end

response.WifiIsolationBetween = 0
--客人wifi
if(nil ~= guestnetwork) then
	--AP间隔离
	if(nil ~= guestnetwork["GuestNetworkIsolateSsid"])then
		response.WifiIsolationBetween  = guestnetwork["GuestNetworkIsolateSsid"]
	end
end
response.wifiautocountryswitch = wifi["AutoCountrySwitch"]
							
response.WifiEnable = radiossid["Enable"]
response.Wifioffenable = radiossid["Wifioffenable"]
response.Wifiofftime = radiossid["OffTime"]
response.WifiIsolate = radiossid["IsolateControl"]


response.WifiCountry = radiobasic["CountryCode"]
if( 1 == radiobasic["AutoChannelEnable"] ) then
	response.WifiChannel = 0
else
    response.WifiChannel =  radiobasic["Channel"]
end

response.WifiMode = radiobasic["Standard"]

response.pmf_switch = radiobasic["PmfMode"]


if ( "auto" == radiobasic["Ieee80211NBWControl"]) then
	response.wifibandwidth = 0
else
	response.wifibandwidth = radiobasic["Ieee80211NBWControl"]
end

--客人wifi时间
if(nil ~= guestnetwork) then

	if("0" == guestnetwork["GuestNetworkTimerType"]) then
		--永久开启
		response.wifiguestofftime = 0
	elseif ("1" == guestnetwork["GuestNetworkTimerType"])then
		--4小时
		response.wifiguestofftime = 4
	elseif ("2" == guestnetwork["GuestNetworkTimerType"])then
		--24小时
		response.wifiguestofftime = 24
	else 
		--永久开启
		response.wifiguestofftime = 0
	end
end

response.wificountrysupport5g = 1

sys.print(json.xmlencode(response))
