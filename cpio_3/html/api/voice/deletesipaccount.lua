require('web')
require('dm')
local utils = require('utils')
local ID = ""

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
        ID = id
        break
    end
end

if ID ~= "" then
    errcode = dm.DeleteObject(ID)
    if errcode ~= 0 then
        utils.xmlappenderror("errcode", errcode)
    end
end

    
