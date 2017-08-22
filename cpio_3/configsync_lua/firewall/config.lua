local utils = require('utils')
local switchobjdomin = "InternetGatewayDevice.X_FireWall.Switch."

local switchparam = {}

local switchmaps = {
    firewallmainswitch="FirewallMainSwitch",
    firewallipfilterswitch="FirewallIPFilterSwitch",
    firewallwanportpingswitch="FirewallWanPortPingSwitch",
    firewallurlfilterswitch="firewallurlfilterswitch",
    firewallmacfilterswitch="firewallmacfilterswitch",
	firewallfwstateswitch="firewallfwstateswitch",
}

function switchSetObjParamInputs(switchobjdomin, data, switchmaps)
    local inputs = {}
    for k, v in pairs(switchmaps) do
        local param = {}
        if nil ~= data and nil ~= data[k] then
            param["key"] = v      
            param["value"] = data[k]
            table.insert(inputs, param)
        end  
    end
    return inputs
end

if nil ~= data and nil ~= data["fwswitch"] then
    print('switch come')
    local param = switchSetObjParamInputs(switchobjdomin, data["fwswitch"], switchmaps)
    print('switch 2 come')
    local errcode, paramErrs = dm.SetObjToDB(switchobjdomin,param)
    print('switch errcode1', errcode)
end


function pcpSetObjParamInputs(domain, data, maps)
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


if nil ~= data and nil ~= data["pcp"] then
    local pcpdomin = "InternetGatewayDevice.X_Config.global."
    local maps = {
       enable="pcp_enabled",
	}
	local param = pcpSetObjParamInputs(pcpdomin, data["pcp"], maps)
	local errcode, paramErrs = dm.SetObjToDB(pcpdomin,param)
    if 0 ~= errcode then                                                    
        print("set  pcp_enabled enable errcode = ",errcode)                           
    end  
end



-- for WAN DMZ
function dmzcreateSubmitData()
    local pppCondomain = "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANPPPConnection.1.X_DMZ."
    local ipCondomain = "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.X_DMZ."
    local umtsCondomain = "InternetGatewayDevice.WANDevice.2.WANConnectionDevice.1.WANPPPConnection.1.X_DMZ."

    local switchobjdomin = ""

    local switchparam = {}

    local switchmaps = {
        dmzstatus="DMZEnable",
        dmzipaddress="DMZHostIPAddress",
    }

    function switchSetObjParamInputs(domain, data, switchmaps)
        local inputs = {}
        for k, v in pairs(switchmaps) do
            local param = {}
            if nil ~= data and nil ~= data[k] then
                param["key"] = v      
                param["value"] = data[k]
                table.insert(inputs, param)
            end  
        end
        return inputs
    end

    if nil ~= data  and nil ~= data["dmz"] then
        print('DMZ come')
        local param = switchSetObjParamInputs(switchobjdomin, data["dmz"], switchmaps)
        print('dmz 2 come')
        local errcode, paramErrs = dm.SetObjToDB(ipCondomain,param)
        print('dmz errcode1', errcode)
        local errcode, paramErrs = dm.SetObjToDB(pppCondomain,param)
        print('dmz errcode2', errcode)
        local errcode, paramErrs = dm.SetObjToDB(umtsCondomain,param)
        print('dmz errcode2', errcode)
    end
end
-- dmz

dmzcreateSubmitData()




-- SIP
function  sipcreateSubmitData()
    -- body
    local switchobjdomin = "InternetGatewayDevice.Services.X_ALGAbility."

    local switchparam = {}

        local switchmaps = {
            sipstatus="SIPEnable",
            sipport="SIPPort",
        }

    function switchSetObjParamInputs(switchobjdomin, data, switchmaps)
        local inputs = {}
        for k, v in pairs(switchmaps) do
            local param = {}
            if nil ~= data and nil ~= data[k] then
                param["key"] = v      
                param["value"] = data[k]
                table.insert(inputs, param)
            end  
        end
        return inputs
    end

    if nil ~= data and nil ~= data["sip"] then
        print('sip come')
        local param = switchSetObjParamInputs(switchobjdomin, data["sip"], switchmaps)
        print('sip 2 come')
        local errcode, paramErrs = dm.SetObjToDB(switchobjdomin,param)
        print('sip errcode1', errcode)
    end
