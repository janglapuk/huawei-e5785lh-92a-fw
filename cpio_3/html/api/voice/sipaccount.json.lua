local web       = require("web")
local json      = require("json")
local utils     = require('utils')

-- 如果voip开关是关的，则不能响应restful接口
local errcode,values= dm.GetParameterValues("X_Config.global.",{"voipenable"})
obj = values["X_Config.global."];

print("voipenable "..obj["voipenable"])

if obj["voipenable"] == 0 then
    utils.xmlappenderror("100003")
    return
end


local response = {}
local sipaccount = {}
local voice_profile = {}
local err, profilevalues = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.", {"Name"});
if err ~= 0 then
	print("!!! err "..err)
end

voice_profile.registerserveraddress = ""
voice_profile.proxyserveraddress = ""

if profilevalues ~= nil then
	for id,profileinfo in pairs(profilevalues) do
		local errcode,each_sip = dm.GetParameterValues(id.."SIP.", {"ProxyServer", "RegistrarServer"});
		if errcode ~= 0 then
			print("!!! errcode "..errcode)
			break
		end
		local each_sip_obj = each_sip[id.."SIP."]
		voice_profile.registerserveraddress = each_sip_obj["RegistrarServer"]
		voice_profile.proxyserveraddress = each_sip_obj["ProxyServer"]
		break
	end
end	
response.sipserver = voice_profile	
			
local errcode, line_values = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.", {"DirectoryNumber", "Status"});
local index = 0
if nil ~= line_values then
    for id, lineinfo in pairs(line_values) do
        index = index + 1
        local lineitem = {}
        lineitem.ID = id
        lineitem.index = index
        lineitem.directorynumber = lineinfo["DirectoryNumber"]
        if lineinfo["Status"] == "Unregistered" then
            lineitem.registerstatus = 0
        elseif lineinfo["Status"] == "Registering" then
            lineitem.registerstatus = 1
        else
            lineitem.registerstatus = 2
        end
        
        local errcode,each_line = dm.GetParameterValues(id.."SIP.", {"AuthUserName", "AuthPassword"});
        if errcode ~= 0 then
            print("!!! errcode "..errcode)
            break
        end
        local each_line_obj = each_line[id.."SIP."]
        lineitem.username = each_line_obj["AuthUserName"]
        lineitem.password = "********"
        
        table.insert(sipaccount,lineitem)
        break
    end
else
    print("!!! errcode "..errcode)
end
response.account = sipaccount
sys.print(json.xmlencodex(response))
