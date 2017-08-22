local web       = require("web")
local json      = require("json")

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

	local err, profilevalues = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.", {"Name"});
	if err ~= 0 then
		print("!!! err "..err)
	end
	local response = {}
	local voice_profile = {}

	voice_profile.ID = ""
	voice_profile.registerserveraddress = ""
	voice_profile.proxyserveraddress = ""
	voice_profile.sipserverdomain = ""
	voice_profile.registerserverport = "5060"
	voice_profile.proxyserverport = "5060"
	voice_profile.secondregisterserveraddress = ""
	voice_profile.secondregisterserverport = "5060"
	voice_profile.secondproxyserveraddress = ""
	voice_profile.secondproxyserverport = "5060"
	voice_profile.secondsipserverdomain = ""

	if profilevalues ~= nil then
		for id,profileinfo in pairs(profilevalues) do
			voice_profile.ID = id
			local errcode,each_sip = dm.GetParameterValues(id.."SIP.", {"ProxyServer", "RegistrarServer", "X_SIPDomain", "ProxyServerPort", "RegistrarServerPort", "X_SecondProxyServer", "X_SecondProxyServerPort", "X_SecondRegistrarServer", "X_SecondRegistrarServerPort", "X_SecondSIPDomain"});
			if errcode ~= 0 then
				print("!!! errcode "..errcode)
				break
			end
			local each_sip_obj = each_sip[id.."SIP."]
			voice_profile.registerserveraddress = each_sip_obj["RegistrarServer"]
			voice_profile.proxyserveraddress = each_sip_obj["ProxyServer"]
			voice_profile.sipserverdomain = each_sip_obj["X_SIPDomain"]
			voice_profile.registerserverport = each_sip_obj["RegistrarServerPort"]
			voice_profile.proxyserverport = each_sip_obj["ProxyServerPort"]
			voice_profile.secondregisterserveraddress = each_sip_obj["X_SecondRegistrarServer"]
			voice_profile.secondregisterserverport = each_sip_obj["X_SecondRegistrarServerPort"]
			voice_profile.secondproxyserveraddress = each_sip_obj["X_SecondProxyServer"]
			voice_profile.secondproxyserverport = each_sip_obj["X_SecondProxyServerPort"]
			voice_profile.secondsipserverdomain = each_sip_obj["X_SecondSIPDomain"]
		
			break
		end
	end
	response.sipserver = voice_profile
	sys.print(json.xmlencode(response))
else
	local response = {}
	response.Code = 100002
	response.Message = ""
	sys.print(json.xmlencode(response))
end	

