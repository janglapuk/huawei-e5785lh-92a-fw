local utils = require('utils')
local web = require('web')
local sys = require('sys')

local domain = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.1."

local domainpool = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement."

local dnsmode = "InternetGatewayDevice.Layer2Bridging.Bridge.1."

local firstipChg = false
local dhcppoolChg = false
-- invalid value 6
local dnsmodeflag = '6'

local needreboot = false
local errcode, ipObject = dm.GetParameterValues(domain,{"IPInterfaceIPAddress"})

if nil == data then
	return
end


if nil ~= data["DhcpIPAddress"] and ipObject[domain]["IPInterfaceIPAddress"] ~= data["DhcpIPAddress"] then
	needreboot = true
	firstipChg = true
end
if nil ~= data["DhcpLanNetmask"] and ipObject[domain]["IPInterfaceSubnetMask"] ~= data["DhcpLanNetmask"] then
	needreboot = true
	firstipChg = true
end

local errcode, ippoolObject = dm.GetParameterValues(domainpool,{"MinAddress", "MaxAddress", "DHCPLeaseTime", "DHCPServerEnable", "DNSServers"});

if (ippoolObject[domainpool]["MinAddress"] ~= data["DhcpStartIPAddress"] and nil ~= data["DhcpStartIPAddress"]) or (nil ~= data["DhcpEndIPAddress"] and ippoolObject[domainpool]["MaxAddress"] ~= data["DhcpEndIPAddress"]) 
	or (nil ~= data["DhcpLeaseTime"] and ippoolObject[domainpool]["DHCPLeaseTime"] ~= data["DhcpLeaseTime"]) or (nil ~= data["DhcpStatus"] and ippoolObject[domainpool]["DHCPServerEnable"] ~= data["DhcpStatus"]) 
	or (nil ~= data["DnsStatus"]) then
	dhcppoolChg = true
end

if nil ~= dnsmode then
	local errcode, dnsmodeObject = dm.GetParameterValues(dnsmode,{"X_DNSMode"})
	dnsmodeflag = dnsmodeObject[dnsmode]["X_DNSMode"]
end

function setDnsMode(modeflag)
	local mode = {}
	
	if nil ~= dnsmode then
		local errcode, paramErrs = dm.SetObjToDB(dnsmode,{{"X_DNSMode", modeflag}})
		print("set dns mode result...", modeflag, errcode)
	end
    return
end

function DnsParamChangeCheck()
	
    local Tmpspos = 0
    local Tmpepos = 0
	local PriDns = ''
	local SecDns = ''
    Tmpspos,Tmpepos = string.find(ippoolObject[domainpool]['DNSServers'],',')
    if 0 ~= Tmpspos then
        PriDns = string.sub(ippoolObject[domainpool]['DNSServers'],1,Tmpspos-1)
        SecDns = string.sub(ippoolObject[domainpool]['DNSServers'],Tmpspos+1)
    else
        PriDns = ippoolObject[domainpool]['DNSServers']
        SecDns = ''
    end
	if PriDns == data["PrimaryDns"] and SecDns == data["SecondaryDns"] then
		print("dns param equal, not set dns servers ...")
		return 9003
	end
    return 0	
end

function DnsServerParamCheck()
	
	if nil == data["DnsStatus"] or '' == data["DnsStatus"] then
		return 9003
	end
	
	if '0' ~= data["DnsStatus"] and '1' ~= data["DnsStatus"] then
	    return 9003
	end

	if nil ~= data["PrimaryDns"] and data["PrimaryDns"] == "0.0.0.0" then
		return 9003
	end
	
	if nil ~= data["SecondaryDns"] then
	    if data["SecondaryDns"] == "0.0.0.0" then
			return 9003
		end
		
		if '' == data["PrimaryDns"] then
			return 9003
		end
	end
	
    return 0	
end

function setIpAddress()
	local ipparas = {}
	if nil ~= domain then
		if nil ~= data["DhcpIPAddress"] then
			utils.add_one_parameter(ipparas, domain.."IPInterfaceIPAddress", data["DhcpIPAddress"])
		end
		if nil ~= data["DhcpLanNetmask"] then
			utils.add_one_parameter(ipparas, domain.."IPInterfaceSubnetMask", data["DhcpLanNetmask"])
		end		
	end
    local errcode, NeedReboot, paramerr =  dm.SetParameterValues(ipparas)
    print("set ip first result...",errcode)
    return errcode
end

function setIpAddressBak()
	local ipparas = {}
	if nil ~= ipObject[domain]["IPInterfaceIPAddress"] then
		utils.add_one_parameter(ipparas, domain.."IPInterfaceIPAddress", ipObject[domain]["IPInterfaceIPAddress"])
	end
	if nil ~= ipObject[domain]["IPInterfaceSubnetMask"] then
		utils.add_one_parameter(ipparas, domain.."IPInterfaceSubnetMask", ipObject[domain]["IPInterfaceSubnetMask"])
	end		
	local errcode, NeedReboot, paramerr =  dm.SetParameterValues(ipparas)
	print("raw back set ip first result...",errcode)
	return errcode
end

function SetDHCPpool()
	local paras = {}
	local domain = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement."
	local dnsservers
	if nil ~= domain then
		utils.add_one_parameter(paras, domain.."DHCPServerEnable", utils.toboolean(data["DhcpStatus"]))
		utils.add_one_parameter(paras, domain.."MinAddress", data["DhcpStartIPAddress"])
		utils.add_one_parameter(paras, domain.."MaxAddress", data["DhcpEndIPAddress"])
		utils.add_one_parameter(paras, domain.."DHCPLeaseTime", data["DhcpLeaseTime"])
	end
	local err = DnsServerParamCheck()
	if err == 0  then
		if nil ~= domainpool and nil ~= data["PrimaryDns"] then
			dnsservers = data["PrimaryDns"]
			if nil ~= data["SecondaryDns"] then
				dnsservers = data["PrimaryDns"]..","..data["SecondaryDns"]
			end
				
			--需要先配置模式为静态,才可以进行dnsserver节点配置,配置之后再刷新模式
			if '2' ~= dnsmodeflag then
				setDnsMode('2')
			end
			--dns changed
			local errcode = DnsParamChangeCheck()
			if errcode == 0  then
				utils.add_one_parameter(paras, domainpool.."DNSServers", dnsservers)
			end			            
		end	
	end
	local errcode, NeedReboot, paramerr =  dm.SetParameterValues(paras)	
	
	if '1' == data["DnsStatus"] then
		--dynamic dns
		setDnsMode('0')
		print("====set dns to dynamic")
	end	
	print("set pool second..",errcode)
	return errcode
end

function update()
	local res
	local res2
	if firstipChg == true then
 		res =  setIpAddress()
 	end
	if res ~= 0 then
 		return res
	end
 	if dhcppoolChg == true then
 		res =  SetDHCPpool()
 	end
	if res ~= 0 then
	    print("will raw back set ip first result...")
	    res2 =  setIpAddressBak()
	end
 	return res
end

local errcode = update()

if errcode == 0 and needreboot == true then
	--sys.rebootdevice()
end

if errcode ~= 0 then
    utils.xmlappenderror(errcode)
    return
end
