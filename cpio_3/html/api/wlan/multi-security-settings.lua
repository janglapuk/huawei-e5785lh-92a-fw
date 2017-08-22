require('dm')
require('utils')
require('sys')

local paras = {}
local g_errcode = 0

function parse_data_to_wifi_para( key, v)
	if nil ~= key then
		utils.add_one_parameter( paras,key.."AutoCountrySwitch",  v.wifiautocountryswitch)
	end
end



function parse_data_to_ssid_para(key, v)
	--先获取ssid，再把获取到得ssid发下去，因为后台校验ssid不能为空
	local errcode,radiobasic = dm.GetParameterValues(key, {"SSID"})
	if( nil ==radiobasic ) then
		return
	end
	radiobasic = radiobasic[key]
	if( nil ==radiobasic ) then
		return
	end
	if( nil == key ) then
		return
	end
	utils.add_one_parameter( paras, key.."SSID", radiobasic["SSID"] )

	utils.add_one_parameter( paras, key.."Wifioffenable", v.Wifioffenable )
	utils.add_one_parameter( paras, key.."OffTime", v.Wifiofftime )

	utils.add_one_parameter(paras, key.."IsolateControl", v.WifiIsolate)
end


function parse_data_to_basic_para(key,v)
	if nil == key then
		return
	end
	if( "0" == v.wifiautocountryswitch ) then
		utils.add_one_parameter(paras, key.."CountryCode", v.WifiCountry)
	end

	if( "0"  == v.WifiChannel ) then
		utils.add_one_parameter(paras, key.."AutoChannelEnable", 1)
	else
		utils.add_one_parameter(paras, key.."AutoChannelEnable", 0)
		utils.add_one_parameter(paras, key.."Channel", v.WifiChannel)
	end

	utils.add_one_parameter( paras, key.."Standard", v.WifiMode )

	if( "0"  == v.wifibandwidth ) then
		utils.add_one_parameter( paras, key.."Ieee80211NBWControl", "auto" )
	else
		utils.add_one_parameter( paras, key.."Ieee80211NBWControl", v.wifibandwidth )
	end


	if( "b" == v.WifiMode
	    or "g" == v.WifiMode
	    or "n" == v.WifiMode
	    or "b/g" == v.WifiMode
	    or "b/g/n" == v.WifiMode) then
		utils.add_one_parameter(paras, key.."OperatingFrequencyBand", "2.4GHz")
	else
	    utils.add_one_parameter(paras, key.."OperatingFrequencyBand", "5GHz")
	end
        utils.add_one_parameter(paras, key.."PmfMode", v.pmf_switch)
end

--AP间隔离配置发生变化通知guestnetwork
function parse_data_to_bssisolate_para(key,v)
	if('0' ~= v.WifiIsolationBetween and '1' ~= v.WifiIsolationBetween ) then
		return 0
	end

	local maps = {
				GuestNetworkIsolateSsid = "GuestNetworkIsolateSsid"
			}

		local errcode, values = dm.GetParameterValues(key, maps)

		local obj
		if values ~= nil then
			obj = values[key]
			obj["GuestNetworkIsolateSsid"] = v.WifiIsolationBetween
			local param = utils.GenSetObjParamInputs(key, obj, maps)
			local err,needreboot, paramerror = dm.SetParameterValues(param);
		end
	return 1
end

function parse_data_to_wifirestart_para(data)
	if nil ~= data and nil ~= data["WifiRestart"] then
		local wifiRestart = data["WifiRestart"]
		utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Wifi_Restart", wifiRestart)
	end
end


function wifi_switch_status()
	local radiostatus = 0
	local ssidstatus = 0
	local postssidstatus = 0
	local errcode, wifiradio = dm.GetParameterValues("InternetGatewayDevice.X_Config.Wifi.Radio.1.", {"Enable"})
	for k, v in pairs(wifiradio) do
		if nil == v["Enable"] then
			g_errcode = 9003
			return
		end
		radiostatus = v["Enable"]

		local errcode, wifissid = dm.GetParameterValues(k.."Ssid.{i}.", {"Enable"})
		for k1, v1 in pairs(wifissid) do
			if nil == v1["Enable"] then
				g_errcode = 9003
				return
			end
			ssidstatus = ssidstatus + v1["Enable"]
		end
	end

	for k2, v2 in pairs(data) do
		if nil ~= v2.WifiEnable then
			postssidstatus = v2.WifiEnable
		end
	end

	if 0 == radiostatus or (0 == ssidstatus and 0 == postssidstatus) then
		g_errcode = 9003
		return false
	else
		return true
	end
end

if nil ~= data then
	if true == wifi_switch_status() then
		parse_data_to_wifi_para("InternetGatewayDevice.X_Config.Wifi.",data )
		parse_data_to_ssid_para("InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.", data )
		parse_data_to_ssid_para("InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.2.", data )
		parse_data_to_ssid_para("InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.3.", data )
		parse_data_to_ssid_para("InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.4.", data )
		parse_data_to_basic_para("InternetGatewayDevice.X_Config.Wifi.Radio.1.Basic." , data )
		parse_data_to_wifirestart_para(data)
		--AP间隔离配置发生变化通知guestnetwork

		local result = parse_data_to_bssisolate_para("InternetGatewayDevice.X_GUESTNETWORK.", data)
		if (0 == result) then
			g_errcode = 100005
		else
			local errcode, NeedReboot, paramerr = dm.SetParameterValues(paras)
			g_errcode = errcode
		end
	end
end

utils.xmlappenderror(g_errcode)