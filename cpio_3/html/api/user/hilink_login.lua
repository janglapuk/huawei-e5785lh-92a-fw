local dm = require('dm')
local web = require('web')
local utils = require('utils')

local switch = 0
local paras = {}
local path = "InternetGatewayDevice.X_Config.webserver.config.user."

if nil ~= data and nil ~= data["hilink_login"] then
	if ("1" ~= data["hilink_login"]) then
	    switch = 0
	    if nil ~= path then
	    	utils.add_one_parameter(paras, path.."hilink_login", "0")
	    end
	    local err = dm.SetParameterValues(paras)
	    web.logout()
	else
	    switch = 1
	    if nil ~= path then
	    	utils.add_one_parameter(paras, path.."hilink_login", "1")
	    end
	    local err = dm.SetParameterValues(paras)
	end
end

-- change the global flag of hilink login switch in webserver
web.setHilinkLogin(switch)

utils.xmlappenderror(0)

