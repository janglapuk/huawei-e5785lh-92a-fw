local utils = require('utils')
local smbobjdomin = "InternetGatewayDevice.UserInterface.X_Web."

if nil ~= data and nil ~= data["timeout"] then
local paras = {{"Timeout", data["timeout"]}}	

local errcode, paramErrs = dm.SetObjToDB(smbobjdomin,paras)

return errcode, paramErrs
end