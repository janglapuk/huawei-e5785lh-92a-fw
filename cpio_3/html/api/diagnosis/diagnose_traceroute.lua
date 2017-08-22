local utils = require('utils')

if nil == data then
    return
end

function genSingleObject(obj, maps)
    local singleObj = {}
    if nil ~= maps then
        for kr, vd in pairs(maps) do
            singleObj[kr] = obj[vd]
        end
    end
    return singleObj
end

function responseSingleObject(obj, maps)
    return sys.print(json.xmlencode(genSingleObject(obj, maps)))
end
local maps = {
	DiagnosticsState="DiagnosticsState",
	Host="Host",
	MaxHopCount="MaxHopCount",
	Timeout = "Timeout"
}

local	domain = "InternetGatewayDevice.TraceRouteDiagnostics."
data["Interface"] = ""
data["DiagnosticsState"] = "Requested"

local param = utils.GenSetObjParamInputs(domain, data, maps)

local err,needreboot, paramerror = dm.SetParameterValues(param);
utils.utils.xmlresponseErrorcode(err, paramerror, maps)