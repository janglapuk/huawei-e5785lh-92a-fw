local utils = require('utils')
require('dm')
require('web')
require('json')
require('utils')
require('dm')
local string = string
local print = print

local maps = {  
        FirewallMainSwitch="FirewallMainSwitch",
    	FirewallIPFilterSwitch="FirewallIPFilterSwitch",
        FirewallWanPortPingSwitch="FirewallWanPortPingSwitch",
        firewallmacfilterswitch="firewallmacfilterswitch",
        firewallurlfilterswitch= "firewallurlfilterswitch"
}

local domain = "InternetGatewayDevice.X_FireWall.Switch."


local param = utils.GenSetObjParamInputs(domain, data, maps)

local err,needreboot, paramerror = dm.SetParameterValues(param);

if err ~= 0 then
        utils.xmlappenderror(err)
end	

--utils.utils.xmlresponseErrorcode(err, paramerror, maps)

