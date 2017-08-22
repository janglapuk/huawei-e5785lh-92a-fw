local json = require('json')

local domain = "InternetGatewayDevice.UserInterface.X_Web."
local errcode,timeout = dm.GetParameterValues(domain , {"Timeout"});
local timeconf = timeout[domain]

local response = {}
response.timeout = timeconf["Timeout"]
sys.print(json.xmlencode(response))