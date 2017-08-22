require('dm')
require('utils')
require('sys')

--bridgemode module display switch data nodes "InternetGatewayDevice.Services.X_BridgeMode.DisplayEnable"
--------------------check the status of bridgemode module display switch--------------------
local errcode,SwitchValues= dm.GetParameterValues("InternetGatewayDevice.Services.X_BridgeMode.",
        {"DisplayEnable"})

if utils.toboolean(SwitchValues["InternetGatewayDevice.Services.X_BridgeMode."]["DisplayEnable"]) then
--print("bridgemode  module display switch is on")
else
--print("bridgemode  module display switch is off")
    utils.xmlappenderror("100002")
	return	false
end

function strip_end_dot(path)
    local len = string.len(path)
    if 0 == len then
        return path
    end

    local endStr = string.sub(path, len)
    if "." == endStr then
        return string.sub(path, 0, len-1)
    end
    return path
end

function get_wandev_by_access_type(accesstype, wandevs)
	if nil ~= wandevs then
	    for k,v in pairs(wandevs) do
	        if accesstype == v["WANAccessType"] then
	            return string.sub(k, 1, string.find(k, ".WANCommonInterfaceConfig"))
	        end
	    end
	end

    return ""
end

function get_bridge_mode_wan()
	local err, wandevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANCommonInterfaceConfig", {"WANAccessType"})
	local devpath =  get_wandev_by_access_type("UMTS", wandevs)
	if nil == devpath or "" == devpath then
		return ""
	end 
	local errcode,pppCon = dm.GetParameterValues(devpath.."WANConnectionDevice.{i}.WANPPPConnection.{i}.", {"X_ServiceList"})
	if nil ~= pppCon then
		for k,v in pairs(pppCon) do
			if string.find(v["X_ServiceList"], "INTERNET") then
				return k
			end
		end
	end
	return ""
end


--set bridgemainenable
local mainenable, errcode
if nil ~= data and nil ~= data.mainenable then
	mainenable = data.mainenable
	print("Set display enable bridge mode:"..mainenable)
	errcode = dm.SetParameterValues("InternetGatewayDevice.Services.X_BridgeMode.MainEnable", mainenable)
	if errcode == 0 then
		print("Set bridge main enable success.")
	else
		print("Set bridge main mode enable fail.")
		utils.xmlappenderror(errcode)
		return
	end
end


--Check BridgerestrictEnable
local errcode,val= dm.GetParameterValues("InternetGatewayDevice.Services.X_BridgeMode.", {"BridgerestrictEnable"})
local enable = val["InternetGatewayDevice.Services.X_BridgeMode."]["BridgerestrictEnable"]
print("get BridgerestrictEnable:"..enable)
if enable == 1 then
	print("Set bridge mode unavalible.")
        utils.xmlappenderror(9003)
	return false
else
	print("Set bridge mode avalible.")
end

--set bridgedisplayenable
local enable, errcode
if nil ~= data and nil ~= data.displayenable then
	enable = data.displayenable
    if 0 == mainenable then
	    enable = 0
	end
	print("Set display enable bridge mode:"..enable)
	errcode = dm.SetParameterValues("InternetGatewayDevice.Services.X_BridgeMode.DisplayEnable", enable)
	if errcode == 0 then
		print("Set bridge display mode enable success.")
	else
		print("Set bridge display mode enable fail.")
		utils.xmlappenderror(errcode)
		return
	end
end


--set bridgemode
local enable, errcode
if nil ~= data and nil ~= data.bridgemode then
	enable = data.bridgemode
	if 0 == mainenable then
	    enable = 0
	end
	print("Set bridge mode:"..enable)
	errcode = dm.SetParameterValues("InternetGatewayDevice.Services.X_BridgeMode.UserEnable", enable)
	if errcode == 0 then
		print("Set bridge mode enable success.")
	else
		print("Set bridge mode enable fail.")
		utils.xmlappenderror(errcode)
		return
	end
end

--set bridgemode status
if 0 == mainenable then
    enable = 0
end
local errcode = dm.SetParameterValues("InternetGatewayDevice.Services.X_BridgeMode.ModeStatus", enable)
if errcode == 0 then
	print("Set bridge mode status success.")
else
	print("Set bridge mode status fail.")
	utils.xmlappenderror(errcode)
	return
end

--set wan
local bridgewan = get_bridge_mode_wan()
if "" == bridgewan or nil == bridgewan then
	print("Get bridge mode wan fail")
	utils.xmlappenderror(errcode)
	return
end
local paras = {}

if nil ~= enable then
    if 0 == mainenable then
	    enable = 0
	end
	if utils.toboolean(enable) then
		utils.add_one_parameter(paras, bridgewan.."ConnectionType", "DHCP_Spoofed")
		utils.add_one_parameter(paras, bridgewan.."ConnectionTrigger", "AlwaysOn")
	else
		utils.add_one_parameter(paras, bridgewan.."ConnectionType", "IP_Routed")
		utils.add_one_parameter(paras, bridgewan.."ConnectionTrigger", "OnDemand")
	end
end
utils.print_paras(paras)
local errcode = dm.SetParameterValues(paras)
if errcode ~= 0 then
	print("Set bridgemode wan err")
	utils.xmlappenderror(errcode)
	return
end

--set dhcps
if nil ~= enable then
	if utils.toboolean(enable) then
		local paras = {}
		utils.add_one_parameter(paras, "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.AssociatedConnection", strip_end_dot(bridgewan))
		utils.add_one_parameter(paras, "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.UseAllocatedWAN", "Passthrough")
		utils.print_paras(paras)
		local errcode = dm.SetParameterValues(paras)
		if errcode ~= 0 then
			print("Set Passthrough err")
			utils.xmlappenderror(errcode)
			return
		end
	end
end