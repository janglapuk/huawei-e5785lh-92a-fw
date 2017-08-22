local utils = require('utils')
local web = require('web')
local val = data["Logout"]

if "1" == val then
	web.logout()
else
	utils.xmlappenderror(100006)
end
