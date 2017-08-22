local web       = require("web")
local json      = require("json")
local utils     = require('utils')
local response = {}
local functioncode = {}
local num = 0
local funcstr = ""
    
function split(str, sep)
    local start = 1
    local pre = nil
    local retval = {}

    if nil == str then
        return retval
    end

    while true do
        ip,fp = string.find(str, sep, start)
        if not ip then 
            if start <= string.len(str) then
                table.insert(retval, string.sub(str, start))
            end
            break 
        end

        if start < ip then
            table.insert(retval, string.sub(str, start, ip-1))
        end
        start = fp + 1
    end

    return retval
end

-- 如果voip开关是关的，则不能响应restful接口
local errcode,values= dm.GetParameterValues("X_Config.global.",{"voipenable"})
obj = values["X_Config.global."];

print("voipenable "..obj["voipenable"])

if obj["voipenable"] == 0 then
    utils.xmlappenderror("100003")
    return
end

local errcode,funcodearray = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.",{"X_FunctionCode"});
if funcodearray then
    for id,funinfo in pairs(funcodearray) do
        funcstr = funinfo["X_FunctionCode"]
    end
end

local funArray = split(funcstr, ',')

for id,func in pairs(funArray) do
    num = num + 1
    functioncode[num] = string.sub(func, 3, #func)
end

response.funcode = functioncode
sys.print(json.xmlencodex(response))


