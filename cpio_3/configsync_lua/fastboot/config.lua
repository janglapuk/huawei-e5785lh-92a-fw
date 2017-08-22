local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.fastboot."

    if nil ~= data and nil ~= data["enable"] then
            local errcode, paramErrs = dm.SetObjToDB(objdomin,{{"enable", data["enable"]}})
			print('fastboot enable error = ', errcode)
			print('fastboot enable data = ', errcode)
    end