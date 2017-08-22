local utils = require('utils')

local paras = {}

utils.add_one_parameter(paras, "InternetGatewayDevice.Services.CircleLed.Enable", data["ledSwitch"])

local errcode, NeedReboot, paramerr = dm.SetParameterValues(paras)

utils.xmlappenderror(errcode)