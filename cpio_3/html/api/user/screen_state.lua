local utils = require('utils')
local web = require('web')
if nil ~= data and nil ~= data['state'] then
	web.screen_state(data['state'])
end
