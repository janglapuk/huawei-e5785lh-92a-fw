local utils = require('utils')
local smbobjdomin = "InternetGatewayDevice.UserInterface.X_Web."

if nil ~= data and nil ~= data["supportlogindiffip"] then
local paras = {{"IsSupportDiffIPLoginWithSameAccount", data["supportlogindiffip"]}}	

local errcode, paramErrs = dm.SetObjToDB(smbobjdomin,paras)

return errcode, paramErrs
end