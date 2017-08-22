local utils = require('utils')

local radios = {}
local ssids = {}

local objdomin = "InternetGatewayDevice.X_Config.Wifi."
local guestdomain = "InternetGatewayDevice.X_GUESTNETWORK."

local objdominglobal = "InternetGatewayDevice.X_Config.global."

local maps = {
    enable="wifienable",
}

function SetObjParamInputs(domain, data, maps)
    local inputs = {}
    for k, v in pairs(maps) do
        local param = {}
        if nil ~= data and nil ~= data[k] then
            param["key"] = v
            param["value"] = data[k]
            table.insert(inputs, param)
        end
    end
    return inputs
end

local param = SetObjParamInputs(objdominglobal, data,	maps)
local errcode, paramErrs = dm.SetObjToDB(objdominglobal,param)


--解析当前的feature定制
function parse_data_to_feature_para(objdomin, data)
    local maps = {
    	wifiautocountry_enabled = "WifiAutoCountry_Enabled",
    	wifiautocountryswitch = "AutoCountrySwitch",
    	wifi5g_enabled = "Wifi5g_Enabled",
    	doubleap5g_enable = "Doubleap5g_Enable",
    	chinesessid_enable = "Chinesessid_Enable",
    	wps_switch_enable = "Wps_Switch_Enable",
    	guestwifi_enable = "GuestWifi_Enable",
    	wifi_country_enable = "Wifi_Country_Enable",
    	qrcode_version = "QrCode_Version",
    	wifi_dfs_enable = "Wifi_Dfs_Enable",
    	wifi_show_maxassoc = "Wifi_Show_Maxassoc",
    	wifi_chip_maxassoc = "SupportMaxAssoc",
    	wifi_dbdc_enable = "WifiDbdcEnable",
    	wifi_isdoublechip = "IsDoubleChip",
        appin_switch_display = "ApPinEnableDisplay",
        pmf_enable = "PmfEnable",
    }
    local param = SetObjParamInputs(objdomin, data, maps)
    local errcodefeature, paramErrs = dm.SetObjToDB(objdomin, param)
    if (0 ~= errcodefeature) then
    	print("errcodefeature = "..errcodefeature)
    end
end

function parse_data_to_radio(radiok, radiov)
	local maps = {
        enable = "Enable"
    }
	
    local param = SetObjParamInputs(radiok, radiov, maps)
    local errcoderadio, paramErrs = dm.SetObjToDB(radiok, param)
    if (0 ~= errcoderadio) then
    	print("errcoderadio = "..errcoderadio)
    end
end


function parse_data_to_radio_basic(radiok, radiov)
    local maps = {
		wififreband = "OperatingFrequencyBand",
		wificountry = "CountryCode",
		wifimode = "Standard",
		wifibandwidth = "Ieee80211NBWControl",
		totalwifimaxassoc = "TotalWifiMaxAssoc",
		wifiautochannelenable = "AutoChannelEnable",
		wifichannel = "Channel",
		wifiwmmenable = "WMMEnable"
    }
    local param = SetObjParamInputs(radiok, radiov, maps)
    local errcoderadiobasic, paramErrs = dm.SetObjToDB(radiok, param)
    if (0 ~= errcoderadiobasic) then
    	print("errcoderadiobasic = "..errcoderadiobasic)
    end
end

function parse_data_to_radio_ssid_para(ssidk, ssidv)
    local maps = {
    	wifienable = "Enable",
    	wifibroadcast = "AdvertisementEnabled",
    	wifimaxassoc = "AssociateDeviceNum",
    	wifiisolate = "IsolateControl",
    	wifidisassoctime = "DisassocTime",
    	wifiofftime = "OffTime",
       	wifiisguestnetwork = "IsGuestNetwork"
    }
    local param = SetObjParamInputs(ssidk, ssidv, maps)
    local errcoderadiossid, paramErrs = dm.SetObjToDB(ssidk, param)
    if (0 ~= errcoderadiossid) then
    	print("errcoderadiossid = "..errcoderadiossid)
    end
end

function parse_data_to_radio_ssid_sec_para(ssidk, ssidv)
    local maps = {
    	wifiauthmode = "AuthType",
    	wifiencryptionmodes = "EncryptionModes"
    }
    local param = SetObjParamInputs(ssidk, ssidv, maps)
    local errcoderadiossidsec, paramErrs = dm.SetObjToDB(ssidk, param)
    if (0 ~= errcoderadiossidsec) then
    	print("errcoderadiossidsec = "..errcoderadiossidsec)
    end
end

function parse_data_to_radio_ssid_wps_para(ssidk, ssidv)
    local maps = {
    	wifiwpsenbl = "Enable",
        appin_enable = "ApPinEnable"
    }
    local param = SetObjParamInputs(ssidk, ssidv, maps)
    local errcoderadiossidwps, paramErrs = dm.SetObjToDB(ssidk, param)
    if (0 ~= errcoderadiossidwps) then
    	print("errcoderadiossidwps = "..errcoderadiossidwps)
    end
end

function add_ssid(radioindex, ssiddomain)
    for k,v in pairs(data[radioindex]) do
        local index = 0
        if(nil ~= string.find(k, "ssid1")) then
            index = 1
        elseif(nil ~= string.find(k, "ssid2")) then
            index = 2
        elseif(nil ~= string.find(k, "ssid3")) then
            index = 3
        elseif(nil ~= string.find(k, "ssid4")) then
            index = 4
        end
		if(0 ~= index) then
			local errcoderadio, ssid = dm.GetParameterValues(ssiddomain..index..".",
			{
				"Enable"
			});
			if(nil == ssid) then
				-- add ssid
				local errcode, paramErrs = dm.AddObjectToDB(ssiddomain,{})
				if(0 ~= errcode) then
					print("add ssid radio error:"..errcode)
				end
			end
		end
    end
