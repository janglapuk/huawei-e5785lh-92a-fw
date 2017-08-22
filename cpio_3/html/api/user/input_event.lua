local utils = require('utils')
local web = require('web')
if nil ~= data and nil ~= data['input_param'] then
	web.input_event(data['input_param'])
end

