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
        {"Status","Enable"})

local ddns_list = {}

local bFound = false;
if 0 == errcode and values then
    for k,v in pairs(values) do
        local _, idx = string.find(k, "InternetGatewayDevice.Services.X_DDNSConfiguration.")
		local index = string.sub(k, idx + 1, -2)
		
		local ddns = {}
		ddns.index = index

		if 0 == v["Enable"] then
		    ddns.status = 0
		elseif "Synchronizing" == v["Status"] then
		    ddns.status = 3
		elseif "Failed to synchronize" == v["Status"] then
			ddns.status = -7
		elseif "Synchronized" == v["Status"] then
			ddns.status = 1
		end
		
		table.insert(ddns_list, ddns)
    end
end

local response = {}
response.ddnss = ddns_list
sys.print(json.xmlencode(response))

