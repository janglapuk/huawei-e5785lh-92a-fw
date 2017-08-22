local utils = require('utils')
local smbobjdomin = "InternetGatewayDevice.UserInterface.X_Web."

if nil ~= data and nil ~= data["IsSupportDiffAccountLoginWithSameIP"] then
local paras = {{"IsSupportDiffAccountLoginWithSameIP", data["IsSupportDiffAccountLoginWithSameIP"]}}	

local errcode, paramErrs = dm.SetObjToDB(smbobjdomin,paras)

return errcode, paramErrs
end