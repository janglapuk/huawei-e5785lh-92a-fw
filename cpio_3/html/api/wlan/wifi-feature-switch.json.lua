local utils = require('utils')
local response = {}
require('dm')
require('json')
local Ssids = {}

local errcode, ssidConf = dm.GetParameterValues("InternetGatewayDevice.X_Config.Wifi.Radio.{i}.", {"Enable"})

local ssidcount = 0;
for k, v in pairs(ssidConf) do
    local errcode, wifissid = dm.GetParameterValues(k.."Ssid.{i}.", {"Enable"})
    for k2, v2 in pairs(wifissid) do
        ssidcount = ssidcount + 1
    end
end

local domain = "InternetGatewayDevice.X_Config.Wifi."
local errcode, wifiConf = dm.GetParameterValues(domain, {"WifiWpsSuportWepNone",
                                                         "OledShowPassword",
                                                         "Wifi5g_Enabled",
                                                         "WifiAutoCountry_Enabled",
                                                         "AutoCountrySwitch",
                                                         "MaxAssocOffloadOn",
                                                         "ParaImmediateWork_Enable",
                                                         "MaxApNum",
                                                         "IsDoubleChip",
                                                         "Acmode_Enable",
                                                         "OpenNoneWps_Enable",
                                                         "Chinesessid_Enable",
                                                         "Doubleap5g_Enable",
                                                         "Wps_Switch_Enable",
                                                         "GuestWifi_Enable",
                                                         "Wifi_Country_Enable",
                                                         "Wifi24g_Switch_Enable",
                                                         "Wifi_Dfs_Enable",
                                                         "Wps_Cancel_Enable",
                                                         "Wifi_Show_Maxassoc",
                                                         "SupportMaxAssoc"
                                                        })
wifiConf = wifiConf[domain]
response.wifiwpssuportwepnone = 0
response.oledshowpassword = 1
response.wifi5g_enabled = wifiConf["Wifi5g_Enabled"]
response.wifiautocountry_enabled = wifiConf["WifiAutoCountry_Enabled"]
response.wifiautocountryswitch = wifiConf["AutoCountrySwitch"]
response.maxassocoffloadon = ""
response.paraimmediatework_enable = 1
response.maxapnum = ssidcount
response.isdoublechip = wifiConf["IsDoubleChip"]
response.acmode_enable = wifiConf["Acmode_Enable"]
response.opennonewps_enable = 1
response.chinesessid_enable = wifiConf["Chinesessid_Enable"]
response.doubleap5g_enable = wifiConf["Doubleap5g_Enable"]
response.wps_switch_enable = wifiConf["Wps_Switch_Enable"]
response.guestwifi_enable = wifiConf["GuestWifi_Enable"]
response.wifi_country_enable = wifiConf["Wifi_Country_Enable"]
response.wifi24g_switch_enable = wifiConf["Wifi24g_Switch_Enable"]
response.wifi_dfs_enable = wifiConf["Wifi_Dfs_Enable"]
response.wps_cancel_enable = 1
response.show_maxassoc = wifiConf["Wifi_Show_Maxassoc"]
response.wifi_chip_maxassoc = wifiConf["SupportMaxAssoc"]

--get radius switch
local errcode, radius = dm.GetParameterValues(domain, {"RadiusEnable"})
if(nil ~= radius) then
	radius = radius[domain]
	response.radius_enable = radius["RadiusEnable"]
end

--get pmf switch
local errcode, pmf = dm.GetParameterValues(domain, {"PmfEnable"})
if(nil ~= pmf) then
    pmf = pmf[domain]
    response.pmf_enable = pmf["PmfEnable"]
end

--get DBDC enable
local errcode, dbdcConf = dm.GetParameterValues(domain,{"WifiDbdcEnable"})

if(nil ~= dbdcConf)then
	dbdcConf = dbdcConf[domain]
	response.wifi_dbdc_enable = dbdcConf["WifiDbdcEnable"]
end

local stadomain = "InternetGatewayDevice.X_Config.Wifi.Sta."
local errcode, wifistaConf = dm.GetParameterValues(stadomain, {"StaWpsEnabled",
                                                               "StaFrequenceEnable"
                                                              })
if(nil ~= wifistaConf) then
    wifistaConf = wifistaConf[stadomain]
    response.stawpsenabled = wifistaConf["StaWpsEnabled"]
    response.stafrequenceenable = wifistaConf["StaFrequenceEnable"]
end
sys.print(json.xmlencode(response))				