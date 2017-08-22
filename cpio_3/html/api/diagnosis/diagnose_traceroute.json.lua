require('dm')
require('utils')
local tonumber = tonumber

function genSingleObject(obj, maps)
    local singleObj = {}
    for kr, vd in pairs(maps) do
        singleObj[kr] = obj[vd]
    end
    return singleObj
end

function responseSingleObject(obj, maps)
    return sys.print(json.xmlencode(genSingleObject(obj, maps)))
end
local maps = {
	DiagnosticsState="DiagnosticsState",
	Host = "Host",
	ResponseTime = "ResponseTime",
	RouteHopsNumberOfEntries = "RouteHopsNumberOfEntries",
	Result = "Result"
}

local errcode,values = dm.GetParameterValues("InternetGatewayDevice.TraceRouteDiagnostics.", maps)


local obj = values["InternetGatewayDevice.TraceRouteDiagnostics."]

local hopmaps = {
	HopHost="HopHost",
	HopHostAddress="HopHostAddress",
	HopErrorCode="HopErrorCode",
	HopRTTimes="HopRTTimes"	
}
local errcode, values = dm.GetParameterValues("InternetGatewayDevice.TraceRouteDiagnostics.RouteHops.{i}.", hopmaps)

function findLastPoint(domain)
    local start = 1
    local pos = nil
    local predomain = nil
    local lastdomain = nil

    while true do
        ip,fp = string.find(domain, "%.", start)
        if not ip then break end
        predomain = string.sub(domain, start, ip-1)
        pos = ip
        start = fp + 1
    end
    
    if pos ~= nil then
        lastdomain = string.sub(domain, pos + 1)
    end

    return predomain, lastdomain, pos
end

obj.RouteHops = {}
if values ~= nil then
	for k, v in pairs(values) do
		local newObj = {}
		inst = utils.findLastPoint(k)
		newObj["ID"] = inst
		for kr, vd in pairs(hopmaps) do
			newObj[kr] = v[vd]
		end 
		obj.RouteHops[tonumber(inst)] = newObj
	end
end

local maps = {
	DiagnosticsState="DiagnosticsState",
	Host = "Host",
	ResponseTime = "ResponseTime",
	RouteHopsNumberOfEntries = "RouteHopsNumberOfEntries",
	RouteHops = "RouteHops",
	Result = "Result"
}
utils.responseSingleObject(obj, maps)
