require('dm')
require('utils')
local paras = {}

function parse_data_to_macfilter_para(key, v)
	if ("0" == v.WifiMacFilterStatus) then  --关闭
		utils.add_one_parameter(paras,key.."Enabled",0)
	elseif ("1" == v.WifiMacFilterStatus) then -- 白名单
		utils.add_one_parameter(paras,key.."Enabled",1)
		utils.add_one_parameter(paras,key.."Policy",1)
	elseif ("2" == v.WifiMacFilterStatus) then -- 黑名单
		utils.add_one_parameter(paras,key.."Enabled",1)
		utils.add_one_parameter(paras,key.."Policy",0)
	end
end

function add_mac_filter( key, macfilter,hostname)
    local inputs = {}
	local param = {}
	local param1 = {}
	
	if( nil == macfilter ) then
		macfilter = "" 
	end
	
	param["key"] = "SrcMacAddress"	
	param["value"] = macfilter
	table.insert(inputs, param)
	
	if( nil ~= hostname ) then
		param1["key"] = "HostName"
		param1["value"] = hostname
		table.insert(inputs, param1)
	end
	local errcode, instnum, NeedReboot, paramerr= dm.AddObjectWithValues(key, inputs)
end

function set_mac_filter(key, macfilter, hostname)
	if( nil == macfilter ) then
		macfilter = "" 
	end
	if( nil == hostname ) then
		hostname = "" 
	end
	utils.add_one_parameter(paras, key.."SrcMacAddress", macfilter)
	utils.add_one_parameter(paras, key.."HostName", hostname)
end

--计算mac地址个数
function mac_get_num()
	local errorcode, macnum, array = dm.GetObjNum("InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.MacFilter.List.{i}")
	return macnum
end

function parse_data_to_macfilterlist_para(key, v)
	if 0 == mac_get_num() then
		add_mac_filter(key,v.WifiMacFilterMac0,v.wifihostname0)
		add_mac_filter(key,v.WifiMacFilterMac1,v.wifihostname1)
		add_mac_filter(key,v.WifiMacFilterMac2,v.wifihostname2)
		add_mac_filter(key,v.WifiMacFilterMac3,v.wifihostname3)
		add_mac_filter(key,v.WifiMacFilterMac4,v.wifihostname4)
		add_mac_filter(key,v.WifiMacFilterMac5,v.wifihostname5)
		add_mac_filter(key,v.WifiMacFilterMac6,v.wifihostname6)
		add_mac_filter(key,v.WifiMacFilterMac7,v.wifihostname7)
		add_mac_filter(key,v.WifiMacFilterMac8,v.wifihostname8)
		add_mac_filter(key,v.WifiMacFilterMac9,v.wifihostname9)
	else
		set_mac_filter(key.."1.",v.WifiMacFilterMac0,v.wifihostname0)
		set_mac_filter(key.."2.",v.WifiMacFilterMac1,v.wifihostname1)
		set_mac_filter(key.."3.",v.WifiMacFilterMac2,v.wifihostname2)
		set_mac_filter(key.."4.",v.WifiMacFilterMac3,v.wifihostname3)
		set_mac_filter(key.."5.",v.WifiMacFilterMac4,v.wifihostname4)
		set_mac_filter(key.."6.",v.WifiMacFilterMac5,v.wifihostname5)
		set_mac_filter(key.."7.",v.WifiMacFilterMac6,v.wifihostname6)
		set_mac_filter(key.."8.",v.WifiMacFilterMac7,v.wifihostname7)
		set_mac_filter(key.."9.",v.WifiMacFilterMac8,v.wifihostname8)
		set_mac_filter(key.."10.",v.WifiMacFilterMac9,v.wifihostname9)
	end
end

if nil ~= data and nil ~= data["Ssids"] then
	local Ssids = data["Ssids"]
	dm.StartTransaction()
	for k,v in pairs(Ssids) do
		local key = "InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1."
		if nil ~= v then
			if '0' == v.Index then
				if nil ~= key then
					parse_data_to_macfilter_para(key.."MacFilter.", v)
					parse_data_to_macfilterlist_para(key.."MacFilter.List.", v)
				end
			end
		end
	end
end
local errcode, NeedReboot, paramerr = dm.SetParameterValues(paras)
dm.EndTransaction()
utils.xmlappenderror(errcode)