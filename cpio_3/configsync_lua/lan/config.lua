local utils = require('utils')

function  lancreateSubmitData()
    -- body
    local switchobjdomin = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.1."

    local switchparam = {}

        local switchmaps = {
            ipaddress="IPInterfaceIPAddress",
            mask="IPInterfaceSubnetMask",
            ipmacdisplay="IpMacDisplay",
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

    if nil ~= data and nil ~= data["dhcps"] then
        print('hostipinterface come')
        local param = switchSetObjParamInputs(switchobjdomin, data["dhcps"], switchmaps)
        print('hostipinterface 2 come')
        local errcode, paramErrs = dm.SetObjToDB(switchobjdomin,param)
        print('hostipinterface errcode1', errcode)
    end
end


function guestnetworkinit()
    print("guestnetworkinit")
	if nil ~= data["guestnetwork"] and nil ~= data["guestnetwork"]["mode"] then
	    if "1" == data["guestnetwork"]["mode"] then
	        local Errcode, ParamErrs = dm.SetObjToDB("InternetGatewayDevice.X_GUESTNETWORK.", {{"GuestNetworkEnable", "1"}})
	        print("guestnetworkinit 1 err", Errcode)
	    else
		    local Errcode, ParamErrs = dm.SetObjToDB("InternetGatewayDevice.X_GUESTNETWORK.", {{"GuestNetworkEnable", "0"}})
	        print("guestnetworkinit 0 err", Errcode)
	    end
	end
end

function ipConflictEnableGet()
    print("ipConflictEnableGet")
	if nil ~= data["ipconflict"] and nil ~= data["ipconflict"]["conflictprocessenable"] then
	    if "1" == data["ipconflict"]["conflictprocessenable"] then
	        local Errcode, ParamErrs = dm.SetObjToDB("InternetGatewayDevice.Services.X_IPCONFLICT.", {{"IpConflictProcessEnable", "1"}})
	        print("ipConflictEnableGet 1 error ", Errcode)
	    else
		    local Errcode, ParamErrs = dm.SetObjToDB("InternetGatewayDevice.Services.X_IPCONFLICT.", {{"IpConflictProcessEnable", "0"}})
	        print("ipConflictEnableGet 0 error ", Errcode)
	    end
	end
end

function accessUIaddressGet()
	print("accessUIaddressGet")
	if nil ~= data["accessuiaddress"] and nil ~= data["accessuiaddress"]["enable"] then
		local Errcode, ParamErrs = dm.SetObjToDB("InternetGatewayDevice.Services.X_LANACCESSUIBYSECONDIP.", {{"LanAccessUIEnable", data["accessuiaddress"]["enable"]}, {"LanAccessUIAddress", data["accessuiaddress"]["ipaddress"]}})
		print("accessUIaddressGet",Errcode)
	end
end

function hgwulsplit()
	-- body
	local paraV
	local pos = nil
	local posinfo = nil
	local predomain = nil
	local lastdomain = nil
	local dnsmode = nil

	--before set dns, first set dns mode
	if nil == data["dhcps"] or nil == data["dhcps"]["dnsstatus"] then 
		dnsmode = "0"
	end
	
	if "0" == data["dhcps"]["dnsstatus"] then
		dnsmode = "2"
	end
	if "1" == data["dhcps"]["dnsstatus"] then
		dnsmode = "0"
	end
	if dnsmode ~= nil then
		local DNSModeErrcode, DNSModeParamErrs = dm.SetObjToDB("InternetGatewayDevice.Layer2Bridging.Bridge.1.", {{"X_DNSMode", dnsmode}})
		print("set dnsmode", errcode)
	end
	
	local dnsfirst = ''
	local dnssecond = ''
	local dnsall = ''
	if data["dhcps"]["primarydns"] ~= nil then
		if string.len(data["dhcps"]["primarydns"]) > 1 then
			dnsfirst = data["dhcps"]["primarydns"]
		end
	end
	if data["dhcps"]["secondarydns"] ~= nil then
		if string.len(data["dhcps"]["secondarydns"]) > 1 then
			dnssecond = data["dhcps"]["secondarydns"]
		end
	end
	
	if dnsfirst ~= '' and dnssecond ~= '' then
		dnsall = dnsfirst..','..dnssecond
	end
	
	if dnsfirst == '' then
		print("dnsfirst is = nill, will use defaule ...")
	end
	
	if dnssecond == '' and dnsfirst ~= '' then
		print("dnssecond is = nill, will use firest ...")
		dnsall = dnsfirst
	end
	
	print("dnsall is = ", dnsall)
	if string.len(dnsall) < 2 then
		if data["dhcps"]["ipaddress"] ~= nil and data["dhcps"]["ipaddress"] ~= '' then
			dnsall = data["dhcps"]["ipaddress"]
		end 
	end
	print("here dnsall is = ", dnsall)
	if string.len(dnsall) > 2 then
		local errcode, paramErrs = dm.SetObjToDB("InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.",
							{{"DNSServers", dnsall}})
		print('lanHost DNSServers', errcode)
	end
end

function  HostcreateSubmitData()
    -- body
    local switchobjdomin = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement."

    local switchparam = {}

        local switchmaps = {
            status="DHCPServerEnable",
            startip="MinAddress",
            endip="MaxAddress",
            leasetime="DHCPLeaseTime",
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

    if nil ~= data and nil ~= data["dhcps"] then
        print('lanHost come')
        local param = switchSetObjParamInputs(switchobjdomin, data["dhcps"], switchmaps)
        print('lanHost 2 come')
        local errcode, paramErrs = dm.SetObjToDB(switchobjdomin,param)
        print('lanHost errcode1', errcode)
        hgwulsplit()
    end
	
	if data["landns"] ~= nil and data["landns"]["dhcpoptionsuffix"] ~= nil then
	    print(data["landns"]["dhcpoptionsuffix"])
		domain = data["landns"]["dhcpoptionsuffix"]
        local param = {{"DomainName", domain}}
	    local errcode, paramErrs = dm.SetObjToDB("InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.", param)
	end	
    if data["landns"] ~= nil and data["landns"]["hgwurl"] ~= nil then
		print("hgwul = ", data["landns"]["hgwurl"])
		local param = {{"DeviceName", data["landns"]["hgwurl"]}} 
	    local errcode, paramErrs = dm.SetObjToDB("InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.", param)
    end
end

-- MACAddress 不可写，不能同步

-- dhcpsv6
function getdhcpv6UseAllocatedWAN(dhcpsv6mode)
	-- body
	local UseAllocatedwanValue = ""
	if dhcpsv6mode == "0" then
		UseAllocatedwanValue = "Normal"
	else
		UseAllocatedwanValue = "UseAllocatedSubnet"
	end
	return UseAllocatedwanValue
end


function  dhcpsv6createSubmitData()
    -- body
    local switchobjdomin = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_DHCPv6."

    local switchparam = {}

        local switchmaps = {
            status="DHCPServerEnable",
            mode="UseAllocatedWAN",
        }

    function switchSetObjParamInputs(switchobjdomin, data, switchmaps)
        local inputs = {}
        for k, v in pairs(switchmaps) do
            local param = {}
            if nil ~= data and nil ~= data[k] then
                param["key"] = v
                if v == "UseAllocatedWAN" then
                    param["value"] = getdhcpv6UseAllocatedWAN(data[k])
                else
                	param["value"] = data[k]
                end
                table.insert(inputs, param)
            end  
        end
        return inputs
    end

    if nil ~= data and nil ~= data["dhcpsv6"] then
        print('Dhcpv6errcode come')
        local param = switchSetObjParamInputs(switchobjdomin, data["dhcpsv6"], switchmaps)
        print('Dhcpv6errcode 2 come')
        local errcode, paramErrs = dm.SetObjToDB(switchobjdomin,param)
        print('Dhcpv6errcode errcode1', errcode)
    end
end

-- radvd
function getdradvdUseAllocatedWAN(radvdmode)
	-- body
	local UseAllocatedwanValue = ""
	if radvdmode == "0" then
		UseAllocatedwanValue = "Normal"
	else
		UseAllocatedwanValue = "UseAllocatedSubnet"
	end
	return UseAllocatedwanValue
end

function  radvdcreateSubmitData()
    -- body
    local switchobjdomin = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_SLAAC."

    local switchparam = {}

        local switchmaps = {
            status="RouterAdvertisementEnable",
            mode="UseAllocatedWAN",
        }

    function switchSetObjParamInputs(switchobjdomin, data, switchmaps)
        local inputs = {}
        for k, v in pairs(switchmaps) do
            local param = {}
            if nil ~= data and nil ~= data[k] then
                param["key"] = v
                if v == "UseAllocatedWAN" then
                    param["value"] = getdradvdUseAllocatedWAN(data[k])
                else
                	param["value"] = data[k]
                end
                table.insert(inputs, param)
            end  
        end
        return inputs
    end

    if nil ~= data and nil ~= data["radvd"] then
        print('radvderrcode come')
        local param = switchSetObjParamInputs(switchobjdomin, data["radvd"], switchmaps)
        print('radvderrcode 2 come')
        local errcode, paramErrs = dm.SetObjToDB(switchobjdomin,param)
        print('radvderrcode errcode1', errcode)
    end
end

function getUmtsInfo()
    for i = 1, 5 do
        local errcode, accessdevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice."..i..".WANCommonInterfaceConfig.", {"WANAccessType"})
        if nil ~= accessdevs then
            for k, v in pairs(accessdevs) do
                if "UMTS" == v["WANAccessType"] then
                    umtsWandomin = k
                    local start = string.find(umtsWandomin, ".WANCommonInterfaceConfig.")
                    if start then
                        umtsWandomin = string.sub(umtsWandomin, 0, start)
                    end
                    umtsWandomin = umtsWandomin.."WANConnectionDevice.1.WANPPPConnection.1"
                    return umtsWandomin
                end
            end

        end
   end
end

function getEthernetPPPInfo()
    for i = 1, 5 do
        local errcode, accessdevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice."..i..".WANCommonInterfaceConfig.", {"WANAccessType"})
        if nil ~= accessdevs then
            for k, v in pairs(accessdevs) do
                if "Ethernet" == v["WANAccessType"] then
                    EthernetWandomin = k
                    local start = string.find(EthernetWandomin, ".WANCommonInterfaceConfig.")
                    if start then
                        EthernetWandomin = string.sub(EthernetWandomin, 0, start)
                    end
                    EthernetWandomin = EthernetWandomin.."WANConnectionDevice.1.WANPPPConnection.1"
                    return EthernetWandomin
                end
            end

        end
   end
end

function getEthernetWiFiInfo()
    for i = 1, 5 do
        local errcode, accessdevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice."..i..".WANCommonInterfaceConfig.", {"WANAccessType"})
        if nil ~= accessdevs then
            for k, v in pairs(accessdevs) do
                if "WIFI" == v["WANAccessType"] then
                    EthernetWandomin = k
                    local start = string.find(EthernetWandomin, ".WANCommonInterfaceConfig.")
                    if start then
                        EthernetWandomin = string.sub(EthernetWandomin, 0, start)
                    end
                    EthernetWandomin = EthernetWandomin.."WANConnectionDevice.1.WANIPConnection.1"
                    return EthernetWandomin
                end
            end

        end
   end
end

function getEthernetInfo()
    for i = 1, 5 do
        local errcode, accessdevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice."..i..".WANCommonInterfaceConfig.", {"WANAccessType"})
        if nil ~= accessdevs then
            for k, v in pairs(accessdevs) do
                if "Ethernet" == v["WANAccessType"] then
                    EthernetWandomin = k
                    local start = string.find(EthernetWandomin, ".WANCommonInterfaceConfig.")
                    if start then
                        EthernetWandomin = string.sub(EthernetWandomin, 0, start)
                    end
                    EthernetWandomin = EthernetWandomin.."WANConnectionDevice.1.WANIPConnection.1"
                    return EthernetWandomin
                end
            end

        end
   end
end

function getclatvalue()
    local errcode, accessdevs = dm.GetParameterValues("InternetGatewayDevice.X_TRANSLATE.CLAT.", {"Enable"})
    print('getclatvalue for  CLAT error = ', errcode)
    if nil ~= accessdevs then
        for k, v in pairs(accessdevs) do
            if nil ~=  v["Enable"] then
                print('getclatvalue CLAT.Enable = ', v["Enable"])
                return v["Enable"]
            end
        end
    end
end

function clatsetvalue()
    -- body
    local Umtswanpath = getUmtsInfo()
    print('Umtswanpath = ', Umtswanpath)
    local Ethernetwanpath = getEthernetInfo()
    print('Ethernetwanpath = ', Ethernetwanpath)
    local EthernetPpppath = getEthernetPPPInfo()
    print('EthernetPpppath = ', EthernetPpppath)
    local Ethernetpppwanpath = {}
    local Ethernetipwanpath = {}
	
	if nil == data or nil == data["clat"]  then
		print('not data clat value')
		return
	end
	
	if nil ~= data["clat"]["dnsdetect"] then
	    if '' ~= data["clat"]["dnsdetect"] then
		    local errcode, paramErrs = dm.SetObjToDB("InternetGatewayDevice.X_TRANSLATE.CLAT.", {{"Domain", data["clat"]["dnsdetect"]}})
			print('clat dnsdetect errcode', errcode)
		end
	end
	
	if  nil == data["clat"]["clatUpType"] then
		print('not data clatUpType value')
		return
	end
	
    if nil ~= EthernetPpppath then
        Ethernetpppwanpath = EthernetPpppath.."."
        print('clatsetvalue Ethernetpppwanpath = ', Ethernetpppwanpath)
    end

    if nil ~= Ethernetwanpath then
        Ethernetipwanpath = Ethernetwanpath.."."
        print('clatsetvalue Ethernetipwanpath = ', Ethernetipwanpath)
    end
		
    local clatvalue = getclatvalue()
    print('clatsetvalue clatvalue = ', clatvalue)
         
    dm.AddObjectToDB("InternetGatewayDevice.X_TRANSLATE.CLAT.AssociatedWan.1.", {{"WanPath", " "}})
    dm.AddObjectToDB("InternetGatewayDevice.X_TRANSLATE.CLAT.AssociatedWan.2.", {{"WanPath", " "}})
    dm.AddObjectToDB("InternetGatewayDevice.X_TRANSLATE.CLAT.AssociatedWan.3.", {{"WanPath", " "}})

    local switchobjdominAssociatedWan1 = "InternetGatewayDevice.X_TRANSLATE.CLAT.AssociatedWan.1."
    local switchobjdominAssociatedWan2 = "InternetGatewayDevice.X_TRANSLATE.CLAT.AssociatedWan.2."
    local switchobjdominAssociatedWan3 = "InternetGatewayDevice.X_TRANSLATE.CLAT.AssociatedWan.3."
    
    if nil ~= data and nil ~= data["clat"] then
        if data["clat"]["clatUpType"] == '1' then
            local errcode, paramErrs = dm.SetObjToDB(switchobjdominAssociatedWan1,{{"WanPath", Umtswanpath}})
            print('clatUpType 1 Umtswanpath error = ', errcode)
        elseif data["clat"]["clatUpType"] == '2' then
            local errcode, paramErrs = dm.SetObjToDB(switchobjdominAssociatedWan1,{{"WanPath", Ethernetwanpath}})
            print('clatUpType 2 Ethernetwanpath error = ', errcode)
            local errcode, paramErrs = dm.SetObjToDB(switchobjdominAssociatedWan2,{{"WanPath", EthernetPpppath}})
            print('clatUpType 2 EthernetPpppath error = ', errcode)
            if clatvalue  then
                local errcode, paramErrs = dm.SetObjToDB(Ethernetipwanpath,{{"X_IPv4Enable", false}})
                print('clatUpType 2 Ethernetipwanpath X_IPv4Enable error = ', errcode)
                local errcode, paramErrs = dm.SetObjToDB(Ethernetpppwanpath,{{"X_IPv4Enable", false}})
                print('clatUpType 2 Ethernetpppwanpath X_IPv4Enable error = ', errcode)
                local errcode, paramErrs = dm.SetObjToDB(Ethernetipwanpath,{{"X_IPv6Enable", true}})
                print('clatUpType 2 Ethernetipwanpath X_IPv6Enable error = ', errcode)
                local errcode, paramErrs = dm.SetObjToDB(Ethernetpppwanpath,{{"X_IPv6Enable", true}})
                print('clatUpType 2 Ethernetpppwanpath X_IPv6Enable error = ', errcode)
            end
        elseif data["clat"]["clatUpType"] == '3' then
                local errcode, paramErrs = dm.SetObjToDB(switchobjdominAssociatedWan1,{{"WanPath", Umtswanpath}})
                print('clatUpType 3 Umtswanpath error = ', errcode)
                local errcode, paramErrs = dm.SetObjToDB(switchobjdominAssociatedWan2,{{"WanPath", Ethernetwanpath}})
                print('clatUpType 3 Ethernetwanpath error = ', errcode)
                local errcode, paramErrs = dm.SetObjToDB(switchobjdominAssociatedWan3,{{"WanPath", EthernetPpppath}})
                print('clatUpType 3 EthernetPpppath error = ', errcode)
                if clatvalue  then
                    local errcode, paramErrs = dm.SetObjToDB(Ethernetipwanpath,{{"X_IPv4Enable", false}})
                    print('clatUpType 3 Ethernetipwanpath X_IPv4Enable error = ', errcode)
                    local errcode, paramErrs = dm.SetObjToDB(Ethernetpppwanpath,{{"X_IPv4Enable", false}})
                    print('clatUpType 3 Ethernetpppwanpath X_IPv4Enable error = ', errcode)
                    local errcode, paramErrs = dm.SetObjToDB(Ethernetipwanpath,{{"X_IPv6Enable", true}})
                    print('clatUpType 3 Ethernetipwanpath X_IPv6Enable error = ', errcode)
                    local errcode, paramErrs = dm.SetObjToDB(Ethernetpppwanpath,{{"X_IPv6Enable", true}})
                    print('clatUpType 3 Ethernetpppwanpath X_IPv6Enable error = ', errcode)
                end
        else
            print("unavailable value")
        end
    end
    return true
end

function ethIpModeSetValue()

    local Ethernetwanpath = getEthernetInfo()
    print('Ethernetwanpath = ', Ethernetwanpath)
    local EthernetPpppath = getEthernetPPPInfo()
    print('EthernetPpppath = ', EthernetPpppath)
    local EthernetWiFipath = getEthernetWiFiInfo()
    print('EthernetWiFipath = ', EthernetWiFipath)
    local Ethernetpppwanpath = {}
    local Ethernetipwanpath = {}
    local EthernetwanpathWiFi = {}
	
    if nil ~= EthernetPpppath then
        Ethernetpppwanpath = EthernetPpppath.."."
        print('ethIpModeSetValue Ethernetpppwanpath = ', Ethernetpppwanpath)
        local errcode, paramErrs = dm.SetObjToDB(Ethernetpppwanpath,{{"X_IPv6Enable", true}})
        print("ethIpModeSetValue Ethernetpppwanpath X_IPv6Enable error = ", errcode)
        local errcode, paramErrs = dm.SetObjToDB(Ethernetpppwanpath,{{"X_IPv4Enable", true}})
        print("ethIpModeSetValue Ethernetpppwanpath X_IPv4Enable error = ", errcode)
    end

    if nil ~= Ethernetwanpath then
        Ethernetipwanpath = Ethernetwanpath.."."
        print('ethIpModeSetValue Ethernetipwanpath = ', Ethernetipwanpath)
        local errcode, paramErrs = dm.SetObjToDB(Ethernetipwanpath,{{"X_IPv6Enable", true}})
        print("ethIpModeSetValue Ethernetipwanpath X_IPv6Enable error = ", errcode)
        local errcode, paramErrs = dm.SetObjToDB(Ethernetipwanpath,{{"X_IPv4Enable", true}})
        print("ethIpModeSetValue Ethernetipwanpath X_IPv4Enable error = ", errcode)
    end
	
    if nil ~= EthernetWiFipath then
        EthernetwanpathWiFi = EthernetWiFipath.."."
        print('ethIpModeSetValue EthernetwanpathWiFi = ', EthernetwanpathWiFi)
        local errcode, paramErrs = dm.SetObjToDB(EthernetwanpathWiFi,{{"X_IPv6Enable", true}})
        print("ethIpModeSetValue EthernetwanpathWiFi X_IPv6Enable error = ", errcode)
        local errcode, paramErrs = dm.SetObjToDB(EthernetwanpathWiFi,{{"X_IPv4Enable", true}})
        print("ethIpModeSetValue EthernetwanpathWiFi X_IPv4Enable error = ", errcode)
    end	

end
-- ipmode add
function  ipmodesetvalue()
    -- body
    
    local switchobjdominmode = "InternetGatewayDevice.Services.X_IPv6."
    local switchobjdominclat = "InternetGatewayDevice.X_TRANSLATE.CLAT."
	
	if nil == data or nil == data["ipmodes"]  or nil == data["ipmodes"]["mode"] then
		print('no ipmodes value')
		return
	end
    print('start ipmodesetvalue......')
	
    if nil ~= data and nil ~= data["ipmodes"] then
        if data["ipmodes"]["mode"] == '0' then
            local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"Enable", false}})
            print('mode 0 for X_IPv6 error = ', errcode)
        elseif data["ipmodes"]["mode"] == '2' then
            local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"Enable", true}})
            print('mode 2 for X_IPv6 error = ', errcode)
            ethIpModeSetValue()
        elseif data["ipmodes"]["mode"] == '7' then
            local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"Enable", true}})
            print("mode 7 for X_IPv6 error ", errcode)
            local errcode, paramErrs = dm.SetObjToDB(switchobjdominclat,{{"Enable", true}})
            print("mode 7 for CLAT error ", errcode)
            clatsetvalue()
        else
            print("unavailable value")
        end
    end
    return true
