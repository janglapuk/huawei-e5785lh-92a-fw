require('web')
require('dm')
local utils = require('utils')

local errcode,values= dm.GetParameterValues("X_Config.global.",{"voipenable"})
obj = values["X_Config.global."];

print("voipenable "..obj["voipenable"])

if obj["voipenable"] == 0 then
    utils.xmlappenderror("100003")
	return
end

local err, values = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.{i}.", {"X_CustomerProfile"});
local open = 0
if values ~= nil then
    for k,v in pairs(values) do
	    local customerProfile = v["X_CustomerProfile"]
		s2,e2 = string.find(customerProfile, "4_27")
		if s2 ~= nil then
		    r = string.sub(customerProfile, s2+5, s2+5)
		    if "1" == r then
		    open = 1
		    end
		end
	end
end

print("open "..open)

if 1 == open then
	if nil ~= data and nil ~= data.sipserver then
		local sipserver = data.sipserver
		if sipserver["ID"] ~= nil and sipserver["ID"] ~= "" then
			local setValues = 
			{
				{sipserver["ID"].."SIP.RegistrarServer", sipserver["registerserveraddress"] },
				{sipserver["ID"].."SIP.ProxyServer", sipserver["proxyserveraddress"] },
				{sipserver["ID"].."SIP.X_SIPDomain", sipserver["sipserverdomain"] },
				{sipserver["ID"].."SIP.RegistrarServerPort", sipserver["registerserverport"] },
				{sipserver["ID"].."SIP.ProxyServerPort", sipserver["proxyserverport"] },
				{sipserver["ID"].."SIP.X_SecondRegistrarServer", sipserver["secondregisterserveraddress"] },
				{sipserver["ID"].."SIP.X_SecondRegistrarServerPort", sipserver["secondregisterserverport"] },
				{sipserver["ID"].."SIP.X_SecondProxyServer", sipserver["secondproxyserveraddress"] },
				{sipserver["ID"].."SIP.X_SecondProxyServerPort", sipserver["secondproxyserverport"] },
				{sipserver["ID"].."SIP.X_SecondSIPDomain", sipserver["secondsipserverdomain"] }
			}

			errcode,needreboot, paramerror = dm.SetParameterValues( setValues )
			if errcode ~= 0 then
				utils.xmlappenderror(errcode)
			end
		else
			local addValues = 
			{
			}
			errcode,profile_id,needreboot,paramerr = dm.AddObjectWithValues("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.", addValues)
	    
			if nil ~= profile_id and errcode == 0 then
				local setValues = 
				{
					{"InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profile_id..".SIP.RegistrarServer", sipserver["registerserveraddress"] },
					{"InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profile_id..".SIP.ProxyServer", sipserver["proxyserveraddress"] },
					{"InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profile_id..".SIP.X_SIPDomain", sipserver["sipserverdomain"] },
					{"InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profile_id..".SIP.RegistrarServerPort", sipserver["registerserverport"] },
					{"InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profile_id..".SIP.ProxyServerPort", sipserver["proxyserverport"] },
					{"InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profile_id..".SIP.X_SecondRegistrarServer", sipserver["secondregisterserveraddress"] },
					{"InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profile_id..".SIP.X_SecondRegistrarServerPort", sipserver["secondregisterserverport"] },
					{"InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profile_id..".SIP.X_SecondProxyServer", sipserver["secondproxyserveraddress"] },
					{"InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profile_id..".SIP.X_SecondProxyServerPort", sipserver["secondproxyserverport"] },
					{"InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profile_id..".SIP.X_SecondSIPDomain", sipserver["secondsipserverdomain"] }
				}
				errval,needreboot, paramerror = dm.SetParameterValues( setValues )
				if errval ~= 0 then
					utils.xmlappenderror(errval)
				end
			else
				utils.xmlappenderror(errcode)
			end
		end
	end
else
	utils.xmlappenderror(100002)
end
