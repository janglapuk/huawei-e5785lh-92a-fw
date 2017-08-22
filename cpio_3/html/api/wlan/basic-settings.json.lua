local utils = require('utils')
require('dm')
require('web')
require('json')
require('utils')
local Ssids = {}
local response = {}


--获取客人wifi中的节点配置
local guestdomain = "InternetGatewayDevice.X_GUESTNETWORK."
local errcode,guestnetwork = dm.GetParameterValues(guestdomain, {"GuestNetworkTimerType",
																	"GuestNetworkIsolateSsid",
																	"GuestNetworkIsAccessUI"})

if(nil ~= guestnetwork) then
	guestnetwork=guestnetwork[guestdomain]
end
--获取客人wifi的时间
function get_guest_off_time(timetype)
    local offtime = 0;
	--客人wifi时间
	if(0 == timetype) then
		--永久开启
		offtime = 0
	elseif (1 == timetype) then
		--4小时
		offtime = 4
	elseif (2 == timetype) then
		--24小时
		offtime = 24
	else
		--永久开启
		offtime = 0
	end
	return offtime
end


local errcode2,wifissid = dm.GetParameterValues("InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.", {"Enable",
																"Status",
																"BSSID",
																"SSID",
																"AdvertisementEnabled",
																"RadioEnabled",
																"TotalAssociations",
																"AssociateDeviceNum",
																"IsolateControl",
																"DisassocTime",
																"OffTime",
																"RTSThreshold",
																"FragThreshold",
																"DtimPeriod",
																"BeaconPeriod",
																"BridgeInfo"
																})


local Ssid = {}

local v2 = wifissid["InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1."]
Ssid.WifiEnable = v2["Enable"]
Ssid.WifiSsid = v2["SSID"]

if ( 0 == v2["AdvertisementEnabled"] ) then
	Ssid.WifiHide= 1
else
	Ssid.WifiHide= 0
end

Ssid.WifiIsolate = v2["IsolateControl"]

local k2 = "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1."
--wps
local errorcode,wps = dm.GetParameterValues(k2.."WPS.",{"Enable"})
Ssid.WifiWpsenbl = wps[k2.."WPS."]["Enable"]
Ssid.WifiWpscfg = 1

--客人wifi时间
if(nil ~= guestnetwork) then
	if(nil ~= guestnetwork["GuestNetworkTimerType"]) then
		Ssid.wifiguestofftime = get_guest_off_time(guestnetwork["GuestNetworkTimerType"])
	end
end


local wifidomain = "InternetGatewayDevice.X_Config.Wifi."
local errcode1,wifi = dm.GetParameterValues(wifidomain, {"AutoCountrySwitch"})
wifi = wifi[wifidomain]
Ssid.wifiautocountryswitch = wifi["AutoCountrySwitch"]


local radiossiddomain = "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1."						
local errcode,radiossid = dm.GetParameterValues(radiossiddomain, {"Enable",
																	"IsolateControl",
																	"Wifioffenable",
																	"OffTime"
																	})

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
																	})
radiobasic = radiobasic[basicdomain]
radiossid = radiossid[radiossiddomain]
Ssid.wifiautocountryswitch = wifi["AutoCountrySwitch"]
Ssid.WifiEnable = radiossid["Enable"]

Ssid.Wifioffenable = radiossid["Wifioffenable"]
Ssid.Wifiofftime = radiossid["OffTime"]
Ssid.WifiIsolate = radiossid["IsolateControl"]

Ssid.WifiCountry = radiobasic["CountryCode"]
if( 1 == radiobasic["AutoChannelEnable"] ) then
	Ssid.WifiChannel = 0
else
    Ssid.WifiChannel =  radiobasic["Channel"]
end

Ssid.WifiMode = radiobasic["Standard"]
if ( "auto" == radiobasic["Ieee80211NBWControl"]) then
	Ssid.wifibandwidth = 0
else
	Ssid.wifibandwidth = radiobasic["Ieee80211NBWControl"]
end


response = Ssid
sys.print(json.xmlencode(response))
