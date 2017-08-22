require('dm')
require('json')
local response = {}
local ssids = {}

function get_IsolationBetween()
	--???????wifi?е???????
	local guestdomain = "InternetGatewayDevice.X_GUESTNETWORK."
	local errcode,guestnetwork = dm.GetParameterValues(guestdomain, {"GuestNetworkTimerType",
	                                                                 "GuestNetworkIsolateSsid",
	                                                                 "GuestNetworkIsAccessUI"
	                                                                })
	if(nil ~= guestnetwork) then
	   guestnetwork=guestnetwork[guestdomain]
	end
	--????wifi
	if(nil ~= guestnetwork) then
	    --AP?????
	    if(nil ~= guestnetwork["GuestNetworkIsolateSsid"])then
	       return guestnetwork["GuestNetworkIsolateSsid"]
	    end
	end
	return nil
end

function get_index_by_key(key)
    -- key ????"InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1."
    local radioindex = string.match(key, "%d+")
    local ssidindex = string.match(key, "%d+", 49)
    local radio1ssidcount = 0
    
    if( nil == radioindex or nil == ssidindex ) then
        return nil
    end
    
    --?????radio??????ssid????
    if ( "1" == radioindex ) then
        return ssidindex
    end
    
    --????radio1 ssid????
	local errcode2,wifissid = dm.GetParameterValues("InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.{i}.", {"Enable"})
	for k2,v2 in pairs(wifissid) do
		radio1ssidcount = radio1ssidcount+1
	end
    
	--?????radio????????ssid????+ssid????
	if ( "2" == radioindex ) then
		return radio1ssidcount + ssidindex
	end
	return nil
end

local wifidomain = "InternetGatewayDevice.X_Config.Wifi."
local errcode1, wifi = dm.GetParameterValues(wifidomain, {"AutoCountrySwitch"})	
wifi = wifi[wifidomain]

local errcode, wifiConf = dm.GetParameterValues("InternetGatewayDevice.X_Config.Wifi.Radio.{i}.",
    {
        "Enable"
    }
)

local IsolationBetween = get_IsolationBetween()

for k,v in pairs(wifiConf) do
	local errcode2, wifibasic = dm.GetParameterValues(k.."Basic.", {"Standard",
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
	local errcode3, wifissid = dm.GetParameterValues(k.."Ssid.{i}.", {"Index",
	                                                                  "Enable",
	                                                                  "IsolateControl",
									  "Wifioffenable",
	                                                                  "OffTime"
	                                                                 })
	wifibasic = wifibasic[k.."Basic."]
	for k2, v2 in pairs(wifissid) do
		local ssid = {}
		ssid.Index = get_index_by_key(k2) - 1
		if(nil == ssid.Index) then
			return sys.print(json.xmlencode("error"))
		end
		ssid.ID = k2
		ssid.WifiEnable = v2["Enable"]
		ssid.Wifioffenable = v2["Wifioffenable"]
		ssid.Wifiofftime = v2["OffTime"]
		ssid.WifiIsolate = v2["IsolateControl"]
		ssid.WifiCountry = wifibasic["CountryCode"]
		if(1 == wifibasic["AutoChannelEnable"]) then
			ssid.WifiChannel = 0
		else
			ssid.WifiChannel =  wifibasic["Channel"]
		end
		ssid.WifiMode = wifibasic["Standard"]
		if("auto" == wifibasic["Ieee80211NBWControl"]) then
			ssid.wifibandwidth = 0
		else
			ssid.wifibandwidth = wifibasic["Ieee80211NBWControl"]
		end
		
		ssid.wifiautocountryswitch = wifi["AutoCountrySwitch"]
		ssid.WifiIsolationBetween = IsolationBetween
		ssid.pmf_switch = wifibasic["PmfMode"]
		table.insert(ssids, ssid)
	end
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

utils.multiObjSortByID(ssids)

response.ssids = ssids
sys.print(json.xmlencode(response))