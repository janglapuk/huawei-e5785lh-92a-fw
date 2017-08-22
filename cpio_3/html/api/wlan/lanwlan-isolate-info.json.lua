local utils = require('utils')
local response = {}
require('dm')
require('json')

local isolatemain = "InternetGatewayDevice.X_LanWlanIsolate."
local errcode, isolateConf = dm.GetParameterValues(isolatemain, {"LanWlanIsolateEnable",
                                                                 "WlanIsolateEnable"
                                                                })
if(nil ~= isolateConf) then
    isolateConf = isolateConf[isolatemain]
    response.lanwlanisolate = isolateConf["LanWlanIsolateEnable"]
    response.wlanisolate = isolateConf["WlanIsolateEnable"]
end

sys.print(json.xmlencode(response))				