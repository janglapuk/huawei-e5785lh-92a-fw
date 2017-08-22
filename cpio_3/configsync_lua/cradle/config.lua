local utils = require('utils')

if data == nil then
    print("cradle data nil")
    return
end

local objdomin = "InternetGatewayDevice.X_Config.global."
local maps = {
    enable="cradleenable",
}
function SetObjParamInputs(domain, data, maps)
    local inputs = {}
    for	k, v in	pairs(maps) do
	local param = {}
		if nil ~= data and nil ~= data[k] then
			param["key"] = v      
			param["value"] = data[k]
			table.insert(inputs, param)
		end
    end
    return inputs
end

local param = SetObjParamInputs(objdomin, data,	maps)
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)

local pppdomain = "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANPPPConnection.1."
local ipdomain = "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1."

local ipParas, pppParas = {}, {}

function GetConnectionmode()
	if data["profile"] == nil then 
		print("cradle data.profile nil")
		return
	end
	
	if data["profile"]["connectionmode"] == nil then 
		print("cradle data.profile.connectionmode nil")
		return
	end
	
	print("cradle data.connectionmode = "..data["profile"]["connectionmode"])
	local EthAutoparas = {{"WorkMode", data["profile"]["connectionmode"]}} 
	local errcode = dm.SetObjToDB("InternetGatewayDevice.Services.X_EthAuto.", EthAutoparas)
	if errcode == 0 then
		print("cradle Update connection mode success.")
	else
		print("cradle Update connection mode fail.")
	end
end

local ipEnable, pppEnable = false, false
function GetPppParas()
	if data["profile"] == nil then 
		print("cradle data.profile nil")
		return
	end
	
	if data["profile"]["connectionmode"] == nil  then		
		print("cradle data.profile.connectionmode nil for ppp")
		return
	end		
	
	print("cradle Build ppp parameters.")
		
	if data["profile"]["connectionmode"] == "0" or data["profile"]["connectionmode"] == "1" or data["profile"]["connectionmode"] == "2" then		
		pppEnable = true
	end	
	
	local switchparam = {}
	
		local switchmaps = {
			pppoeuser="Username",
			pppoepwd="Password",
			pppoemtu="MaxMRUSize",
			dialmode="ConnectionTrigger",
			maxidletime="IdleDisconnectTime",
			pppoeauth="PPPAuthenticationProtocol",			
		}
	
	function switchSetObjParamInputs(pppdomain, data, switchmaps)
		local inputs = {}
		for k, v in pairs(switchmaps) do
			local param = {}
			if nil ~= data and nil ~= data[k] and "" ~= data[k] then
				param["key"] = v  
				if v == "ConnectionTrigger" then
					if data["dialmode"] == "1" then
						param["value"] = "OnDemand"
					else
						param["value"] = "AlwaysOn"
					end 
				elseif v == "PPPAuthenticationProtocol" then
					param["value"] = "PAP"
					if data["pppoeauth"] == "1" then
						param["value"] = "PAP"
					elseif data["pppoeauth"] == "2" then
						param["value"] = "CHAP"
					end								
				else
					param["value"] = data[k]
				end
				table.insert(inputs, param)
			end
		end
		return inputs
	end
	
	local pppoeparas = switchSetObjParamInputs(pppdomain, data["profile"], switchmaps)
	local errcode = dm.SetObjToDB(pppdomain, pppoeparas)
	print("cradle pppwan errcode = ", errcode)
	if errcode ~= 0 then
		print("cradle Set ["..pppdomain.."] fail.")
	end
end

