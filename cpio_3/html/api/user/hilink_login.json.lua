local json = require('json')

local switch = 0
local domain = "InternetGatewayDevice.X_Config.webserver.config.user."
local errcode, getObject = dm.GetParameterValues(domain, {"hilink_login"})

if nil ~= getObject and nil ~= getObject[domain] then
    local hilinkObject = getObject[domain]
    if 1 == hilinkObject["hilink_login"] or "1" == hilinkObject["hilink_login"] then
        switch = 1
    else
        switch = 0
    end
end

local response = {}
response.hilink_login = switch

sys.print(json.xmlencode(response))
