local utils = require('utils')
local param = {}
local objdomin = "InternetGatewayDevice.X_Config.redirection."

if nil ~= data and nil ~= data["enable"] then 
param = {{"enable", data["enable"]}}	
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)
print('errcode1', errcode)
return errcode, paramErrs
end

