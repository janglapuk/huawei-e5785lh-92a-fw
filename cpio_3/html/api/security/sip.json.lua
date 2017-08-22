local web = require("web")
local json = require("json")

local response = {}
local sipalginfo = {}

local errcode, sipalg_values = dm.GetParameterValues("InternetGatewayDevice.Services.X_ALGAbility.", {"SIPEnable", "SIPPort"});
if nil ~= sipalg_values then
    for id, info in pairs(sipalg_values) do
	    sipalginfo.SipStatus = info["SIPEnable"]
		sipalginfo.SipPort = info["SIPPort"]
        break
    end
else
    print("!!! errcode "..errcode)
end

response.SipStatus = sipalginfo.SipStatus
response.SipPort = sipalginfo.SipPort
sys.print(json.xmlencodex(response))
