local utils = require('utils')
local smbobjdomin = "InternetGatewayDevice.UserInterface.X_Web."

if nil ~= data and nil ~= data["defaultlanguage"] then
local paras = {{"Language", data["defaultlanguage"]}}	

local errcode, paramErrs = dm.SetObjToDB(smbobjdomin,paras)

return errcode, paramErrs
end