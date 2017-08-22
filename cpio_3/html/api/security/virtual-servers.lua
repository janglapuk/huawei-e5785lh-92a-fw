require('dm')
require('utils')
require('sys')

if nil == data then
	return
end

local datalist = data["Servers"]

--get the TR069 ConnReqPort------------
function Get_Tr069DisplaySwitch()
local errcode,SwitchValues= dm.GetParameterValues("InternetGatewayDevice.Services.X_CWMPDISPLAY.",
        {"Cwmp_Display"})
	--print("SwitchValues errcode is "..errcode)
	if nil ~= SwitchValues and utils.toboolean(SwitchValues["InternetGatewayDevice.Services.X_CWMPDISPLAY."]["Cwmp_Display"]) then
	--print("cwmp  module Switch is on")
		return true
	else
	--print("cwmp  module Switch is off")
		return false
	end
end

local Tr069DisplayStatus = Get_Tr069DisplaySwitch()
local TR069_ConnReqPort = nil

if true == Tr069DisplayStatus then 
local errcode,TR069Value = dm.GetParameterValues("InternetGatewayDevice.ManagementServer.",{"X_ConnReqPort"})
	--print("Then errcode is "..errcode)
	if nil ~= TR069Value then
	local TR069_obj = TR069Value["InternetGatewayDevice.ManagementServer."]
		if nil ~= TR069Value and nil ~= TR069_obj["X_ConnReqPort"] and TR069_obj["X_ConnReqPort"] ~= "0" then
			TR069_ConnReqPort = TR069_obj["X_ConnReqPort"]
			print("TR069_ConnReqPort is "..TR069_ConnReqPort)
		end
	end
else
	--print("TR069_ConnReqPort is nil ")
end


function reparse_protocol(proto)
	if proto == "6" then
		return "TCP"
	elseif proto == "17" then
		return "UDP"
	else
		return "TCP/UDP"
	end
end

function check_para(v)
	local externalport_num
	local internalport_num
	local externalendport_num
	local internalendport_num
	
	if nil == v.VirtualServerIPName or nil == v.VirtualServerStatus or nil == v.VirtualServerIPAddress or nil == v.VirtualServerWanPort or nil == v.VirtualServerLanPort or nil == v.VirtualServerProtocol then
		print("Lost some item, please check!")
		return 0
	end
	if "0" ~= v.VirtualServerProtocol and "6" ~= v.VirtualServerProtocol and "17" ~= v.VirtualServerProtocol then
		print("VirtualServerProtocol is error : "..v.VirtualServerProtocol)
	    return 0
	end
	if "0" ~= v.VirtualServerStatus and "1" ~= v.VirtualServerStatus then
		print("VirtualServerStatus is error : "..v.VirtualServerStatus)
		return 0
	end
    -----------------------------------------check  Wan and lan port ----------------------------------------------
	
	if  nil == v.VirtualServerWanEndPort or "0" == v.VirtualServerWanEndPort or "" == v.VirtualServerWanEndPort then   -- ??èYà?UI,à?UIμ? WanEndPort?anil?￡
		externalendport_num = tonumber(v.VirtualServerWanPort)
	else
		externalendport_num = tonumber(v.VirtualServerWanEndPort)
	end
	
	if  nil == v.VirtualServerLanEndPort or "0" == v.VirtualServerLanEndPort or "" == v.VirtualServerLanEndPort then  -- í?WanEndPort±￡3?ò???
		internalendport_num = tonumber(v.VirtualServerLanPort)
	else
		internalendport_num = tonumber(v.VirtualServerLanEndPort)
	end
	
	externalport_num = tonumber(v.VirtualServerWanPort)
	internalport_num = tonumber(v.VirtualServerLanPort)
	if nil == externalendport_num or nil == internalendport_num or nil == externalport_num or nil == internalport_num then
	    print("port value error ")
		return 0
	end
	
	if 0 == externalendport_num or 0 == internalendport_num or 0 == externalport_num or 0 == internalport_num then 
	    print("port value is 0 error ")
		return 0
	end
	
	if externalendport_num < externalport_num or internalendport_num < internalport_num then
	    print("port range error ")
		return 0
	end
	
	if externalendport_num - externalport_num ~= internalendport_num - internalport_num then
	    print("port range no equated ")
		return 0
	end

	if true == Tr069DisplayStatus and nil ~= TR069_ConnReqPort then 
		if TR069_ConnReqPort >= externalport_num and TR069_ConnReqPort <= externalendport_num then
			print("TR069 port in the range of PortMap ports; externalport_num-externalendport_num is "..externalport_num.."-"..externalendport_num)
			return 0
		end
	end
	
	return 1
end

function parse_data_to_para(v)
	local Remoteip
	local externalendport
	local internalendport
	if nil ~= v.VirtualServerRemoteIP then
		Remoteip = v.VirtualServerRemoteIP
	else
		Remoteip = ""
	end
	if  nil == v.VirtualServerWanEndPort or 0 == v.VirtualServerWanEndPort or "" == v.VirtualServerWanEndPort then
		externalendport = v.VirtualServerWanPort
	else
		externalendport = v.VirtualServerWanEndPort
	end
	
	if  nil == v.VirtualServerLanEndPort or 0 == v.VirtualServerLanEndPort or "" == v.VirtualServerLanEndPort then
		internalendport = v.VirtualServerLanPort
	else
		internalendport = v.VirtualServerLanEndPort
	end
	
	local para = {
		{"PortMappingDescription", v.VirtualServerIPName},
		{"PortMappingEnabled", utils.toboolean(v.VirtualServerStatus)},
		{"RemoteHost", Remoteip},
		{"ExternalPort", v.VirtualServerWanPort},
		{"ExternalPortEndRange", externalendport},
		{"InternalPort", v.VirtualServerLanPort},
		{"InternalPortEndRange", internalendport},
		{"InternalClient", v.VirtualServerIPAddress},
		{"PortMappingProtocol", reparse_protocol(v.VirtualServerProtocol)}
	}

	return para
