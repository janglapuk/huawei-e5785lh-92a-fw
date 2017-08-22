require('dm')
require('utils')

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
	NumberOfRepetitions = "NumberOfRepetitions",
	DataBlockSize = "DataBlockSize",
	SuccessCount = "SuccessCount",
	FailureCount = "FailureCount",
	AverageResponseTime = "AverageResponseTime",
	MinimumResponseTime = "MinimumResponseTime",
	MaximumResponseTime = "MaximumResponseTime",
	Host = "Host",
	Result = "Result",
	Reply = "Reply",
}

local errcode,values = dm.GetParameterValues("InternetGatewayDevice.IPPingDiagnostics.", maps)

local obj = values["InternetGatewayDevice.IPPingDiagnostics."]

utils.responseSingleObject(obj, maps)