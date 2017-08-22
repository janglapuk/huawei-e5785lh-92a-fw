local utils = require('utils')

local paras = {}

if nil == data then
	return
end

utils.add_one_parameter(paras, "InternetGatewayDevice.Services.X_UPnP.Enable", data["UpnpStatus"])

local errcode, NeedReboot, paramerr = dm.SetParameterValues(paras)

utils.xmlappenderror(errcode)