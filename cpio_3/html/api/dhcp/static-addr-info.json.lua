require('dm')
require('json')
require('utils')
local Hosts = {}
local response = {}

--IpMacDisplay Data nodes  "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.1.IpMacDisplay"
--------------------check the status of IpMacDisplay switch--------------------
local errcode,IpMacDisplay= dm.GetParameterValues("InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.1.",
        {"IpMacDisplay"})

if utils.toboolean(IpMacDisplay["InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.1."]["IpMacDisplay"]) then
--print("IpMacDisplay is on")
else
--print("IpMacDisplay is off")
	local response = {}
	response.code = 100002
	response.message = ""
	sys.print(json.xmlencode(response,"error"))
	return	false
end

local errcode, dhcpConf = dm.GetParameterValues("InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.DHCPStaticAddress.{i}.",
    {
        "Enable",
        "Chaddr",
        "Yiaddr",
    }
)

function get_index_by_key(key)
    local index = string.match(key, "%d+")
	if(nil == index) then
		return nil
	else
		return index
	end
end

for k, v in pairs(dhcpConf) do
	local Host = {}
	Host.HostIndex = get_index_by_key(k)
	if(nil == Host.HostIndex) then
		return sys.print(json.xmlencode("error"))
	end
	Host.ID = k
	Host.HostEnabled = v["Enable"]
	Host.HostHw = v["Chaddr"]
	Host.HostIp = v["Yiaddr"]
	table.insert(Hosts, Host)
end

utils.multiObjSortByID(Hosts)
response.Hosts = Hosts
sys.print(json.xmlencode(response))