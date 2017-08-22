local web       = require("web")
local json      = require("json")
local utils     = require('utils')

-- 如果voip开关是关的，则不能响应restful接口
local errcode,values= dm.GetParameterValues("X_Config.global.",{"voipenable"})
obj = values["X_Config.global."];

print("voipenable "..obj["voipenable"])

if obj["voipenable"] == 0 then
    utils.xmlappenderror("100003")
    return
end

local response = {}
local errcode, service_values = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.", {"X_SpecialCharEnable"});
local index = 0
if nil ~= service_values then
    for id, serviceinfo in pairs(service_values) do
        response.specialcharenable = serviceinfo["X_SpecialCharEnable"]
    end
end

sys.print(json.xmlencode(response))

