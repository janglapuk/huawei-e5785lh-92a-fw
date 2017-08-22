local utils = require('utils')
local smbobjdomin = "InternetGatewayDevice.UserInterface.X_Web."

if nil ~= data and nil ~= data["failedtimes"] then
local paras = {{"DefaultMaxFailTimes", data["failedtimes"]}}	

local errcode, paramErrs = dm.SetObjToDB(smbobjdomin,paras)

return errcode, paramErrs
end