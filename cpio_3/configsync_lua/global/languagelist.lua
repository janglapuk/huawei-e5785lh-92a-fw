local utils = require('utils')
local smbobjdomin = "InternetGatewayDevice.UserInterface.X_Web."
if nil ~= data and nil ~= data["usermanual_language"] and nil ~= data["usermanual_language"]["default_language"] then
local default_language = data["usermanual_language"]["default_language"]
local endstr = string.find(default_language, "-")
local language = string.sub(default_language, 1, endstr - 1)
local paras = {{"Language", language}}	
local errcode, paramErrs = dm.SetObjToDB(smbobjdomin,paras)
return errcode, paramErrs
end
