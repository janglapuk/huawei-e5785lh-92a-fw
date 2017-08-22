require('web')
require('dm')
local utils = require('utils')

local errcode,values= dm.GetParameterValues("X_Config.global.",{"voipenable"})
obj = values["X_Config.global."];

print("voipenable "..obj["voipenable"])

if obj["voipenable"] == 0 then
    utils.xmlappenderror("100003")
    return
end

--用dm.StartTransaction和dm.EndTransaction保证配置只下发一次到业务
dm.StartTransaction()
local errcode, speed_values = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.X_CommonConfig.Button.{i}.",{"QuickDialNumber"});
if nil ~= speed_values then
    for id, speedinfo in pairs(speed_values) do
        if nil ~= id then
            errcode = dm.DeleteObject(id)
            if errcode ~= 0 then
                utils.xmlappenderror(errcode)
            end
        end
    end
end

if nil ~= data and data ~= "" then
    local datalen = table.getn(data)
    if datalen == 0 then
        if data.speeddial ~= nil then
            local addValues = 
            {
                {"QuickDialNumber", data.speeddial.quicknumber },
                {"Destination", data.speeddial.destination },
                {"Description", data.speeddial.description }
            }
            errcode,profile_id,needreboot,paramerr = dm.AddObjectWithValues("InternetGatewayDevice.Services.VoiceService.1.X_CommonConfig.Button.", addValues)
            if errcode ~= 0 then
                utils.xmlappenderror(errcode)
            end
        end
    else
        for i=1, datalen do
            local addValues = 
            {
                {"QuickDialNumber", data[i].quicknumber },
                {"Destination", data[i].destination },
                {"Description", data[i].description }
            }
            errcode,profile_id,needreboot,paramerr = dm.AddObjectWithValues("InternetGatewayDevice.Services.VoiceService.1.X_CommonConfig.Button.", addValues)
            if errcode ~= 0 then
                utils.xmlappenderror(errcode)
            end
        
        end    
    end
end
dm.EndTransaction();

    
