local json = require('json')


local response = {}
local domain1 = "InternetGatewayDevice.UserInterface.X_Web.UserInfo.1."
local domain2 = "InternetGatewayDevice.UserInterface.X_Web.UserInfo.2."
local domain = ""
local name, level = web.getuserinfo()

local value1 = ""
local value2 = ""
local errcode1,values1 = dm.GetParameterValues(domain1, {"Username"})
if 0 == errcode1 then
    value1 = values1[domain1]
end
local errcode2,values2 = dm.GetParameterValues(domain2, {"Username"})
if 0 == errcode2 then
    value2 = values2[domain2]
end

if name == value1["Username"] then
        domain = domain1
else 
        domain = domain2
end

response.firstlogin = 1

local errcode,values = dm.GetParameterValues(domain,
    {
        "X_IsFirst"
    }
);

if nil ~= values then
    local IsNotFirstLogin = 0
    for k, v in pairs(values) do
        if 1 == v["X_IsFirst"] then 
            IsNotFirstLogin = 1
        end
    end

    if 0 == IsNotFirstLogin then
        response.firstlogin = 0
    end
end

sys.print(json.xmlencode(response))