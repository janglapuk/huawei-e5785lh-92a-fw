local utils = require('utils')
local tostring = tostring

--------------------check the status of ddns display switch--------------------
local errcode,SwitchValues= dm.GetParameterValues("InternetGatewayDevice.X_Config.global.",
        {"ddnsenable"})

if utils.toboolean(SwitchValues["InternetGatewayDevice.X_Config.global."]["ddnsenable"]) then
--print("Ddns Display Switch is on")
else
--print("Ddns Display Switch is off")
    utils.xmlappenderror("100002")
	return	false
end

local errcode,all_ddns= dm.GetParameterValues("InternetGatewayDevice.Services.X_DDNSConfiguration.{i}.",
        {"Enable"})

if nil == data then
	return
end

function delete_all_ddns_entery()
	if nil ~= all_ddns then
		for k,v in pairs(all_ddns) do
			print("    delete ddns : "..k)
			if nil ~= k then
				errcode, needreboot = dm.DeleteObject(k)
				if errcode ~= 0 then
					return errcode
				end
			end
		end
	end
	return 0
end

function add_one_ddns_parameter(paras, name, value, ddnsdomain)
	if nil == value then
		return
	end

	if nil == ddnsdomain then
		return
	end
	local newName = ddnsdomain..name
	table.insert(paras, {newName, value})
end

function build_ddns_parameters(data, ddnsdomain)
	local paras = {}
	local index, provider, enable, domain, username, password

	if nil ~= data["index"] then
		index = data["index"]
	end

	if nil ~= data["provider"] then
		provider = data["provider"]
	end

	if nil ~= data["status"] then
		enable = data["status"]
	end

	if nil ~= data["domainname"] then
		domain = data["domainname"]
	end
	if nil ~= data["username"] then	
		username = data["username"]
	end
	if nil ~= data["password"] then
		password = data["password"]
	end

	if "TZO" == provider then
		provider = "TZO.com"
	end
	add_one_ddns_parameter(paras, "Provider", provider, ddnsdomain)
	add_one_ddns_parameter(paras, "Enable", utils.toboolean(enable), ddnsdomain)

	local _, idx = string.find(domain, "%.")
	--if not idx then
	--	 
	--end
	local hostName   = string.sub(domain, 1, idx - 1)
	local domainName = string.sub(domain, idx + 1)

	add_one_ddns_parameter(paras, "HostName", hostName, ddnsdomain)
	add_one_ddns_parameter(paras, "DomainName", domainName, ddnsdomain)
	add_one_ddns_parameter(paras, "Username", username, ddnsdomain)

	if nil ~= data["password"] then
		add_one_ddns_parameter(paras, "Password", password, ddnsdomain)
	end

	if ("DynDNS.org" == provider) then
		add_one_ddns_parameter(paras, "Protocol", "dyndns", ddnsdomain)
		add_one_ddns_parameter(paras, "Server", "DynDNS.org", ddnsdomain)
	end
	if ("members.dyndns.org" == provider) then
		add_one_ddns_parameter(paras, "Protocol", "dyndns", ddnsdomain)
		add_one_ddns_parameter(paras, "Server", "DynDNS.org", ddnsdomain)
	end	
	if ("No-IP.com" == provider) then
		add_one_ddns_parameter(paras, "Protocol", "no-ip.com", ddnsdomain)
		add_one_ddns_parameter(paras, "Server", "No-IP.com", ddnsdomain)
	end
	if ("dynupdate.no-ip.com" == provider) then
		add_one_ddns_parameter(paras, "Protocol", "no-ip.com", ddnsdomain)
		add_one_ddns_parameter(paras, "Server", "No-IP.com", ddnsdomain)
	end
	if ("DtDNS.com" == provider) then
		add_one_ddns_parameter(paras, "Protocol", "dtdns.com", ddnsdomain)
		add_one_ddns_parameter(paras, "Server", "DtDNS.com", ddnsdomain)
	end
	if ("oray" == provider) then
		add_one_ddns_parameter(paras, "Protocol", "oray", ddnsdomain)
		add_one_ddns_parameter(paras, "Server", "ddns.oray.com", ddnsdomain)
	end

	return paras
end

function add_ddns_entry(ddns)
	-- Add new ddns entry
	local ddnsentry = ""
	local paras = build_ddns_parameters(ddns, ddnsentry)
	errcode, instId, needreboot, errs = dm.AddObjectWithValues("InternetGatewayDevice.Services.X_DDNSConfiguration.", paras)
	return errcode
end

function delete_ddns_entry(index)
	-- Add new ddns entry
	if nil == index then
		return
	end
	local ddnsentry = "InternetGatewayDevice.Services.X_DDNSConfiguration."..index.."."
	if nil ~= ddnsentry then
		errcode, needreboot = dm.DeleteObject(ddnsentry)
	end
	if errcode ~= 0 then
		return errcode
	end
end

function modify_ddns_entry(ddns, index)
	-- Add new ddns entry
	if nil == index then
		return
	end
	local ddnsentry = ""
	local ddnsentry = "InternetGatewayDevice.Services.X_DDNSConfiguration."..index.."."

	local paras = build_ddns_parameters(ddns, ddnsentry)
	local errcode = dm.SetParameterValues(paras)
	if errcode ~= 0 then
		return errcode
	end

end

print(" < operate > = ", data.operate)

if 'table' == type(data.ddnss) then
	-- Add ddns entry
	if nil ~= data.ddnss then
		for k,v in pairs(data.ddnss) do
			if nil ~= data.operate then
				if data.operate == '1' and v ~= nil then
					print("add ojb")
					errcode = add_ddns_entry(v)
				end
				if data.operate == '2' and v.index ~= nil then
					print("delete obj")
					errcode = delete_ddns_entry(v.index)
				end
				if data.operate == '3' and v ~= nil and v.index ~= nil then
					print("modify obj")
					errcode = modify_ddns_entry(v, v.index)
				end
				if errcode ~= 0 then
					utils.xmlappenderror(errcode)
					return errcode
				end
			end
		end
	end
end

utils.xmlappenderror(0)
