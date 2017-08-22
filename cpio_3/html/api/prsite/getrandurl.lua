require('dm')
require('utils')
require('sys')
require('web')


if nil ~= data and nil ~= data["randid"] then
    web.seturlbyrandid(data["randid"])
end