function GetIpoePara()
	if data["profile"] == nil then 
		print("cradle data.profile nil")
		return
	end
	
	if data["profile"]["connectionmode"] == nil then 
		print("cradle data.profile.connectionmode nil")
		return
	end
	
	print("cradle Build ipoe parameters.")
	
	if data["profile"]["connectionmode"] == "0" or data["profile"]["connectionmode"] == "1" or data["profile"]["connectionmode"] == "3" 
	or data["profile"]["connectionmode"] == "4" then		
		ipEnable = true
	end	

	print("cradle connectionmode:", data["profile"]["connectionmode"])	

	local ipoepara = {}	
			
	if data["profile"]["ipaddress"] ~=nil and data["profile"]["ipaddress"] ~="" then
	table.insert(ipoepara, {"ExternalIPAddress",data["profile"]["ipaddress"]})
	end
		
	if data["profile"]["netmask"] ~=nil and data["profile"]["netmask"] ~="" then
	table.insert(ipoepara, {"SubnetMask",data["profile"]["netmask"]})
	end	

	if data["profile"]["gateway"] ~=nil and data["profile"]["gateway"] ~="" then
	table.insert(ipoepara, {"DefaultGateway",data["profile"]["gateway"]})
	end	
	
	local ipmtu, conntype
	if data["profile"]["connectionmode"] == "4" then
		ipmtu = 1500
		if data["profile"]["staticipmtu"] ~= nil and data["profile"]["staticipmtu"] ~= "" then
			ipmtu = data["profile"]["staticipmtu"]
		end
		
		table.insert(ipoepara, {"MaxMTUSize",ipmtu})
		
		conntype = "Static"		
		table.insert(ipoepara, {"AddressingType",conntype})
		
		
		local dnsfirst = ''
        local dnssecond = ''
        local dnsall = ''
        if data["profile"]["primarydns"] ~= nil then
                if string.len(data["profile"]["primarydns"]) > 1 then
                        dnsfirst = data["profile"]["primarydns"]
                end
        end
        if data["profile"]["secondarydns"] ~= nil then
                if string.len(data["profile"]["secondarydns"]) > 1 then
                        dnssecond = data["profile"]["secondarydns"]
                end
        end

        if dnsfirst ~= '' and dnssecond ~= '' then
                dnsall = dnsfirst..','..dnssecond
        end

        if dnsfirst == '' then
                print("dnsfirst is = nill, none dns ...")
        end

        if dnssecond == '' and dnsfirst ~= '' then
                print("dnssecond is = nill, will use firest ...")
                dnsall = dnsfirst
        end
	
		if string.len(dnsall) > 0 then
		table.insert(ipoepara, {"DNSServers",dnsall})
		end
	
	else
	    ipmtu = 1500
		if data["profile"]["dynamicipmtu"] ~= nil and data["profile"]["dynamicipmtu"] ~= "" then
			ipmtu = data["profile"]["dynamicipmtu"]
		end
		
		table.insert(ipoepara, {"MaxMTUSize",ipmtu})
		
		conntype = "DHCP"		
		table.insert(ipoepara, {"AddressingType",conntype})		
		
		local dnsoverride = true
		if data["profile"]["dynamicsetdnsmanual"] ~= nil then		
			if utils.toboolean(data["profile"]["dynamicsetdnsmanual"]) then
				dnsoverride = false
			else
				dnsoverride = true
			end
		end
		
		table.insert(ipoepara, {"DNSOverrideAllowed",dnsoverride})		
		
		local dnsfirst = ''
        local dnssecond = ''
        local dnsall = ''
        if data["profile"]["dynamicprimarydns"] ~= nil then
                if string.len(data["profile"]["dynamicprimarydns"]) > 1 then
                        dnsfirst = data["profile"]["dynamicprimarydns"]
                end
        end
        if data["profile"]["dynamicsecondarydns"] ~= nil then
                if string.len(data["profile"]["dynamicsecondarydns"]) > 1 then
                        dnssecond = data["profile"]["dynamicsecondarydns"]
                end
        end

        if dnsfirst ~= '' and dnssecond ~= '' then
                dnsall = dnsfirst..','..dnssecond
        end

        if dnsfirst == '' then
                print("dnsfirst is = nill, none dns ...")
        end

        if dnssecond == '' and dnsfirst ~= '' then
                print("dnssecond is = nill, will use firest ...")
                dnsall = dnsfirst
        end
			
		if false == dnsoverride then
			if string.len(dnsall) > 0 then
				table.insert(ipoepara, {"DNSServers",dnsall})	
			end	
		end
	end
	
	local errcode = dm.SetObjToDB(ipdomain, ipoepara)
	print("cradle ipwan errcode = ", errcode)
	if errcode ~= 0 then
		print("cradle Set ["..ipoepara.."] fail.")		
	end
	utils.print_paras(ipoepara)
   
