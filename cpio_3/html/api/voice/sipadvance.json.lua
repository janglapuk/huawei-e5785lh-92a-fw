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
response.callwaitingenable = 1

local errcode, line_values = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.", {"Enable"});

if nil ~= line_values then
    response.callwaitingenable = 0
    for id, lineinfo in pairs(line_values) do
        local errcode,each_line = dm.GetParameterValues(id.."CallingFeatures.", {"CallWaitingEnable"});
        if errcode ~= 0 then
			print("!!! errcode "..errcode)
			break
		end
		local each_line_obj = each_line[id.."CallingFeatures."]
		if each_line_obj["CallWaitingEnable"] == 1 then
            response.callwaitingenable = 1
            break
        end
    end
end

sys.print(json.xmlencode(response))

