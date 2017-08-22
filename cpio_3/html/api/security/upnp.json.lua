local json = require('json')

local domain = "InternetGatewayDevice.Services.X_UPnP."
local errcode,upnp = dm.GetParameterValues(domain , {"Enable"});
local upnpconf = upnp[domain]

local response = {}
response.UpnpStatus = upnpconf["Enable"]
sys.print(json.xmlencode(response))