end

function GetEnable()
	local wan_enable  = false
	local auto_enable = false
	local eth_display = false
	local ipv6_show   = false
	
	if data["profile"] ~= nil and data["profile"]["connectionmode"] ~= nil then 
		local ipenableerrcode = dm.SetObjToDB(ipdomain, {{"Enable", ipEnable}})
		if ipenableerrcode ~= 0 then
			print("ipenableerrcode = ", ipenableerrcode)
		end
		
		local pppenableerrcode = dm.SetObjToDB(pppdomain, {{"Enable", pppEnable}})
		if pppenableerrcode ~= 0 then
			print("pppenableerrcode = ", pppenableerrcode)
		end
	end
	
	if (data["ethwan_enable"]) ~= nil then
		if utils.toboolean(data["ethwan_enable"]) then
			wan_enable = true
		else
			wan_enable = false
		end
		print("ethwan_enable = ", wan_enable)		
		local EthWanEnable = dm.SetObjToDB("InternetGatewayDevice.WANDevice.1.WANEthernetInterfaceConfig.", {{"Enable", wan_enable}})
		if EthWanEnable ~= 0 then
			print("cradle EthWanEnable set error  = ", EthWanEnable)
		end
		print("cradle EthWanEnable set error  = ", EthWanEnable)		
	end
	
	if (data["ethauto_enable"]) ~= nil then
		if utils.toboolean(data["ethauto_enable"]) then
			auto_enable = true
		else
			auto_enable = false
		end
		print("ethauto_enable = ", auto_enable)		
		local errcode = dm.SetObjToDB("InternetGatewayDevice.Services.X_EthAuto.", {{"Enable", auto_enable}})
		if errcode ~= 0 then
			print("cradle X_EthAuto set error  = ", errcode)
		end
		print("cradle X_EthAuto set error  = ", errcode)		
	end
	
	if (data["eth_display"]) ~= nil then
		if utils.toboolean(data["eth_display"]) then
			eth_display = true
		else
			eth_display = false
		end
		print("eth_display = ", eth_display)		
		local EthWebDisplay = dm.SetObjToDB("InternetGatewayDevice.X_Config.cradle.", {{"EthDisplay", eth_display}})
		if EthWebDisplay ~= 0 then
			print("cradle eth_display set error  = ", EthWebDisplay)
		end
		print("cradle eth_display set error  = ", EthWebDisplay)		
	end
	
	if (data["ipv6_display"]) ~= nil then
		if utils.toboolean(data["ipv6_display"]) then
			ipv6_show = true
		else
			ipv6_show = false
		end
		print("cradle ipv6_show enbale = ", ipv6_show)		

		local ipv6displayerrcode = dm.SetObjToDB("InternetGatewayDevice.X_Config.cradle.", {{"ipv6_display", ipv6_show}})
		if ipv6displayerrcode ~= 0 then
			print("ipv6displayerrcode = ", ipv6displayerrcode)
		end
		print("ipv6displayerrcode = ", ipv6displayerrcode)		
	end
end
  
function GetEthType()
    local errcode, WanAccessType = dm.GetParameterValues("InternetGatewayDevice.WANDevice.1.WANCommonInterfaceConfig.", {"WANAccessType"})
    print('cradle GetEthType error = ', errcode)
    if nil ~= WanAccessType then
        for k, v in pairs(WanAccessType) do
            if nil ~=  v["WANAccessType"] then
                print('cradle GetEthType WANAccessType = ', v["WANAccessType"])
                return v["WANAccessType"]
            end
        end
    end
end

local AccessType = GetEthType()
if "Ethernet" ~= AccessType then
	print("cradle Current wan access type NOT ethernet, NOT sync")
	return
end
  
GetConnectionmode()
  
print("Update wan "..pppdomain)
GetPppParas()

print("Update wan "..ipdomain)

GetIpoePara() 

GetEnable()





