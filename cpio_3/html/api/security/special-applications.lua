require('dm')
require('utils')
require('sys')

if nil == data then
	return
end

local datalist = data["LanPorts"]

function reparse_protocol(proto)
	if proto == "6" then
		return "TCP"
	elseif proto == "17" then
		return "UDP"
	else
		return "TCP/UDP"
	end
end

function port_filter(port)
	if nil == port or port == "" then
		return 0
	else
		return port
	end
end

function check_para(v)
	if nil == v.SpecialApplicationTriggerName or nil == v.SpecialApplicationTriggerStatus or nil == v.SpecialApplicationTriggerPort 
	    or nil == v.SpecialApplicationTriggerProtocol or nil == v.SpecialApplicationOpenProtocol or nil == v.SpecialApplicationStartOpenPort0 then
		print("Lost some item, please check!")
		return 0
	end
	if "0" ~= v.SpecialApplicationTriggerProtocol and "6" ~= v.SpecialApplicationTriggerProtocol and "17" ~= v.SpecialApplicationTriggerProtocol then
		print("SpecialApplicationTriggerProtocol is error : "..v.SpecialApplicationTriggerProtocol)
	    return 0
	end
	if "0" ~= v.SpecialApplicationOpenProtocol and "6" ~= v.SpecialApplicationOpenProtocol and "17" ~= v.SpecialApplicationOpenProtocol then
		print("SpecialApplicationOpenProtocol is error : "..v.SpecialApplicationOpenProtocol)
	    return 0
	end
	if "0" ~= v.SpecialApplicationTriggerStatus and "1" ~= v.SpecialApplicationTriggerStatus then
		print("SpecialApplicationTriggerStatus is error : "..v.SpecialApplicationTriggerStatus)
		return 0
	end
	return 1
end

function parse_data_to_para(v)
	local para = {
		{"PortTriggerDescription", v.SpecialApplicationTriggerName},
		{"PortTriggerEnable", utils.toboolean(v.SpecialApplicationTriggerStatus)},
		{"TriggerPort", v.SpecialApplicationTriggerPort},
		{"TriggerProtocol", reparse_protocol(v.SpecialApplicationTriggerProtocol)},
		{"Protocol", reparse_protocol(v.SpecialApplicationOpenProtocol)},
		{"OpenPort", port_filter(v.SpecialApplicationStartOpenPort0)},
		{"OpenPortEnd", port_filter(v.SpecialApplicationEndOpenPort0)},
		{"OpenPort1", port_filter(v.SpecialApplicationStartOpenPort1)},
		{"OpenPortEnd1", port_filter(v.SpecialApplicationEndOpenPort1)},
		{"OpenPort2", port_filter(v.SpecialApplicationStartOpenPort2)},
		{"OpenPortEnd2", port_filter(v.SpecialApplicationEndOpenPort2)},
		{"OpenPort3", port_filter(v.SpecialApplicationStartOpenPort3)},
		{"OpenPortEnd3", port_filter(v.SpecialApplicationEndOpenPort3)},
		{"OpenPort4", port_filter(v.SpecialApplicationStartOpenPort4)},
		{"OpenPortEnd4", port_filter(v.SpecialApplicationEndOpenPort4)}
	}

	return para
end

function delete_porttrigger_by_wan(wanid)
	if nil == wanid then
		return
	end

	local domain = wanid.."X_PortTrigger.{i}."
	local errcode,items = dm.GetParameterValues(domain, {"PortTriggerEnable"})
	if nil ~= items then
		for k,v in pairs(items) do
			if k ~= nil then
				dm.DBDeleteObject(k)
			end
		end
	        dm.dbsave()
	end
end

function add_porttrigger_by_wan(wanid)
    if nil == datalist or datalist == "" then 
		return true
	end 
	if nil == wanid then
		return
	end
	local domain = wanid.."X_PortTrigger."
	for k,v in pairs(datalist) do
		local checkret = check_para(v)
		if 0 == checkret then
			print("check para error.")
			utils.xmlappenderror(9003)
			return false		
		end
		local item = parse_data_to_para(v)
		print("Add porttrigger with domain "..domain)
		--utils.print_paras(item)
		local errcode = dm.AddObjectWithValues(domain, item)
		if errcode ~= 0 then			
			print("Add porttrigger fail.")
			utils.xmlappenderror(errcode)
			return false
		end
	end

	return true
end

function add_porttrigger_toDB_by_wan(wanid)
    if nil == datalist or datalist == "" then 
		return true
	end 
	if nil == wanid then
		return
	end

	local domain = wanid.."X_PortTrigger."
	for k,v in pairs(datalist) do
		local item = parse_data_to_para(v)
		--print("Add porttrigger with domain "..domain)
		--utils.print_paras(item)
		local errcode = dm.AddObjectToDB(domain, item)
		if errcode ~= 0 then			
			print("Add porttrigger fail.")
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
		{"PortTriggerDescription", v.PortTriggerDescription},
		{"PortTriggerEnable", v.PortTriggerEnable},
		{"TriggerPort", v.TriggerPort},
		{"TriggerProtocol", v.TriggerProtocol},
		{"Protocol", v.Protocol},
		{"OpenPort", v.OpenPort},
		{"OpenPortEnd", v.OpenPortEnd},
		{"OpenPort1", v.OpenPort1},
		{"OpenPortEnd1", v.OpenPortEnd1},
		{"OpenPort2", v.OpenPort2},
		{"OpenPortEnd2", v.OpenPortEnd2},
		{"OpenPort3", v.OpenPort3},
		{"OpenPortEnd3", v.OpenPortEnd3},
		{"OpenPort4", v.OpenPort4},
		{"OpenPortEnd4", v.OpenPortEnd4}
	}

	return para
end

function restore_porttrigger_by_wan(wanid)
	if nil == wanid then
		return
	end

	local domain = wanid.."X_PortTrigger."

	if nil ~= ipCon then
		for m,n in pairs(ipCon) do
			if string.find(n["X_ServiceList"], 'INTERNET') ~= nil then
				if nil ~=  n["X_AutoFlag"] then
					if utils.toboolean(n["X_AutoFlag"]) and nil ~= m then
						local savederrcode,saveddata = dm.GetParameterValues(m.."X_PortTrigger.{i}.", {"PortTriggerDescription", "PortTriggerEnable", "TriggerPort", 
							"Protocol", "TriggerProtocol", "OpenPort", "OpenPortEnd", "OpenPort1", "OpenPortEnd1", "OpenPort2", "OpenPortEnd2",
							"OpenPort3", "OpenPortEnd3", "OpenPort4", "OpenPortEnd4"})
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

dm.StartTransactionEx("porttrigger")
if nil ~= pppCon then
	for k,v in pairs(pppCon) do
		if string.find(v["X_ServiceList"], 'INTERNET') ~= nil then
			if nil ~= v["X_AutoFlag"] then
				if utils.toboolean(v["X_AutoFlag"]) then
					delete_porttrigger_by_wan(k)
					if false == add_porttrigger_by_wan(k) then
						delete_porttrigger_by_wan(k)
						restore_porttrigger_by_wan(k)
						dm.EndTransactionEx("porttrigger", 9003)
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
				    delete_porttrigger_by_wan(k)
				    if false == add_porttrigger_toDB_by_wan(k) then
						dm.EndTransactionEx("porttrigger", 9003)
					    return
				    end
			    end
			end
		end
	end
end
dm.EndTransactionEx("porttrigger", 0)
