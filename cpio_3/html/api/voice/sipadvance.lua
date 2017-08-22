require('web')
require('dm')
local utils = require('utils')

-- 如果voip开关是关的，则不能响应restful接口
local errcode,values= dm.GetParameterValues("X_Config.global.",{"voipenable"})
obj = values["X_Config.global."];

print("voipenable "..obj["voipenable"])

if obj["voipenable"] == 0 then
    utils.xmlappenderror("100003")
    return
end

local errcode, line_values = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.", {"Enable"});
if nil ~= line_values then
    for id, lineinfo in pairs(line_values) do
        if nil ~= id and nil ~= data and nil ~=data.callwaitingenable then
            local setValues = 
            {
                {id.."CallingFeatures.CallWaitingEnable", data.callwaitingenable }
            }
            errcode,needreboot, paramerror = dm.SetParameterValues( setValues )
            if errcode ~= 0 then
                utils.xmlappenderror(errcode)
            end
        end

        break
    end
else
   utils.xmlappenderror(errcode) 
end
    
