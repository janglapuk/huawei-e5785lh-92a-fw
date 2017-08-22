require('web')
require('dm')
local utils = require('utils')
if nil == data or nil == data.account then
    return
end

-- 如果voip开关是关的，则不能响应restful接口
local errcode,values= dm.GetParameterValues("X_Config.global.",{"voipenable"})
obj = values["X_Config.global."];

print("voipenable "..obj["voipenable"])

if obj["voipenable"] == 0 then
    utils.xmlappenderror("100003")
    return
end


local account = data.account
local ID = ""

local errcode, line_values = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.", {"Enable"});
if nil ~= line_values then
    for id, lineinfo in pairs(line_values) do
        ID = id
        break
    end
end

if ID ~= "" and nil ~= ID then
    local setValues = 
    {
        {ID.."DirectoryNumber", account.directorynumber },
        {ID.."Enable", "Enabled" }
    }

    errcode,needreboot, paramerror = dm.SetParameterValues( setValues )
    if errcode ~= 0 then
        utils.xmlappenderror(errcode)
    end
    local setValues = {}
    if account["password"] == nil then
        setValues = 
        {
            {ID.."SIP.AuthUserName", account["username"] }
        }
    else
        setValues = 
        {
            {ID.."SIP.AuthUserName", account["username"] },
            {ID.."SIP.AuthPassword", account["password"] }
        }
    end
    errcode,needreboot, paramerror = dm.SetParameterValues( setValues )
    if errcode ~= 0 then
        utils.xmlappenderror(errcode)
    end
end

    
