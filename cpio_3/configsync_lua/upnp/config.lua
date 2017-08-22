local utils = require('utils')

if nil ~= data and nil ~= data["upnp_portmapping_display"] then
    local paras = {{"upnp_portmapping_display", data["upnp_portmapping_display"]}} 
    local errcode, paramErrs = dm.SetObjToDB("InternetGatewayDevice.X_Config.upnp.",paras)
end


local upnpobjdomin = "InternetGatewayDevice.Services.X_UPnP."
if nil ~= data and nil ~= data["enable"] then
    local paras = {{"Enable", data["enable"]}}	
    local errcode, paramErrs = dm.SetObjToDB(upnpobjdomin,paras)
    return errcode, paramErrs
end