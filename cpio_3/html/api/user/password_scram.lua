local utils = require('utils')
local web = require('web')

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

if nil == data then
	return
end


function checkOldPassword(oldpassword)
	if nil == oldpassword or nil == name then
		return 108002
	end

	local errcode,values = dm.GetParameterValues(domain, {"Userpassword"})
	local value = values[domain]
	
	local mergedPassword = value["Userpassword"]
		--the old password is base64 encoded
	if mergedPassword ==  web.sha256Encode(oldpassword) then
		local checkerr = web.checkpass(name, oldpassword)
		if  0 == checkerr then
			return 0
		end
	end
	
	return 108002
end

local errcode = checkOldPassword(data["currentpassword"])
if 0~= errcode then
	utils.xmlappenderror(errcode)
	_G["webtimes"] = _G["webtimes"] + 1
	if _G["webtimes"] > 2 then
	    _G["webtimes"] = 0
	    web.logout()
        utils.xmlappenderror(125002)
	end
	return
else
	_G["webtimes"] = 0
end

local paras = {}
if nil ~= data["newpassword"] and nil ~= domain then
	utils.add_one_parameter(paras, domain.."Userpassword", data["newpassword"])
end
local errcode, NeedReboot, paramerr =  dm.SetParameterValues(paras)

if 0 == errcode then
	web.logoutAllUser()
	web.logout()
	errcode = web.storepass(name, data["newpassword"])
end
utils.xmlappenderror(errcode)
