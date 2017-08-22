require('dm')
require('web')
require('json')
require('utils')
require('table')

local tostring = tostring

local errcode, lanVals = dm.GetParameterValues("InternetGatewayDevice.Layer2Bridging.AvailableInterface.{i}.", {"InterfaceReference", "X_InterfaceAlias"})


local response = {}
local lanifs = {}

function add_lanif_lanname(lanname)
    for k,v in pairs(lanVals) do
        if v["X_InterfaceAlias"] == lanname then
           local lanif = {}
           lanif.id = v["InterfaceReference"]
           lanif.lanif = lanname
           table.insert(lanifs, lanif)
           return
        end
    end
end

function add_ssid_by_dm(domain_prefix)
    local domain = domain_prefix.."."
    local errcode, values = dm.GetParameterValues(domain, { "SSID","Enable" });
    if values ~= nil then
        local obj
        obj = values[domain]
        if 1 == obj["Enable"] and '' ~= obj["SSID"] then
            local lanif = {}
            lanif.id = domain_prefix
            lanif.lanif = obj["SSID"]
            table.insert(lanifs, lanif)
        end
    end
end


local landev1 = 0
local landev2 = 0
--InternetGatewayDevice.LANDevice.1.WLANConfiguration.1
function add_ssid_by_wifi(domain_prefix,radio,index)
    local domain = domain_prefix.."Ssid."..index.."."
    local Landomain
    local errcode,wifissid = dm.GetParameterValues(domain, {"Index","SSID","IsGuestNetwork"})
        if wifissid ~= nil then
            for k,v in pairs(wifissid) do
                local lanif = {}
                if 1 == radio  then
                    if 0 == v["IsGuestNetwork"] then
                        landev1 = landev1 + 1
                        Landomain = "InternetGatewayDevice.LANDevice.1.WLANConfiguration."..landev1
                    else
                        landev2 = landev2 + 1
                        Landomain = "InternetGatewayDevice.LANDevice.2.WLANConfiguration."..landev2
                    end
                    elseif  2 == radio then
                        if 0 == v["IsGuestNetwork"] then
                            landev1 = landev1 + 1
                            Landomain = "InternetGatewayDevice.LANDevice.1.WLANConfiguration."..landev1
                        else
                            landev2 = landev2 + 1
                            Landomain = "InternetGatewayDevice.LANDevice.2.WLANConfiguration."..landev2
                        end
                    end
            lanif.id = Landomain
            lanif.lanif = v["SSID"]
            table.insert(lanifs, lanif)
        end
    end
end


function add_eth_by_dm(domain_prefix,name)
    local domain = domain_prefix.."."
    local errcode, values = dm.GetParameterValues(domain, { "Status" });
    if values ~= nil then
        local obj
        local lanif = {}
        obj = values[domain]
        lanif.id = domain_prefix
        lanif.lanif = name
        table.insert(lanifs, lanif)
    end
end

-- LAN1
--add_lanif_lanname("LAN1")

-- LAN2
add_eth_by_dm("InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.1","LAN1")
add_eth_by_dm("InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.2","LAN2")


-- LAN3
--add_lanif_lanname("LAN3")

-- LAN4
--add_lanif_lanname("LAN4")

--add_ssid_by_dm("InternetGatewayDevice.LANDevice.1.WLANConfiguration.1")
--add_ssid_by_dm("InternetGatewayDevice.LANDevice.1.WLANConfiguration.2")
--add_ssid_by_dm("InternetGatewayDevice.LANDevice.1.WLANConfiguration.3")
--add_ssid_by_dm("InternetGatewayDevice.LANDevice.1.WLANConfiguration.4")
--add_ssid_by_dm("InternetGatewayDevice.LANDevice.2.WLANConfiguration.1")
--add_ssid_by_dm("InternetGatewayDevice.LANDevice.2.WLANConfiguration.2")




add_ssid_by_wifi("InternetGatewayDevice.X_Config.Wifi.Radio.1.",1,1)
add_ssid_by_wifi("InternetGatewayDevice.X_Config.Wifi.Radio.1.",1,2)
add_ssid_by_wifi("InternetGatewayDevice.X_Config.Wifi.Radio.2.",2,1)
add_ssid_by_wifi("InternetGatewayDevice.X_Config.Wifi.Radio.2.",2,2)



response.lanifs = lanifs

print(json.xmlencode(response))
sys.print(json.xmlencode(response))

