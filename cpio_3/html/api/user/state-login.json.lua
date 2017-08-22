local web       = require("web")
local json      = require("json")
local name,level = web.getuserinfo()
local response = {}

if nil ~= level and 0 ~= level then
    response.State = 0
    response.Username = name
    response.userlevel = level
else
    response.State = -1
    response.userlevel = ""
    response.username = ""
end
response.password_type = 4

local storekey = ""

response.firstlogin = 0
response.history_login_flag = 0
local domin = ""
local domain1 = "InternetGatewayDevice.UserInterface.X_Web.UserInfo.1."
local domain2 = "InternetGatewayDevice.UserInterface.X_Web.UserInfo.2."
local errcode1,values1 = dm.GetParameterValues(domain1, {"Username", "X_Salt"})
local value1 = ""
local value2 = ""
if 0 == errcode1 then
    value1 = values1[domain1]
end
local errcode2,values2 = dm.GetParameterValues(domain2, {"Username", "X_Salt"})
if 0 == errcode2 then
    value2 = values2[domain2]
end

local salt = value1["X_Salt"]

if name == value1["Username"] then
	domain = domain1
else 
	domain = domain2
end

local IsNotFirstLogin1 = 0
local IsNotFirstLogin2 = 0

local err1,v1 = dm.GetParameterValues(domain1,
    {
        "X_IsFirst"
    }
);

local err2,v2 = dm.GetParameterValues(domain2,
    {
        "X_IsFirst"
    }
);

if nil ~= v1 then
	for k, v in pairs(v1) do
		if 1 == v["X_IsFirst"] then 
			IsNotFirstLogin1 = 1
		end
	end
end

if nil ~=v2 then
	for k, v in pairs(v2) do
		if 1 == v["X_IsFirst"] then 
			IsNotFirstLogin2 = 1
		end
	end
end
	
	

if 0 == level then
	if 0 == IsNotFirstLogin1 and 0 == IsNotFirstLogin2 then
		response.firstlogin = 0
	else
		response.firstlogin = 1
    end
else
	if 0 == errcode1 then
	    if name == value1["Username"] and 1 == IsNotFirstLogin1 then
		    response.firstlogin = 1
	    end
	end
	if 0 == errcode2 then
		if name == value2["Username"] and 1 == IsNotFirstLogin2 then
		    response.firstlogin = 1
		end
	end
end

if "ef1ea6a0e92af9a9e19bc1de8f64b9ccd34ec32ec62021163f3e61cbc51d08db" ~= salt or response.firstlogin ~= 1 then
	if nil ~= salt and "" ~= salt then
		response.extern_password_type = 1
	end	
end

sys.print(json.xmlencode(response))