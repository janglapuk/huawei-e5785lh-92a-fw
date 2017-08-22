local json = require('json')

local domain = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement."
local errcode, getObject = dm.GetParameterValues(domain,{"DHCPServerEnable","MinAddress","MaxAddress","DHCPLeaseTime","DNSServers"})
local dhcpssettingObject = getObject[domain]

local response = {}
response["DhcpStatus"] = dhcpssettingObject['DHCPServerEnable']
response["DhcpStartIPAddress"] = dhcpssettingObject['MinAddress']
response["DhcpEndIPAddress"] = dhcpssettingObject['MaxAddress']
response["DhcpLeaseTime"] = dhcpssettingObject['DHCPLeaseTime']

local Tmpspos = 0
local Tmpepos = 0
Tmpspos,Tmpepos = string.find(dhcpssettingObject['DNSServers'],',')

if nil ~= Tmpspos then
    if 0 ~= Tmpspos then
        response["PrimaryDns"] = string.sub(dhcpssettingObject['DNSServers'],1,Tmpspos-1)
        response["SecondaryDns"] = string.sub(dhcpssettingObject['DNSServers'],Tmpspos+1)
    else
        response["PrimaryDns"] = dhcpssettingObject['DNSServers']
        response["SecondaryDns"] = ''
    end
else
    response["PrimaryDns"] = dhcpssettingObject['DNSServers']
    response["SecondaryDns"] = ''
end

local domain = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.1."
local errcode, getObject = dm.GetParameterValues(domain,{"IPInterfaceIPAddress","IPInterfaceSubnetMask"})

local ipinterfacesettingObject = getObject[domain]

response["DhcpIPAddress"] = ipinterfacesettingObject['IPInterfaceIPAddress']
response["DhcpLanNetmask"] = ipinterfacesettingObject['IPInterfaceSubnetMask']

local domain1 = "InternetGatewayDevice.LANDevice.2.LANHostConfigManagement.IPInterface.1."
local errcode1, getObject1 = dm.GetParameterValues(domain1,{"IPInterfaceIPAddress","IPInterfaceSubnetMask"})

if errcode1 == 0 then 
    local ipinterfacesettingObject1 = getObject1[domain1]
    response["guestipaddress"] = ipinterfacesettingObject1['IPInterfaceIPAddress']
end

local dnsmode = "InternetGatewayDevice.Layer2Bridging.Bridge.1."
local errcode2, getObject2 = dm.GetParameterValues(dnsmode,{"X_DNSMode"})

if errcode2 == 0 then 
    local ipinterfacesettingObject2 = getObject2[dnsmode]
    if 2 == ipinterfacesettingObject2['X_DNSMode'] then
	response["DnsStatus"] = '0'
	else
	response["DnsStatus"] = '1'
	end
end

local domain2 = "InternetGatewayDevice.Services.X_LANACCESSUIBYSECONDIP."

local errcode3, getObject3 = dm.GetParameterValues(domain2,{"LanAccessUIEnable", "LanAccessUIAddress"})
if errcode3 == 0 then
    if 1 ==  getObject3[domain2]['LanAccessUIEnable'] then
	    response["accessipaddress"] = getObject3[domain2]['LanAccessUIAddress']
	end
else
	response["accessipaddress"] = ""
end
sys.print(json.xmlencode(response))
