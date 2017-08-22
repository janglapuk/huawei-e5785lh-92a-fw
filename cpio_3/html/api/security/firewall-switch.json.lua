require('dm')
require('web')
require('json')
require('utils')
require('table')



local errcode, objs = dm.GetParameterValues("InternetGatewayDevice.X_FireWall.Switch.",
    {   "FirewallMainSwitch",
    	"FirewallIPFilterSwitch",
        "FirewallWanPortPingSwitch",
        "firewallmacfilterswitch",
        "firewallurlfilterswitch"
    });
local switchitem = {}
for k,v in pairs(objs) do  
    switchitem["FirewallMainSwitch"] = v["FirewallMainSwitch"]
    switchitem["FirewallIPFilterSwitch"] = v["FirewallIPFilterSwitch"]
    switchitem["FirewallWanPortPingSwitch"] = v["FirewallWanPortPingSwitch"]
    switchitem["firewallmacfilterswitch"] = v["firewallmacfilterswitch"]
    switchitem["firewallurlfilterswitch"] = v["firewallurlfilterswitch"]
end
print(json.xmlencode(switchitem))
sys.print(json.xmlencode(switchitem))
