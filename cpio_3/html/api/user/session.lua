local utils = require('utils')
local web = require('web')
local val = data["keep"]

if "1" == val then
	web.session()
else
	utils.xmlappenderror(100002)
end
