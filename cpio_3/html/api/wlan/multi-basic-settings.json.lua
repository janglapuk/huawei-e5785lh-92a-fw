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
																	"GuestNetworkIsAccessUI" })

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
																	
function get_index_by_key( key )
    
	-- key 样例"InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1."
	local radioindex = string.match(key, "%d+") 
	local ssidindex = string.match(key, "%d+", 49) 
    local radio1ssidcount = 0
	
	--print("key = "..key)
	--print("radioindex = "..radioindex)
	--print("ssidindex = "..ssidindex)
	
	if( nil == radioindex or nil == ssidindex ) then
		return nil
	end
	
	--第一个radio直接返回ssid索引
	if ( "1" == radioindex ) then
		--print("return "..ssidindex)
		return ssidindex
	end
	
	--计算radio1 ssid个数
	local errcode2,wifissid = dm.GetParameterValues("InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.{i}.", {"Enable"})
	for k2,v2 in pairs(wifissid) do
		radio1ssidcount = radio1ssidcount+1
	end
    
	--第二个radio返回第一个ssid个数+ssid索引
	if ( "2" == radioindex ) then
	    --print("return "..radio1ssidcount + ssidindex)
		return radio1ssidcount + ssidindex
	end
	
	--print("return nil ")
	return nil
end


local errcode,wifiConf = dm.GetParameterValues("InternetGatewayDevice.X_Config.Wifi.Radio.{i}.",
    {
        "Enable"
    }
);
function wlan_get_pwd(ssid, sec, key)

	ssid.WifiWepKey1 = "" 
	ssid.WifiWepKey2 = ""
	ssid.WifiWepKey3 = ""
	ssid.WifiWepKey4 = ""
	ssid.WifiWep128Key1 = ""
	ssid.WifiWep128Key2 = ""
	ssid.WifiWep128Key3 = ""
	ssid.WifiWep128Key4 = ""
	ssid.WifiWpapsk = ""
	ssid.MixWifiWpapsk = ""
	ssid.WifiRadiusKey = ""
end
for k,v in pairs(wifiConf) do
	local wifidomain = "InternetGatewayDevice.X_Config.Wifi."
	local errcode, wifiConf = dm.GetParameterValues(wifidomain, {"Wifi_Show_Maxassoc"})
	local errcode2,wifissid = dm.GetParameterValues(k.."Ssid.{i}.", {"Enable",
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
																	"BridgeInfo",
																	"IsGuestNetwork"
																	})

	for k2,v2 in pairs(wifissid) do
	    local Ssid = {}
		--基本的
		Ssid.Index = get_index_by_key(k2) - 1
		if( nil == Ssid.Index ) then
			return sys.print(json.xmlencode("error"))
		end
		Ssid.ID = k2
		Ssid.WifiEnable = v2["Enable"]
		Ssid.WifiSsid = v2["SSID"]
		--print(v2["SSID"])
		Ssid.WifiMac = v2["BSSID"]
		if 1 == wifiConf[wifidomain]["Wifi_Show_Maxassoc"] or 2 == wifiConf[wifidomain]["Wifi_Show_Maxassoc"] then
			Ssid.wifi_max_assoc = v2["AssociateDeviceNum"]
		end

		if ( 0 == v2["AdvertisementEnabled"] ) then
		--	print( "v2[AdvertisementEnabled] =0" )
			Ssid.WifiBroadcast= 1
		else 
			--print( "v2[AdvertisementEnabled] =1" )
			Ssid.WifiBroadcast= 0
		end
		
		--Ssid.WifiIsolate = v2["IsolateControl"]

		
		
		--security
		local errcode,Security = dm.GetParameterValues(k2.."Security.",{"WEPKey1","WEPKey2","WEPKey3","WEPKey4","KeyPassphrase","AuthType","EncryptionModes","WEPEncryptionLevel","WEPKeyIndex"})
		
		if ( "WPA" == Security[k2.."Security."]["AuthType"] ) then
			Ssid.WifiAuthmode = "WPA-PSK"
		elseif  ( "WPA2" == Security[k2.."Security."]["AuthType"] ) then
			Ssid.WifiAuthmode = "WPA2-PSK"
		elseif ( "WPA/WPA2" == Security[k2.."Security."]["AuthType"] )  then 
			Ssid.WifiAuthmode = "WPA/WPA2-PSK"
		elseif ("8021X" == Security[k2.."Security."]["AuthType"])	then
			Ssid.WifiAuthmode = "802.1x"
		elseif ("WPA2-EAP" == Security[k2.."Security."]["AuthType"])	then
			Ssid.WifiAuthmode = "WPA2 Enterprise"
		elseif ("WPAWPA2-EAP" == Security[k2.."Security."]["AuthType"])	then
			Ssid.WifiAuthmode = "WPA/WPA2 Enterprise"
		elseif ( "Open WEP"== Security[k2.."Security."]["AuthType"]  ) then
			Ssid.WifiAuthmode = "OPEN"
			Ssid.WifiBasicencryptionmodes = "WEP"
		elseif ( "Shared WEP"== Security[k2.."Security."]["AuthType"]  ) then
			Ssid.WifiAuthmode = "SHARE"
			Ssid.WifiBasicencryptionmodes = "WEP"
		elseif ( "Auto WEP"== Security[k2.."Security."]["AuthType"]  ) then
			Ssid.WifiAuthmode = "AUTO"
			Ssid.WifiBasicencryptionmodes = "WEP"
		elseif ( "Open"== Security[k2.."Security."]["AuthType"]  ) then
			Ssid.WifiAuthmode = "OPEN"
			Ssid.WifiBasicencryptionmodes = "NONE"
		end
		
		if( "WEP64" == Security[k2.."Security."]["EncryptionModes"] 
			or "WEP128" == Security[k2.."Security."]["EncryptionModes"]  
			or "WEP256" == Security[k2.."Security."]["EncryptionModes"] ) then
				Ssid.WifiWpaencryptionmodes = "AES"
				--print(Ssid.WifiWpaencryptionmodes)
		elseif("TKIP" == Security[k2.."Security."]["EncryptionModes"]
			or "AES" == Security[k2.."Security."]["EncryptionModes"] ) then
				Ssid.WifiWpaencryptionmodes = Security[k2.."Security."]["EncryptionModes"]
		elseif ("TKIP/AES" == Security[k2.."Security."]["EncryptionModes"] ) then
				Ssid.WifiWpaencryptionmodes = "MIX"
		end
		
		Ssid.WifiWepKeyIndex = Security[k2.."Security."]["WEPKeyIndex"]    
		wlan_get_pwd(Ssid, Security, k2)
		
		--客人wifi时间
		if(nil ~= guestnetwork) then
		    if(nil ~= guestnetwork["GuestNetworkTimerType"]) then
			    Ssid.wifiguestofftime = get_guest_off_time(guestnetwork["GuestNetworkTimerType"])
			end
		end
		--是否是客人ssid
		Ssid.wifiisguestnetwork = v2["IsGuestNetwork"]
		
		
		table.insert(Ssids, Ssid)
	end
	
end	

utils.multiObjSortByID(Ssids)

response.Ssids = Ssids
--print(json.xmlencode(response))
sys.print(json.xmlencode(response))

