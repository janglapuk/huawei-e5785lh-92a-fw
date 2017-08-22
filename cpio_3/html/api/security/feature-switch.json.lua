require('dm')
require('json')
require('utils')
require('sys')

--ipfilterWhiteList display Switch Data nodes "InternetGatewayDevice.X_Config.firewall.WhiteListDisplay"
--Ipv6Enable display Switch Data nodes "InternetGatewayDevice.X_Config.firewall.Ipv6Enable"
--UrlWhiteList display Switch Data nodes "InternetGatewayDevice.X_Config.firewall.UrlWhiteListDisplay"
--------------------check the display switch--------------------
local errcode,IpfltWLDispSwitchValues= dm.GetParameterValues("InternetGatewayDevice.X_Config.firewall.",
        {"WhiteListDisplay"})
local errcode,Ipv6EnDispSwitchValues= dm.GetParameterValues("InternetGatewayDevice.X_Config.firewall.",
        {"Ipv6Enable"})
local errcode,UrlfltWLDispSwitchValues= dm.GetParameterValues("InternetGatewayDevice.X_Config.firewall.",
        {"UrlWhiteListDisplay"})
		
if utils.toboolean(IpfltWLDispSwitchValues["InternetGatewayDevice.X_Config.firewall."]["WhiteListDisplay"]) 
   or utils.toboolean(Ipv6EnDispSwitchValues["InternetGatewayDevice.X_Config.firewall."]["Ipv6Enable"]) 
   or utils.toboolean(UrlfltWLDispSwitchValues["InternetGatewayDevice.X_Config.firewall."]["UrlWhiteListDisplay"]) then
--print("Firewall WhiteList and IPV6 display Switch is on")
else
--print("Firewall WhiteList and IPV6 display Switch is off")
	local response = {}
	response.code = 100002
	response.message = ""
	sys.print(json.xmlencode(response,"error"))
	return	false
end

local errcode,val= dm.GetParameterValues("InternetGatewayDevice.X_Config.firewall.", {"WhiteListDisplay", "Ipv6Enable", "UrlWhiteListDisplay"})

local obj = {}

obj.whitelist_display = val["InternetGatewayDevice.X_Config.firewall."]["WhiteListDisplay"]
obj.url_whitelist_display = val["InternetGatewayDevice.X_Config.firewall."]["UrlWhiteListDisplay"]
obj.ipv6_enable = val["InternetGatewayDevice.X_Config.firewall."]["Ipv6Enable"]

local errcode,val= dm.GetParameterValues("InternetGatewayDevice.X_Config.upnp.", {"upnp_portmapping_display"})
obj.upnp_portmapping_display = val["InternetGatewayDevice.X_Config.upnp."]["upnp_portmapping_display"]
sys.print(json.xmlencode(obj))