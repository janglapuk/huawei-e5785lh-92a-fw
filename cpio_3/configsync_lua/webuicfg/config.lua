local utils = require('utils')
local param = {}
local objdomin = "InternetGatewayDevice.X_Config.webuicfg."
local maps = {
    firewallwanportpingswitch_enable="firewallwanportpingswitch_enable",
    dialog_new_version="dialog_new_version",
    install_processbar_enable="install_processbar_enable",
    install_processbar_speed="install_processbar_speed",
}
function SetObjParamInputs(domain, data, maps)
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
local param = SetObjParamInputs(objdomin, data, maps)
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)
print('errcode1:', errcode)

param = {}	
local lanipfilter = "InternetGatewayDevice.X_Config.webuicfg.lanipfilter."
local lanmaps = {
    wan="wan",
    number="number",
    lan_enable="lan_enable",
    protocol_imcp="protocol_imcp",
}
if nil ~= data["lanipfilter"] then
local param = SetObjParamInputs(lanipfilter, data["lanipfilter"], lanmaps)
local errcode, paramErrs = dm.SetObjToDB(lanipfilter,param)
print('errcode2:', errcode)
end

param = {}	
local specialapplication = "InternetGatewayDevice.X_Config.webuicfg.specialapplication."
local specmaps = {
    number="number",
}
if nil ~= data["specialapplication"] then
local param = SetObjParamInputs(specialapplication, data["specialapplication"], specmaps)
local errcode, paramErrs = dm.SetObjToDB(specialapplication,param)
print('errcode3:', errcode)
end

param = {}	
local virtualserver = "InternetGatewayDevice.X_Config.webuicfg.virtualserver."
local firewall_virtualserver = "InternetGatewayDevice.X_Config.virtualserver."
local virmaps = {
    number="number",
}
if nil ~= data["virtualserver"] then
local param = SetObjParamInputs(virtualserver, data["virtualserver"], virmaps)
local errcode, paramErrs = dm.SetObjToDB(virtualserver,param)
print('errcode4.1:', errcode)

local param = SetObjParamInputs(firewall_virtualserver, data["virtualserver"], virmaps)
local errcode, paramErrs = dm.SetObjToDB(firewall_virtualserver,param)
print('errcode4.2:', errcode)
end

param = {}	
local urlfilter = "InternetGatewayDevice.X_Config.webuicfg.urlfilter."
local urlmaps = {
    number="number",
}
if nil ~= data["urlfilter"] then
local param = SetObjParamInputs(urlfilter, data["urlfilter"], urlmaps)
local errcode, paramErrs = dm.SetObjToDB(urlfilter,param)
print('errcode5:', errcode)
end
return errcode, paramErrs
end