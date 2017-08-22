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

_G["api_voice_deletesipaccount"] = {
}
local errcode, line_values = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.", {"Enable"});
if nil ~= line_values then
    for id, lineinfo in pairs(line_values) do
        print("id "..id)
        ID = id
        break
    end
end

local addValues = 
{
    {"DirectoryNumber", account.directorynumber },
    {"Enable", "Enabled" }
}
if ID ~= "" and nil ~= ID then
    errcode,line_id,needreboot,paramerr = dm.AddObjectWithValues(ID.."Line.", addValues)        
    if errcode ~= 0 then
        utils.xmlappenderror("errcode", errcode)
    else
        if nil ~= line_id then
            local setValues = 
            {
                {ID.."Line."..line_id..".SIP.AuthUserName", account["username"] },
                {ID.."Line."..line_id..".SIP.AuthPassword", account["password"] }
            }
            errval,needreboot, paramerror = dm.SetParameterValues( setValues )
            if errval ~= 0 then
                utils.xmlappenderror(errval)
            end
        end
    end
end