end

function delete_portmapping_by_wan(wanid)
	if nil == wanid then
		return
	end
	local domain = wanid.."PortMapping.{i}."
	local errcode,items = dm.GetParameterValues(domain, { "PortMappingEnabled"})
	if nil ~= items then
		for k,v in pairs(items) do
			if nil ~= k then
				dm.DBDeleteObject(k)
			end
		end
	        dm.dbsave()
	end
end

function add_portmapping_by_wan(wanid)
	if nil == wanid then
		return true
	end
    if nil == datalist or datalist == "" then 
		return true
	end 
	local domain = wanid.."PortMapping."
	for k,v in pairs(datalist) do
		local item = parse_data_to_para(v)
		--print("Add portmapping with domain "..domain)
		--utils.print_paras(item)
		local errcode,inst = dm.AddObjectWithValues(domain, item)
		if errcode ~= 0 then
			print("Add portmapping fail.")
			utils.xmlappenderror(errcode)
			return false
		end
	end
	return true
end

function add_portmapping_toDB_by_wan(wanid)
	if nil == wanid then
		return true
	end
    if nil == datalist or datalist == "" then 
		return true
	end 
	local domain = wanid.."PortMapping."
	for k,v in pairs(datalist) do
		local item = parse_data_to_para(v)
		--print("Add portmapping with domain "..domain)
		--utils.print_paras(item)
		local errcode,inst = dm.AddObjectToDB(domain, item)
		if errcode ~= 0 then
			print("Add portmapping fail.")
			utils.xmlappenderror(errcode)
			return false
		end
	end
	return true
end

local errcode,pppCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}.", { "X_AutoFlag","X_ServiceList"});
local errcode,ipCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANIPConnection.{i}.", { "X_AutoFlag","X_ServiceList"});

function restore_data_to_para(v)
	local para = {
		{"PortMappingDescription", v.PortMappingDescription},
		{"PortMappingEnabled", v.PortMappingEnabled},
		{"RemoteHost", v.RemoteHost},
		{"ExternalPort", v.ExternalPort},
		{"ExternalPortEndRange", v.ExternalPortEndRange},
		{"InternalPort", v.InternalPort},
		{"InternalPortEndRange", v.InternalPortEndRange},
		{"InternalClient", v.InternalClient},
		{"PortMappingProtocol", v.PortMappingProtocol}
	}

	return para
end

function restore_portmapping_by_wan(wanid)
	if nil == wanid then
		return
	end
	local domain = wanid.."PortMapping."

	if nil ~= ipCon then
		for m,n in pairs(ipCon) do
			if string.find(n["X_ServiceList"], 'INTERNET') ~= nil then 
				if nil ~= n["X_AutoFlag"] then
					if utils.toboolean(n["X_AutoFlag"]) and nil ~= m then
						local savederrcode,saveddata = dm.GetParameterValues(m.."PortMapping.{i}.", {"PortMappingDescription", "PortMappingEnabled", "RemoteHost", 
							"ExternalPort", "ExternalPortEndRange", "InternalPort", "InternalClient", "PortMappingProtocol"})
						if nil ~= saveddata then
							for k,v in pairs(saveddata) do
								local item = restore_data_to_para(v)
								local errcode = dm.AddObjectToDB(domain, item)
							end
						end
					end
				end
			end 
		end
	end

	return 
end

-----------------------------------------
--对下发的报文进行校验
-----------------------------------------

if data ~= nil then
    if nil ~= datalist and datalist ~= "" then 
		for k,v in pairs(datalist) do
			local checkret = check_para(v)
			if checkret == 0 then
				print(" check para fail.")
				utils.xmlappenderror(9003)
				return false
			end
		end
	end 
end
dm.StartTransactionEx("portmapping")
if nil ~= pppCon then
	for k,v in pairs(pppCon) do
		if string.find(v["X_ServiceList"], 'INTERNET') ~= nil then
			if nil ~= v["X_AutoFlag"] then
				if utils.toboolean(v["X_AutoFlag"]) then
					delete_portmapping_by_wan(k)
					if false == add_portmapping_by_wan(k) then
						delete_portmapping_by_wan(k)
						restore_portmapping_by_wan(k)
						dm.EndTransactionEx("portmapping", 9003)
						return
					end
				end
		    end
		end
	end
end

if nil ~= ipCon then
	for k,v in pairs(ipCon) do
		if string.find(v["X_ServiceList"], 'INTERNET') ~= nil then
			if nil ~= v["X_AutoFlag"] then
				if utils.toboolean(v["X_AutoFlag"]) then
					delete_portmapping_by_wan(k)
					if false == add_portmapping_toDB_by_wan(k) then
					print("it is not work for portmapping")
					dm.EndTransactionEx("portmapping", 9003)
						return
					end
				end
			end
		end
	end
end
dm.EndTransactionEx("portmapping", 0)