end

-- 同步radio basic
function sync_radio_basic(radioindex)

	radiodomain = "InternetGatewayDevice.X_Config.Wifi.Radio.".."radioindex"..".Basic."
	
	--检测radio basic实例是否存在
	local errcoderadio, radiobasic = dm.GetParameterValues(radiodomain,
	{
		"OperatingFrequencyBand"
	});
	
	if(nil == radiobasic)then
		local errcode, paramErrs = dm.AddObjectToDB(radiodomain,{})
		if(0 ~= errcode) then
			print("add a radio basic error:"..errcode)
		end
	end
	
end
-- 检测radio实例是否存在，如果不存在创建一个Radio实例
function sync_radio_para(radiodomain)
	--查看radio的实例是否存在
	local errcoderadio, radio = dm.GetParameterValues(radiodomain,
	{
		"Enable"
	});
	
	if(nil == radio) then
		-- 不存在，添加实例
		local errcode, paramErrs = dm.AddObjectToDB(radiodomain,{})
		
		if(0 ~= errcode)then
			print("add a radio error:"..errcode)		
		end
	end
	
	
end

--添加实例
function add_radio()
    for k,v in pairs(data) do
		local radioindex = ""
		local radiodomain = ""
		local ssiddomain = ""

		--find the radio1 instance
		if(nil ~= string.find(k, "radio1")) then
			radioindex = "radio1"
			radiodomain = "InternetGatewayDevice.X_Config.Wifi.Radio.1."
			sync_radio_para(radiodomain)
			ssiddomain = "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid."
			add_ssid(radioindex, ssiddomain)
		end
		--find the radio2 instance
		if(nil ~= string.find(k, "radio2")) then
			radioindex = "radio2"
			radiodomain = "InternetGatewayDevice.X_Config.Wifi.Radio.2."
			sync_radio_para(radiodomain)
			ssiddomain = "InternetGatewayDevice.X_Config.Wifi.Radio.2.Ssid."
			add_ssid(radioindex, ssiddomain)
		end
    end
end

function get_ssids(radiok)
    ssids = {}
    local errcode1, ssid1 = dm.GetParameterValues(radiok.."1.",
    {
        "Enable"
    });
    if (nil ~= ssid1) then
        table.insert(ssids, ssid1)
    end

    local errcode2, ssid2 = dm.GetParameterValues(radiok.."2.",
    {
        "Enable"
    });
    if (nil ~= ssid2) then
        table.insert(ssids, ssid2)
    end
	
    local errcode3, ssid3 = dm.GetParameterValues(radiok.."3.",
    {
        "Enable"
    });
    if (nil ~= ssid3) then
        table.insert(ssids, ssid3)
    end

    local errcode4, ssid4 = dm.GetParameterValues(radiok.."4.",
    {
        "Enable"
    });
    if (nil ~= ssid4) then
        table.insert(ssids, ssid4)
    end
end

function parse_data_to_ssid(radiok, radiov)
    get_ssids(radiok)
    local ssidindex = 1
    for ssidk, ssidv in pairs(ssids) do
    if (nil ~= radiov["ssid"..ssidindex]) then
        parse_data_to_radio_ssid_para(radiok..ssidk..".", radiov["ssid"..ssidindex])
        parse_data_to_radio_ssid_sec_para(radiok..ssidk..".Security.", radiov["ssid"..ssidindex]["wifisec"])
        parse_data_to_radio_ssid_wps_para(radiok..ssidk..".WPS.", radiov["ssid"..ssidindex]["wps"])
    end
        ssidindex = ssidindex + 1
    end
end

function get_radio(radioindex)
    local radiodomain = "InternetGatewayDevice.X_Config.Wifi.Radio."..radioindex.."."
    local errcoderadio, radio = dm.GetParameterValues(radiodomain,
    {
        "Enable"
    });

    if(nil ~= radio) then
        table.insert(radios, radio)
    end		
end

function set_radio_data()
    local radioindex = 1
    local radiodomain = "InternetGatewayDevice.X_Config.Wifi.Radio."
    for radiok, radiov in pairs(radios) do 
    if(nil ~= data["radio"..radioindex]) then
        parse_data_to_radio(radiodomain..radioindex..".", data["radio"..radioindex])
        parse_data_to_radio_basic(radiodomain..radioindex..".Basic.", data["radio"..radioindex]["wifibasic"])
        parse_data_to_ssid(radiodomain..radioindex..".Ssid.", data["radio"..radioindex])
    end
    radioindex = radioindex + 1
    end
end

--guestnetwork
function set_guest_data()
    local guestmaps = {
        GuestNetworkIsolateSsid = "GuestNetworkIsolateSsid",
        GuestNetworkIsAccessUI = "GuestNetworkIsAccessUI"
    }
    
    local errcode1, values = dm.GetParameterValues(guestdomain, guestmaps)
    local obj
    if values ~= nil then
        obj = values[guestdomain]
        obj["GuestNetworkIsolateSsid"] = data.wifibssisolate
        obj["GuestNetworkIsAccessUI"] = data.wifiaccessui
        local param = SetObjParamInputs(guestdomain, obj, guestmaps)
        local errcoderadiossidwps, paramErrs = dm.SetObjToDB(guestdomain, param)
    end
end

--lua入口
if "" ~= data then
    add_radio()
end

parse_data_to_feature_para(objdomin, data)
get_radio(1)
get_radio(2)
set_radio_data()
--gusetnetwork
set_guest_data()

return errcode, paramerr
