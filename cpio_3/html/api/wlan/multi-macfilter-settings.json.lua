require('dm')
local Ssids = {}
local response = {}
local count = 0

function init_Ssid(Ssid)
	Ssid.WifiMacFilterMac9 = ""
	Ssid.WifiMacFilterMac8 = ""
	Ssid.WifiMacFilterMac7 = ""
	Ssid.WifiMacFilterMac6 = ""
	Ssid.WifiMacFilterMac5 = ""
	Ssid.WifiMacFilterMac4 = ""
	Ssid.WifiMacFilterMac3 = ""
	Ssid.WifiMacFilterMac2 = ""
	Ssid.WifiMacFilterMac1 = ""
	Ssid.WifiMacFilterMac0 = ""
	
	Ssid.wifihostname9 = ""
	Ssid.wifihostname8 = ""
	Ssid.wifihostname7 = ""
	Ssid.wifihostname6 = ""
	Ssid.wifihostname5 = ""
	Ssid.wifihostname4 = ""
	Ssid.wifihostname3 = ""
	Ssid.wifihostname2 = ""
	Ssid.wifihostname1 = ""
	Ssid.wifihostname0 = ""
end

function get_ssid_mac_info(ssidkey)
	local Ssid = {}
	init_Ssid(Ssid)

	Ssid.Index = count
	count = count + 1
	
	--MacFilter
	local errorcode3, macfilter = dm.GetParameterValues(ssidkey.."MacFilter.",{"Enabled",
																			   "Policy",
																			   "Num"})
	if( 0 ==  macfilter[ssidkey.."MacFilter."]["Enabled"] ) then
		Ssid.WifiMacFilterStatus = 0 --功能关闭
	else
		if( 1 ==  macfilter[ssidkey.."MacFilter."]["Policy"] ) then
			Ssid.WifiMacFilterStatus = 1 --白名单
		else
			Ssid.WifiMacFilterStatus = 2 --黑名单
		end
	end

	for i=1,10,1
	do
		--MacFilter.List.
		local listkey = ssidkey.."MacFilter.List."..i.."."
		local errcode4, macfilterlist = dm.GetParameterValues(listkey, {"SrcMacAddress","HostName"})
		
		if nil ~= macfilterlist then
			macfilterlist = macfilterlist[listkey]
			if 10 == i then
				Ssid.WifiMacFilterMac9 = macfilterlist["SrcMacAddress"]
				Ssid.wifihostname9 = macfilterlist["HostName"]
			elseif 9 == i then
				Ssid.WifiMacFilterMac8 = macfilterlist["SrcMacAddress"]
				Ssid.wifihostname8 = macfilterlist["HostName"]
			elseif 8 == i then
				Ssid.WifiMacFilterMac7 = macfilterlist["SrcMacAddress"]
				Ssid.wifihostname7 = macfilterlist["HostName"]
			elseif 7 == i then
				Ssid.WifiMacFilterMac6 = macfilterlist["SrcMacAddress"]
				Ssid.wifihostname6 = macfilterlist["HostName"]
			elseif 6 == i then
				Ssid.WifiMacFilterMac5 = macfilterlist["SrcMacAddress"]
				Ssid.wifihostname5 = macfilterlist["HostName"]
			elseif 5 == i then
				Ssid.WifiMacFilterMac4 = macfilterlist["SrcMacAddress"]
				Ssid.wifihostname4 = macfilterlist["HostName"]
			elseif 4 == i then
				Ssid.WifiMacFilterMac3 = macfilterlist["SrcMacAddress"]
				Ssid.wifihostname3 = macfilterlist["HostName"]
			elseif 3 == i then
				Ssid.WifiMacFilterMac2 = macfilterlist["SrcMacAddress"]
				Ssid.wifihostname2 = macfilterlist["HostName"]
			elseif 2 == i then
				Ssid.WifiMacFilterMac1 = macfilterlist["SrcMacAddress"]
				Ssid.wifihostname1 = macfilterlist["HostName"]
			elseif 1 == i then
				Ssid.WifiMacFilterMac0 = macfilterlist["SrcMacAddress"]
				Ssid.wifihostname0 = macfilterlist["HostName"]
			end
		end
	end
	table.insert(Ssids, Ssid)
end	

function get_radio_mac_info(radioindex)
	local ssidkey = "InternetGatewayDevice.X_Config.Wifi.Radio."..radioindex..".Ssid.{i}"
	local errorcode, ssidnum, array = dm.GetObjNum(ssidkey)
	for i=1,ssidnum,1
	do
		get_ssid_mac_info("InternetGatewayDevice.X_Config.Wifi.Radio."..radioindex..".Ssid."..i..".")
	end
end

local errorcode, radionum, array = dm.GetObjNum("InternetGatewayDevice.X_Config.Wifi.Radio.{i}")
for i=1,radionum,1
do
	get_radio_mac_info(i)
end

response.Ssids = Ssids
sys.print(json.xmlencode(response))