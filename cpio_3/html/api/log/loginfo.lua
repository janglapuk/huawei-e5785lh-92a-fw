local utils = require('utils')

local paras = {}
if  0 == tonumber(data["DisplayType"]) or 2 == tonumber(data["DisplayType"]) or 8 == tonumber(data["DisplayType"]) or 4194320 == tonumber(data["DisplayType"]) then
utils.add_one_parameter(paras, "InternetGatewayDevice.X_SyslogConfig.DisplayType", data["DisplayType"])
utils.add_one_parameter(paras, "InternetGatewayDevice.X_SyslogConfig.DisplayLevel", data["DisplayLevel"])
local errcode, NeedReboot, paramerr = dm.SetParameterValues(paras)

utils.xmlappenderror(errcode)
else
    errcode = 9003
	utils.xmlappenderror(errcode)
end
