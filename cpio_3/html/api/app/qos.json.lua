local json = require('json')

local qosdomain = "InternetGatewayDevice.QueueManagement."
local qoserrcode,qos = dm.GetParameterValues(qosdomain , {"Enable","X_WmmEnable","X_BandWidth","DownBandWidth"});

local response = {}
if qoserrcode == 0 then
    local qosconf = qos[qosdomain]
	response.enable = qosconf["Enable"]
    response.wmmenable = qosconf["X_WmmEnable"]
	response.upbandwidth = qosconf["X_BandWidth"]
    response.downbandwidth = qosconf["DownBandWidth"]
end
print(json.xmlencode(response))
sys.print(json.xmlencode(response))

