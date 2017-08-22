require('web')
require('dm')

if nil == data then
	return
end

local utils = require('utils')
local setValues = 
{
    {"InternetGatewayDevice.Services.X_ALGAbility.SIPEnable", data.SipStatus },
    {"InternetGatewayDevice.Services.X_ALGAbility.SIPPort", data.SipPort }
}
		
errval,needreboot, paramerror = dm.SetParameterValues( setValues )
if errval ~= 0 then
    utils.xmlappenderror(errval)
end		


