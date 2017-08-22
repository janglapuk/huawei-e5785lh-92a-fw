local utils = require('utils')
require('dm')
local string = string
local print = print
local err_code = 0
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

local maps = {
    Index = "HostIndex",
    Enable = "Enable",
    Chaddr="HostHw",
    Yiaddr = "HostIp",
}
local hostArray = data["Hosts"]
local index = 1
local id = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.DHCPStaticAddress."
local param = {}

function delete(id)
    dm.DeleteObject(id)
end

function insert(index, host)
    inputs = {
        {"Chaddr", host.HostHw},
        {"Yiaddr", host.HostIp},
        {"Enable", "1"},
    }
    local errcode, instId, needreboot, errs = dm.AddObjectWithValues(id, inputs)
    return errcode
end

function doAddParam(hosts)
    local errcode, dhcpConf = dm.GetParameterValues("InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.DHCPStaticAddress.{i}.",
        {
            "Enable",
            "Chaddr",
            "Yiaddr",
        }
    )

    if "" ~= dhcpConf then
	    for k, v in pairs(dhcpConf) do 
	        delete(k)
	    end
	end

    if "" ~= hosts then
	    for k, v in pairs(hosts) do
	       errcode = insert(k, v)
	       if errcode ~= 0 then
                    err_code = errcode
                    return errcode
               end
	    end
	end
end

doAddParam(hostArray)
utils.xmlappenderror(err_code)