end

sipcreateSubmitData()


-- bridgemode xian add for futrue
local pppCondomain = "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANPPPConnection.1."
local ipCondomain = "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1."
local umtsCondomain = "InternetGatewayDevice.WANDevice.2.WANConnectionDevice.1.WANPPPConnection.1."
local nonatdomain = "InternetGatewayDevice.X_Config.nat."

local paras = {{"X_NATType", "NAPT"}}
local parascone = {{"X_NATType", "cone nat"}}
if data ~= nil and data["nat"] ~= nil and data["nat"]["nonat_enable"] ~= nil then
local nonatparas = {{"NoNatEnable", data["nat"]["nonat_enable"]}}

local errcode, paramErrs = dm.SetObjToDB(nonatdomain,nonatparas)
print("errcode_nonat_enable = ", errcode)

end



if data ~= nil and data["nat"] ~= nil and data["nat"]["nattype"] ~= nil then
    if data["nat"]["nattype"] == "0" then
        local errcode, paramErrs = dm.SetObjToDB(pppCondomain,paras)
        if 0 ~= errcode then
            print("X_nat errcode = ", errcode)
        end
        local errcode, paramErrs = dm.SetObjToDB(ipCondomain,paras)
        if 0 ~= errcode then
            print("X_nat errcode = ", errcode)
        end
        local errcode, paramErrs = dm.SetObjToDB(umtsCondomain,paras)
        if 0 ~= errcode then
            print("X_nat errcode = ", errcode)
        end
    else
        local errcode, paramErrs = dm.SetObjToDB(pppCondomain,parascone)
        if 0 ~= errcode then
            print("X_nat errcode = ", errcode)
        end
        local errcode, paramErrs = dm.SetObjToDB(ipCondomain,parascone)
        if 0 ~= errcode then
            print("X_nat errcode = ", errcode)
        end
        local errcode, paramErrs = dm.SetObjToDB(umtsCondomain,parascone)
        if 0 ~= errcode then
            print("X_nat errcode = ", errcode)
        end
    end
else
    local errcode, paramErrs = dm.SetObjToDB(pppCondomain,parascone)
    if 0 ~= errcode then
        print("X_nat errcode = ", errcode)
    end
    local errcode, paramErrs = dm.SetObjToDB(ipCondomain,parascone)
    if 0 ~= errcode then
        print("X_nat errcode = ", errcode)
    end
    local errcode, paramErrs = dm.SetObjToDB(umtsCondomain,parascone)
    if 0 ~= errcode then
        print("X_nat errcode = ", errcode)
    end
end

-- ip mode set sync
function strip_end_dot(path)
    local len = string.len(path)
    print("strip_end_dot len = ", len)
    if 0 == len then
        return path
    end

    local endStr = string.sub(path, len)
    if "." == endStr then
        return string.sub(path, 0, len-1)
    end
    return path
end



--set bridgemainenable
local mainenable
if data ~= nil and data["bridge"] ~= nil and data["bridge"]["mainenable"] ~= nil then
    mainenable = data["bridge"]["mainenable"]
	print("Set mainenable bridge mode:"..mainenable)
	local BridgeModemainenable = "InternetGatewayDevice.Services.X_BridgeMode."
    local paras = {{"MainEnable",  utils.toboolean(mainenable)}}
    local errcode, paramErrs = dm.SetObjToDB(BridgeModemainenable,paras)
	if errcode == 0 then
		print("Set bridge main enable success.")
	else
		print("Set bridge main mode enable fail.")
		utils.xmlappenderror(errcode)
		return
	end
end





--set bridgedisplayenable
if data ~= nil and data["bridge"] ~= nil and data["bridge"]["displayenable"] ~= nil then
    local displayenable
    if '0' == mainenable then
	    displayenable = 0
	else
	    displayenable = data["bridge"]["displayenable"]
	end
    
	print("Set display enable bridge mode:"..displayenable)
	local BridgeModedisplayenable = "InternetGatewayDevice.Services.X_BridgeMode."
    local paras = {{"DisplayEnable",  utils.toboolean(displayenable)}}
    local errcode, paramErrs = dm.SetObjToDB(BridgeModedisplayenable,paras)
	if errcode == 0 then
		print("Set bridge display enable success.")
		dm.dbsave()
	else
		print("Set bridge display mode enable fail.")
		utils.xmlappenderror(errcode)
		return
	end
