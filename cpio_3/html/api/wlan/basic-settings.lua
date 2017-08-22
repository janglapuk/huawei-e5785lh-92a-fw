local dm = require('dm')
local utils = require('utils')
require('sys')

local paras = {}
local g_errcode = 0


function parse_data_to_ssid_para(key, v)
	if nil == key then
		return
	end
    local errcode1,ssidpara = dm.GetParameterValues(key, {"Enable","IsGuestNetwork"})
    ssidpara = ssidpara[key]

	--先获取ssid，再把获取到得ssid发下去，因为后台校验ssid不能为空
	local errcode2,radiobasic = dm.GetParameterValues(key, {"SSID"})
	if( nil ==radiobasic ) then
		return
	end
	radiobasic = radiobasic[key]
	if( nil ==radiobasic ) then
		return
	end
	utils.add_one_parameter(paras, key.."SSID", radiobasic["SSID"])
	utils.add_one_parameter(paras, key.."Enable", v.WifiEnable)
	utils.add_one_parameter(paras, key.."IsolateControl", v.WifiIsolate)
	utils.add_one_parameter(paras, key.."Wifioffenable", v.Wifioffenable)
	utils.add_one_parameter(paras, key.."OffTime", v.Wifiofftime)
end

local ID = "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1."

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

		local errcode, wifissid = dm.GetParameterValues(k.."Ssid.1.", {"Enable"})
		for k1, v1 in pairs(wifissid) do
			if(nil == v1["Enable"]) then
				g_errcode = 9003
				return
			end
			ssidstatus = v1["Enable"]
		end
	end

	for k2, v2 in pairs(data) do
		if nil ~= v2.WifiEnable then
			postssidstatus = postssidstatus + v2.WifiEnable
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
		parse_data_to_ssid_para(ID,data)
		local errcode, NeedReboot, paramerr = dm.SetParameterValues(paras)
		g_errcode = errcode
	end
end

utils.xmlappenderror(g_errcode)