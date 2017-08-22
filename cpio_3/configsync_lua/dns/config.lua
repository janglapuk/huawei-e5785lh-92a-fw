local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.dns."

local paras = {{"DnsPriorityEnable", data["dnspriority_enable"]}}

local errcode, paramErrs = dm.SetObjToDB(objdomin,paras)
print("errcode_dnspriority_enable = ", errcode)