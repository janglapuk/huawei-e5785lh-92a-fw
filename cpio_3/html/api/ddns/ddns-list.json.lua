require('dm')
require('web')
require('json')
require('utils')
local tostring = tostring

--------------------check the status of ddns display switch--------------------
local errcode,SwitchValues= dm.GetParameterValues("InternetGatewayDevice.X_Config.global.",
        {"ddnsenable"})

if utils.toboolean(SwitchValues["InternetGatewayDevice.X_Config.global."]["ddnsenable"]) then
--print("Ddns Display Switch is on")
else
--print("Ddns Display Switch is off")
	local response = {}
	response.code = 100002
	response.message = ""
	sys.print(json.xmlencode(response,"error"))
	return	false
end

local errcode,values= dm.GetParameterValues("InternetGatewayDevice.Services.X_DDNSConfiguration.{i}.",
        {"Enable", "Provider", "Server", "ServicePort", "Protocol", "Username", "Password", "DomainName", "HostName", "WanPath"
-- 
--        , "Status"
--
        })

local ddns_list = {}
if 0 == errcode and values then
	for k,v in pairs(values) do
		local _, idx = string.find(k, "InternetGatewayDevice.Services.X_DDNSConfiguration.")
		local index = string.sub(k, idx + 1, -2)
		local provider   = v["Provider"]
		local hostName   = v["HostName"]
		local domainName = v["DomainName"]
		
		local ddns = {}
		ddns.index      = index
		ddns.provider   = provider
		ddns.status     = v["Enable"]
		ddns.domainname = hostName.."."..domainName
		ddns.username   = v["Username"]
		ddns.password   = "********"

		table.insert(ddns_list, ddns)
	end
end

local response = {}
response.ddnss = ddns_list
sys.print(json.xmlencode(response))

