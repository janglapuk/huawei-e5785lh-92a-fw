local json = require('json')

local domain = "InternetGatewayDevice.Services.CircleLed."
local errcode,circleled = dm.GetParameterValues(domain , {"Enable"});
local circleledconf = circleled[domain]

local response = {}
response.ledSwitch = circleledconf["Enable"]
sys.print(json.xmlencode(response))