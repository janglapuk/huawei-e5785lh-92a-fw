require('dm')
require('web')
require('json')
require('utils')
require('table')

local errcode, values = dm.GetParameterValues("InternetGatewayDevice.Layer3Forwarding.X_IPv6Forwarding.{i}.",
    {
        "SrcIPAddress",
        "PrefixLength",
        "DestIPAddress",
        "GatewayIPAddress",
        "Interface",
    }
)

function get_br_alia_name(interface)
    local i, j = string.find(interface, "InternetGatewayDevice.WANDevice")
    if 1 == i and 0 < j then
        return interface
    end

    local errcode, bridges = dm.GetParameterValues("InternetGatewayDevice.Layer2Bridging.Bridge.{i}.", {"BridgeName", "BridgeKey"})
    for k, v in pairs(bridges) do 
        if "br"..v["BridgeKey"] == interface then
            return v["BridgeName"]
        end
    end

    return interface

end

local response = {}
local routes = {}
if values ~= nil then
    for k,v in pairs(values) do
        local route = {}
        route.ID = k
        route.DestIPAddress = v["DestIPAddress"]
        route.PrefixLength = v["PrefixLength"]
        route.GatewayIPAddress = v["GatewayIPAddress"]
        route.SrcIPAddress = v["SrcIPAddress"]
        route.Interface = get_br_alia_name(v["Interface"])

        table.insert(routes, route)    
    end
end
utils.multiObjSortByID(routes)
response.routes = routes
print(json.xmlencode(response))
sys.print(json.xmlencode(response))