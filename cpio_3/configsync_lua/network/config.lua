local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.net."
local maps = {
    enable="enable",
    spn="spn",
    pnn="pnn",
	pre_netmode="pre_netmode",
    partnercheck="partnercheck",
    net_premode_switch="net_premode_switch",
	lteband_custom="lteband_custom",
}
function SetObjParamInputs(data, maps)
    local inputs = {}
    for k, v in pairs(maps) do
        local param = {}
        if nil ~= data and nil ~= data[k] then
          param["key"] = v      
          param["value"] = data[k]
          table.insert(inputs, param)
        end  
    end
    return inputs
end

if nil ~= data then
	print('lua net parse config come')
	local param = SetObjParamInputs(data, maps)
	local errcode = dm.SetObjToDB(objdomin,param)
	print('lua net set data', errcode)
end


function add_lteband_sync()
    local ltebanddomin = "InternetGatewayDevice.X_Config.net.lteband."
    for k,v in pairs(data["lteband"]) do
            local errcode, paramErrs = dm.AddObjectToDB(ltebanddomin, 
                    {{"bandname", v.bandname}, {"bandvalue", v.bandvalue}})
            if errcode ~= nil then
                print("add_lteband_sync errcode = ", errcode)
            end       
    end
end

if nil ~= data and nil ~= data["lteband"] then
    add_lteband_sync()
end