end

-- doubleecm add
function  doubleecmsetvalue()
    -- body
    
    local switchobjdominmode = "InternetGatewayDevice.Services.X_DOUBLEECM."
    if nil == data or nil == data["doubleecm"]  or nil == data["doubleecm"]["enable"] then
		print('no doubleecm value')
		return
	end
    print('start doubleecmsetvalue......')
	
    if nil ~= data and nil ~= data["doubleecm"] then
        if data["doubleecm"]["enable"] == '0' then
            local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"DoubleECMEnable", false}})
            print('enable 0 for doubleecm error = ', errcode)
        elseif data["doubleecm"]["enable"] == '1' then
            local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"DoubleECMEnable", true}})
            print("enable 1 for doubleecm error ", errcode)
        else
            print("unavailable value")
        end
    end
    return true
end

function  dhcpsdnssettingdisplay()
    local dhcpsdnsdisplayobjdomin = "InternetGatewayDevice.Services.X_DHCPSDNSDISPLAY."
    if nil == data or nil == data["dhcps"]  or nil == data["dhcps"]["dnsdisplay"] then
		print('no dnsdisplay value')
		return
	end
    print('start dhcpsdnsdisplaysetvalue......')
	
    if nil ~= data and nil ~= data["dhcps"] then
        if data["dhcps"]["dnsdisplay"] == '0' then
            local errcode, paramErrs = dm.SetObjToDB(dhcpsdnsdisplayobjdomin,{{"Enable", false}})
            print('enable 0 for dhcpsdnsdisplay error = ', errcode)
        elseif data["dhcps"]["dnsdisplay"] == '1' then
            local errcode, paramErrs = dm.SetObjToDB(dhcpsdnsdisplayobjdomin,{{"Enable", true}})
            print("enable 1 for dhcpsdnsdisplay error ", errcode)
        else
            print("unavailable value")
        end
    end