end



--set bridgemode enable
local enable = 0
if data ~= nil and data["bridge"] ~= nil and data["bridge"]["bridgemode"] ~= nil then
    enable = data["bridge"]["bridgemode"]
    if '0' == mainenable then
	    enable = 0
	end
    print("Set bridge mode:"..enable)
    local  BridgeModedoamin = "InternetGatewayDevice.Services.X_BridgeMode."
    local paras = {{"UserEnable",  utils.toboolean(enable)}}
    local errcode, paramErrs = dm.SetObjToDB(BridgeModedoamin,paras)
    if 0 ~= errcode then
        print("bridgemode enable errcode = ", errcode)
        print("bridgemode enable fail.")
    end
	
	local parasModeStatus = {{"ModeStatus",  utils.toboolean(enable)}}
    local errcode, paramErrsModeStatus = dm.SetObjToDB(BridgeModedoamin,parasModeStatus)
    if 0 ~= errcode then
        print("bridgemode ModeStatus errcode = ", errcode)
        print("bridgemode ModeStatus fail.")
    end
end

--get umts internet wan
function getUmtsInternetWan()
    local errcode,pppCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}.", { "X_ServiceList"})
    local ret = 0
    if nil ~= pppCon then
        for k,v in pairs(pppCon) do
            if nil ~= v["X_ServiceList"] then
				ret = utils.IsPppInternetWanPath("UMTS", k) --ret 1: is ppp internet wan 0：is not ppp internet wan
				if 1 == ret then						
					print("bridgemode get umts internet wan ok", k)
					return k
				end
            end
        end
    else
        print("bridgemode can't find wanpath")
    end
end

local bridgewan = getUmtsInternetWan()
if nil == bridgewan then
	print("bridgemode bridgewan is nil")
	return
else
	print("bridgemode bridgewan: "..bridgewan)
end

local paras = {}
if utils.toboolean(enable) then
    utils.add_one_parameter(paras, bridgewan.."ConnectionType", "DHCP_Spoofed")
    utils.add_one_parameter(paras, bridgewan.."ConnectionTrigger", "AlwaysOn")
    local  AssociatedConnectiondomain = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement."
    local paras = {{"ConnectionType",  "DHCP_Spoofed"}, {"ConnectionTrigger",  "AlwaysOn"}}
    local errcode, paramErrs = dm.SetObjToDB(bridgewan,paras)
    if errcode ~= 0 then
        print("Set Passthrough err 222")
        utils.appenderror(errcode)
        return
    end
else
    --utils.add_one_parameter(paras, bridgewan.."ConnectionType", "IP_Routed")
    local  AssociatedConnectiondomain = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement."
    local paras = {{"ConnectionType",  "IP_Routed"}}
    local errcode, paramErrs = dm.SetObjToDB(bridgewan,paras)
    if errcode ~= 0 then
        print("Set Passthrough 333")
        utils.appenderror(errcode)
        return
    end
end
utils.print_paras(paras)
--set dhcps
if utils.toboolean(enable) then
    local paras = {}
    utils.add_one_parameter(paras, "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.AssociatedConnection", strip_end_dot(bridgewan))
    utils.add_one_parameter(paras, "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.UseAllocatedWAN", "Passthrough")
    utils.print_paras(paras)
    print("Set LANHostConfigManagement ..")
    local  AssociatedConnectiondomain = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement."
    local paras = {{"AssociatedConnection",  strip_end_dot(bridgewan)}, {"UseAllocatedWAN",  "Passthrough"}}
    local errcode, paramErrs = dm.SetObjToDB(AssociatedConnectiondomain,paras)
    if errcode ~= 0 then
        print("Set Passthrough err444")
        utils.appenderror(errcode)
        return
    end
else
    local  AssociatedConnectiondomain = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement."
    local paras = {{"AssociatedConnection",  ""}, {"UseAllocatedWAN",  "Normal"}}
    local errcode, paramErrs = dm.SetObjToDB(AssociatedConnectiondomain,paras)
    if errcode ~= 0 then
        print("Set Passthrough err444")
        utils.appenderror(errcode)
        return
    end
end
