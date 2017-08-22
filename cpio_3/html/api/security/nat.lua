require('dm')
require('utils')
require('sys')

local errcode,pppCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}.", { "X_AutoFlag"});
local errcode,ipCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANIPConnection.{i}.", { "X_AutoFlag"});

if nil == data then
	return
end

function parse_nattype(type)
	if type == "1" then
		return "cone nat"
	else
		return "NAPT"
	end
end

if nil ~= data.NATType then
	if data.NATType ~= "0" and data.NATType ~= "1" then
		utils.xmlappenderror(9003)
		return
	end
end

local domain
if nil ~= pppCon then
	for k,v in pairs(pppCon) do
		if nil ~= v["X_AutoFlag"] then
			if utils.toboolean(v["X_AutoFlag"]) and k ~= nil then
				domain = k.."X_NATType"
				local errcode = dm.SetParameterValues(domain, parse_nattype(data.NATType))
				if errcode == 0 then
					print("Update nat success "..domain)
				else
					print("Update nat fail "..domain)
				end
			end
		end
	end
end

if nil ~= ipCon then
	for k,v in pairs(ipCon) do
		if nil ~= v["X_AutoFlag"] then
			if utils.toboolean(v["X_AutoFlag"]) and k ~= nil then
				domain = k.."X_NATType"
				local errcode = dm.SetParameterValues(domain, parse_nattype(data.NATType))
				if errcode == 0 then
					print("Update nat success "..domain)
				else
					print("Update nat fail "..domain)
				end
			end
		end
	end
end