end

function  dhcps_ipallconfig_display()
    local ipconfig_displayobjdomin = "InternetGatewayDevice.Services.X_DHCPSIPALLCONFIGDISPLAY."
    if nil == data or nil == data["dhcps"]  or nil == data["dhcps"]["dhcps_ipallconfig_display"] then
		print('no dhcps_ipallconfig_display value')
		return
	end    
    print('start dhcps_ipallconfig_displaysetvalue......')
	
    if nil ~= data and nil ~= data["dhcps"] then
        if data["dhcps"]["dhcps_ipallconfig_display"] == '0' then
            local errcode, paramErrs = dm.SetObjToDB(ipconfig_displayobjdomin,{{"Enable", false}})
            print('enable 0 for dhcps_ipallconfig_display error = ', errcode)
        elseif data["dhcps"]["dhcps_ipallconfig_display"] == '1' then
            local errcode, paramErrs = dm.SetObjToDB(ipconfig_displayobjdomin,{{"Enable", true}})
            print("enable 1 for dhcps_ipallconfig_display error ", errcode)
        else
            print("unavailable value for dhcps_ipallconfig_display")
        end
    end
end

-- IPinterface set
lancreateSubmitData()
-- dhcps info 
HostcreateSubmitData()
--- dns display
dhcpsdnssettingdisplay()
--- dhcps all ipconfig display
dhcps_ipallconfig_display()
-- guestnetwork
guestnetworkinit()
-- ip conflict
ipConflictEnableGet()
--- for secondry ip
accessUIaddressGet()
-- dhcp6s info
dhcpsv6createSubmitData()
-- radvd info
radvdcreateSubmitData()
-- ipmode
ipmodesetvalue()
--- double ecm
doubleecmsetvalue()

print("lan config is ok..........")
