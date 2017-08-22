local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.global."
local maps = {
    enable ="voipenable",
}

function SetObjParamInputs(domain, data, maps)
    local inputs = {}
    for	k, v in	pairs(maps) do
	local param = {}
		if nil ~= data and nil ~= data[k] then
			param["key"] = v      
			param["value"] = data[k]
			table.insert(inputs, param)
		end
    end
    return inputs
end

local param = SetObjParamInputs(objdomin, data,	maps)
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)
if 0 ~= errcode then                                                    
    print("set voip errcode = ",errcode)                           
end   

require('dm')
print("voice config start")

if nil ~= data and nil ~= data["enable"] then
	local voiceserviceenable = "InternetGatewayDevice.Services.VoiceService.1."
	local voiceserviceenableparas = {{"X_VoipEnable", data["enable"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceserviceenable,voiceserviceenableparas)
	if errcode ~= 0 then
		print("voiceserviceparas set fail errcode "..errcode)
	end
end
		
--Enable参数值转换
if nil ~= data["profile0"] and nil ~= data["profile0"]["enable"] then
	if data["profile0"]["enable"] == "1" then
		data["profile0"]["enable"] = "Enabled"
	else
		data["profile0"]["enable"] = "Disabled"
	end
end

if nil ~= data["line0"] and nil ~= data["line0"]["enable"] then
	if data["line0"]["enable"] == "1" then
		data["line0"]["enable"] = "Enabled"
	else
		data["line0"]["enable"] = "Disabled"
	end
end

--voiceservice节点
local voiceservicedomin = "InternetGatewayDevice.Services.VoiceService.1."

if nil ~= data["featureswitch0"] and nil ~= data["featureswitch0"]["specialcharenable"] then
	local voiceserviceparas = {{"X_SpecialCharEnable", data["featureswitch0"]["specialcharenable"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceservicedomin,voiceserviceparas)
	if errcode ~= 0 then
		print("X_SpecialCharEnable set fail errcode "..errcode)
	end
end

if nil ~= data["global0"] and nil ~= data["global0"]["callallportspre"] then
	local voiceserviceparas = {{"X_CallAllPortsPrefix", data["global0"]["callallportspre"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceservicedomin,voiceserviceparas)
	if errcode ~= 0 then
		print("X_CallAllPortsPrefix set fail errcode "..errcode)
	end
end

local errcode, csobjs = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.",
{ 
    "X_UmtsNumber",
    "X_UmtsEnable",
    "X_VolteEnable",
    "X_VolteDisplay"
})

if csobjs ~= nil then
	if nil ~= data["global0"] and nil ~= data["global0"]["umtsnumber"] then
		local voicecsparas = {{"X_UmtsNumber", data["global0"]["umtsnumber"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceservicedomin,voicecsparas)
		if errcode ~= 0 then
			print("X_UmtsNumber set fail errcode "..errcode)
		end
	end
	
	if nil ~= data["global0"] and nil ~= data["global0"]["umtsenable"] then
		local voicecsparas = {{"X_UmtsEnable", data["global0"]["umtsenable"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceservicedomin,voicecsparas)
		if errcode ~= 0 then
			print("X_UmtsEnable set fail errcode "..errcode)
		end
	end

	if nil ~= data["global0"] and nil ~= data["global0"]["volteenable"] then
		local voicecsparas = {{"X_VolteEnable", data["global0"]["volteenable"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceservicedomin,voicecsparas)
		if errcode ~= 0 then
			print("X_VolteEnable set fail errcode "..errcode)
		end
	end

	if nil ~= data["global0"] and nil ~= data["global0"]["voltedisplay"] then
		local voicecsparas = {{"X_VolteDisplay", data["global0"]["voltedisplay"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceservicedomin,voicecsparas)
		if errcode ~= 0 then
			print("X_VolteDisplay set fail errcode "..errcode)
		end
	end
	
	if nil ~= data["global0"] and nil ~= data["global0"]["umtsclipenable"] then
		local voicecsparas = {{"X_UmtsClipEnable", data["global0"]["umtsclipenable"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceservicedomin,voicecsparas)
		if errcode ~= 0 then
			print("X_UmtsClipEnable set fail errcode "..errcode)
		end
	end
	
	if nil ~= data["global0"] and nil ~= data["global0"]["umtsdtmfmethod"] then
		local voicecsparas = {{"X_UmtsDTMFMethod", data["global0"]["umtsdtmfmethod"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceservicedomin,voicecsparas)
		if errcode ~= 0 then
			print("X_UmtsDTMFMethod set fail errcode "..errcode)
		end
	end
end

--X_CommonConfig 节点
local voiceserviceCommonConfig= "InternetGatewayDevice.Services.VoiceService.1.X_CommonConfig."

if nil ~= data["global0"] and nil ~= data["global0"]["CIDSendType"] then
	local voiceCommonConfigparas = {{"X_CIDSendType", data["global0"]["CIDSendType"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceserviceCommonConfig,voiceCommonConfigparas)
	if errcode ~= 0 then
		print("CIDSendType set fail errcode "..errcode)
	end
end

if nil ~= data["global0"] and nil ~= data["global0"]["voipcsselect"] then
	local voiceCommonConfigparas = {{"X_Voipcsselect", data["global0"]["voipcsselect"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceserviceCommonConfig,voiceCommonConfigparas)
	if errcode ~= 0 then
		print("X_Voipcsselect set fail errcode "..errcode)
	end
end

--voiceprofile节点
local errcode, profilenum, profilearray = dm.GetObjNum("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.")
print("profilenum "..profilenum)
local profileinstid = 0
local lineinstid = 0
if errcode == 0 and profilenum ~= 0 and profilearray ~= nil then
	for k,v in pairs(profilearray) do
		profileinstid = v
		break
	end
end

if 0 == profilenum then
    --如果不存在profile，则是加载平台的xml文件，这个时候不需要判空
	local voiceprofileparas = {{"Enable", data["profile0"]["enable"]},
						   {"Name", data["profile0"]["profilename"]},
						   {"STUNServer", data["profile0"]["stunserver"]}, 
                           {"X_STUNServerPort", data["profile0"]["stunport"]},  
						   {"Region", data["global0"]["region"]},
						   {"DigitMap", data["global0"]["digitmap"]},
						   {"X_HotLineEnable", data["global0"]["hotlineenble"]},
						   {"X_HotLineIntervalTime", data["global0"]["hotlineinterval"]},
						   {"X_HotLineNumber", data["global0"]["hotlinenumber"]},
						   {"X_OffHookTime", data["global0"]["offhooktime"]},
						   {"X_OnHookTime", data["global0"]["onhooktime"]},
						   {"X_MinHookFlash", data["global0"]["minihookflash"]},
						   {"X_MaxHookFlash", data["global0"]["maxhookflash"]},
						   {"X_EnableSharpKey", data["global0"]["enablesharpkey"]},
						   {"DTMFMethod", data["profile0"]["dtmfmethod"]}
                          } 
						  
	errcode, profileinstid, paramerr= dm.AddObjectToDB("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.", voiceprofileparas)
	if errcode ~= 0 then
		print("voiceprofileparas add fail errcode "..errcode)
	end	
else
	print("profileinstid "..profileinstid)
	local voiceprofiledomin = "InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid.."."
	--print("profile0 enable "..data["profile0"]["enable"])
	
	--如果profile本身存在，需要逐个设置，避免产品配置不生效
	if nil ~= data["profile0"] and nil ~= data["profile0"]["enable"] then
		local voiceprofileparas = {{"Enable", data["profile0"]["enable"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("Enable set fail errcode "..errcode)
		end
	end
	if nil ~= data["profile0"] and nil ~= data["profile0"]["profilename"] then
		local voiceprofileparas = {{"Name", data["profile0"]["profilename"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("profilename set fail errcode "..errcode)
		end
	end	
	if nil ~= data["profile0"] and nil ~= data["profile0"]["stunserver"] then
		local voiceprofileparas = {{"STUNServer", data["profile0"]["stunserver"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("stunserver set fail errcode "..errcode)
		end
	end	
	if nil ~= data["profile0"] and nil ~= data["profile0"]["stunport"] then
		local voiceprofileparas = {{"X_STUNServerPort", data["profile0"]["stunport"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("stunport set fail errcode "..errcode)
		end
	end	
	if nil ~= data["global0"] and nil ~= data["global0"]["region"] then
		local voiceprofileparas = {{"Region", data["global0"]["region"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("region set fail errcode "..errcode)
		end
	end	
	if nil ~= data["global0"] and nil ~= data["global0"]["digitmap"] then
		local voiceprofileparas = {{"DigitMap", data["global0"]["digitmap"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("digitmap set fail errcode "..errcode)
		end
	end	
	if nil ~= data["global0"] and nil ~= data["global0"]["hotlineenble"] then
		local voiceprofileparas = {{"X_HotLineEnable", data["global0"]["hotlineenble"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("hotlineenble set fail errcode "..errcode)
		end
	end	
	if nil ~= data["global0"] and nil ~= data["global0"]["hotlineinterval"] then
		local voiceprofileparas = {{"X_HotLineIntervalTime", data["global0"]["hotlineinterval"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("hotlineinterval set fail errcode "..errcode)
		end
	end	
	if nil ~= data["global0"] and nil ~= data["global0"]["hotlinenumber"] then
		local voiceprofileparas = {{"X_HotLineNumber", data["global0"]["hotlinenumber"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("hotlinenumber set fail errcode "..errcode)
		end
	end	
	if nil ~= data["global0"] and nil ~= data["global0"]["offhooktime"] then
		local voiceprofileparas = {{"X_OffHookTime", data["global0"]["offhooktime"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("offhooktime set fail errcode "..errcode)
		end
	end	
	if nil ~= data["global0"] and nil ~= data["global0"]["onhooktime"] then
		local voiceprofileparas = {{"X_OnHookTime", data["global0"]["onhooktime"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("onhooktime set fail errcode "..errcode)
		end
	end	
	if nil ~= data["global0"] and nil ~= data["global0"]["minihookflash"] then
		local voiceprofileparas = {{"X_MinHookFlash", data["global0"]["minihookflash"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("minihookflash set fail errcode "..errcode)
		end
	end	
	if nil ~= data["global0"] and nil ~= data["global0"]["maxhookflash"] then
		local voiceprofileparas = {{"X_MaxHookFlash", data["global0"]["maxhookflash"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("maxhookflash set fail errcode "..errcode)
		end
	end	
	if nil ~= data["global0"] and nil ~= data["global0"]["enablesharpkey"] then
		local voiceprofileparas = {{"X_EnableSharpKey", data["global0"]["enablesharpkey"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("enablesharpkey set fail errcode "..errcode)
		end
	end	
	if nil ~= data["profile0"] and nil ~= data["profile0"]["dtmfmethod"] then
		local voiceprofileparas = {{"DTMFMethod", data["profile0"]["dtmfmethod"]}} 
		local errcode, paramErrs = dm.SetObjToDB(voiceprofiledomin,voiceprofileparas)
		if errcode ~= 0 then
			print("dtmfmethod set fail errcode "..errcode)
		end
	end	
end

--设置sip相关参数
local voiceprofilesipdomin = "InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid..".SIP."
if nil ~= data["profile0"] and nil ~= data["profile0"]["useragentport"] then
	local voiceprofilesipparas = {{"UserAgentPort", data["profile0"]["useragentport"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("useragentport set fail errcode "..errcode)
	end
end	

if nil ~= data["profile0"] and nil ~= data["profile0"]["proxyserveraddress"] then
	local voiceprofilesipparas = {{"ProxyServer", data["profile0"]["proxyserveraddress"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("proxyserveraddress set fail errcode "..errcode)
	end
end	
	
if nil ~= data["profile0"] and nil ~= data["profile0"]["proxyserverport"] then
	local voiceprofilesipparas = {{"ProxyServerPort", data["profile0"]["proxyserverport"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("proxyserverport set fail errcode "..errcode)
	end
end	

if nil ~= data["profile0"] and nil ~= data["profile0"]["registerserveraddress"] then
	local voiceprofilesipparas = {{"RegistrarServer", data["profile0"]["registerserveraddress"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("registerserveraddress set fail errcode "..errcode)
	end
end		

if nil ~= data["profile0"] and nil ~= data["profile0"]["registerserverport"] then
	local voiceprofilesipparas = {{"RegistrarServerPort", data["profile0"]["registerserverport"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("registerserverport set fail errcode "..errcode)
	end
end	

if nil ~= data["profile0"] and nil ~= data["profile0"]["sipserverdomain"] then
	local voiceprofilesipparas = {{"X_SIPDomain", data["profile0"]["sipserverdomain"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("sipserverdomain set fail errcode "..errcode)
	end
end	

if nil ~= data["profile0"] and nil ~= data["profile0"]["secondproxyserveraddress"] then
	local voiceprofilesipparas = {{"X_SecondProxyServer", data["profile0"]["secondproxyserveraddress"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("sipserverdomain set fail errcode "..errcode)
	end
end

if nil ~= data["profile0"] and nil ~= data["profile0"]["secondproxyserverport"] then
	local voiceprofilesipparas = {{"X_SecondProxyServerPort", data["profile0"]["secondproxyserverport"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("secondproxyserverport set fail errcode "..errcode)
	end
end

if nil ~= data["profile0"] and nil ~= data["profile0"]["secondsipserverdomain"] then
	local voiceprofilesipparas = {{"X_SecondSIPDomain", data["profile0"]["secondsipserverdomain"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("secondsipserverdomain set fail errcode "..errcode)
	end
end

if nil ~= data["profile0"] and nil ~= data["profile0"]["secondregisterserveraddress"] then
	local voiceprofilesipparas = {{"X_SecondRegistrarServer", data["profile0"]["secondregisterserveraddress"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("secondregisterserveraddress set fail errcode "..errcode)
	end
end

if nil ~= data["profile0"] and nil ~= data["profile0"]["secondregisterserverport"] then
	local voiceprofilesipparas = {{"X_SecondRegistrarServerPort", data["profile0"]["secondregisterserverport"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("secondregisterserverport set fail errcode "..errcode)
	end
end

if nil ~= data["profile0"] and nil ~= data["profile0"]["outboudproxy"] then
	local voiceprofilesipparas = {{"OutboundProxy", data["profile0"]["outboudproxy"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("outboudproxy set fail errcode "..errcode)
	end
end

if nil ~= data["global0"] and nil ~= data["global0"]["registerexpires"] then
	local voiceprofilesipparas = {{"RegisterExpires", data["global0"]["registerexpires"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("registerexpires set fail errcode "..errcode)
	end
end
	
if nil ~= data["global0"] and nil ~= data["global0"]["pracksupport"] then
	local voiceprofilesipparas = {{"X_PrackSupport", data["global0"]["pracksupport"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("pracksupport set fail errcode "..errcode)
	end
end	

if nil ~= data["global0"] and nil ~= data["global0"]["urgencepriority"] then
	local voiceprofilesipparas = {{"X_UrgencyUsePriority", data["global0"]["urgencepriority"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("urgencepriority set fail errcode "..errcode)
	end
end		

if nil ~= data["global0"] and nil ~= data["global0"]["sessionexpires"] then
	local voiceprofilesipparas = {{"X_SessionExpires", data["global0"]["sessionexpires"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("sessionexpires set fail errcode "..errcode)
	end
end		

if nil ~= data["global0"] and nil ~= data["global0"]["minisessionexpires"] then
	local voiceprofilesipparas = {{"X_MinSessionExpires", data["global0"]["minisessionexpires"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("minisessionexpires set fail errcode "..errcode)
	end
end		

if nil ~= data["global0"] and nil ~= data["global0"]["holdmethod"] then
	local voiceprofilesipparas = {{"X_HoldMethod", data["global0"]["holdmethod"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("holdmethod set fail errcode "..errcode)
	end
end		

if nil ~= data["global0"] and nil ~= data["global0"]["interfacename"] then
	local voiceprofilesipparas = {{"X_InterfaceName", data["global0"]["interfacename"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("interfacename set fail errcode "..errcode)
	end
end		

if nil ~= data["profile0"] and nil ~= data["profile0"]["outboudport"] then
	local voiceprofilesipparas = { {"OutboundProxyPort", data["profile0"]["outboudport"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilesipdomin,voiceprofilesipparas)
	if errcode ~= 0 then
		print("outboudport set fail errcode "..errcode)
	end
end	
	
--设置option相关的参数
local voiceprofileoptiontimedomin = "InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid..".SIP.X_OptionTime."
if nil ~= data["global0"] and nil ~= data["global0"]["optionchecktype"] then
	local voiceprofileoptiontimeparas = { {"OptionsType", data["global0"]["optionchecktype"]} } 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofileoptiontimedomin,voiceprofileoptiontimeparas)
	if errcode ~= 0 then
		print("OptionsType set fail errcode "..errcode)
	end
end	

if nil ~= data["global0"] and nil ~= data["global0"]["optionchecktime"] then
	local voiceprofileoptiontimeparas = { {"IntervalTime", data["global0"]["optionchecktime"]} } 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofileoptiontimedomin,voiceprofileoptiontimeparas)
	if errcode ~= 0 then
		print("optionchecktime set fail errcode "..errcode)
	end
end	

-- 设置dplan参数
local voiceprofilenumberingplandomin = "InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid..".NumberingPlan."

if nil ~= data["global0"] and nil ~= data["global0"]["inerdigitimershort"] then
	local voiceprofilenumberingplanparas = { {"InterDigitTimerShort", data["global0"]["inerdigitimershort"]} } 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilenumberingplandomin,voiceprofilenumberingplanparas)
	if errcode ~= 0 then
		print("inerdigitimershort set fail errcode "..errcode)
	end
end	

if nil ~= data["global0"] and nil ~= data["global0"]["inerdigitimerlong"] then
	local voiceprofilenumberingplanparas = { {"InterDigitTimerLong", data["global0"]["inerdigitimerlong"]} } 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilenumberingplandomin,voiceprofilenumberingplanparas)
	if errcode ~= 0 then
		print("inerdigitimerlong set fail errcode "..errcode)
	end
end

if nil ~= data["global0"] and nil ~= data["global0"]["startdigittimerstd"] then
	local voiceprofilenumberingplanparas = { {"X_StartDigitTimerStd", data["global0"]["startdigittimerstd"]} } 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilenumberingplandomin,voiceprofilenumberingplanparas)
	if errcode ~= 0 then
		print("startdigittimerstd set fail errcode "..errcode)
	end
end

if nil ~= data["global0"] and nil ~= data["global0"]["unresponseinterval"] then
	local voiceprofilenumberingplanparas = { {"X_UnResponseInterval", data["global0"]["unresponseinterval"]} } 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilenumberingplandomin,voiceprofilenumberingplanparas)
	if errcode ~= 0 then
		print("unresponseinterval set fail errcode "..errcode)
	end
end

if nil ~= data["global0"] and nil ~= data["global0"]["howltonetime"] then
	local voiceprofilenumberingplanparas = { {"X_HowlToneTime", data["global0"]["howltonetime"]} } 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilenumberingplandomin,voiceprofilenumberingplanparas)
	if errcode ~= 0 then
		print("howltonetime set fail errcode "..errcode)
	end
end

if nil ~= data["global0"] and nil ~= data["global0"]["busytonetime"] then
	local voiceprofilenumberingplanparas = { {"X_BusyToneTime", data["global0"]["busytonetime"]} } 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilenumberingplandomin,voiceprofilenumberingplanparas)
	if errcode ~= 0 then
		print("busytonetime set fail errcode "..errcode)
	end
end

if nil ~= data["global0"] and nil ~= data["global0"]["urgenceroute"] then
	local voiceprofilenumberingplanparas = { {"X_EmergencyRoute", data["global0"]["urgenceroute"]} } 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilenumberingplandomin,voiceprofilenumberingplanparas)
	if errcode ~= 0 then
		print("urgenceroute set fail errcode "..errcode)
	end
end

if nil ~= data["global0"] and nil ~= data["global0"]["urgencerouteaccount"] then
	local voiceprofilenumberingplanparas = { {"X_EmergencyRouteAccount", data["global0"]["urgencerouteaccount"]} } 
	local errcode, paramErrs = dm.SetObjToDB(voiceprofilenumberingplandomin,voiceprofilenumberingplanparas)
	if errcode ~= 0 then
		print("urgencerouteaccount set fail errcode "..errcode)
	end
end

--line节点
local errcode, linenum, linearray = dm.GetObjNum("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid..".Line.{i}.")
print("linenum "..linenum)

if errcode == 0 and linenum ~= 0 and linearray ~= nil then
	for k,v in pairs(linearray) do
		lineinstid = v
		break
	end
end

if 0 == linenum then
	local voicelineparas = {{"Enable", data["line0"]["enable"]},
						   {"X_LineSeq", data["line0"]["seq"]},
                           {"DirectoryNumber", data["line0"]["directorynumber"]},  
						   {"X_ClipEnable", data["line0"]["clipenable"]},
						   {"X_FaxOption", data["line0"]["faxoption"]},
						   {"X_FaxDetectType", data["line0"]["faxdetecttype"]},
						   {"X_BusyOnBusy", data["line0"]["busyonbusy"]}
                          } 
	errcode, lineinstid, paramerr= dm.AddObjectToDB("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid..".Line.", voicelineparas)
	if errcode ~= 0 then
		print("voicelineparas add fail errcode "..errcode)
	end	
else
	print("lineinstid "..lineinstid)
	local voicelinedomin = "InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid..".Line."..lineinstid.."."
	
	if nil ~= data["line0"] and nil ~= data["line0"]["enable"] then
		local voicelineparas = { {"Enable", data["line0"]["enable"]} } 
		local errcode, paramErrs = dm.SetObjToDB(voicelinedomin,voicelineparas)
		if errcode ~= 0 then
			print("enable set fail errcode "..errcode)
		end
	end
	
	if nil ~= data["line0"] and nil ~= data["line0"]["seq"] then
		local voicelineparas = { {"X_LineSeq", data["line0"]["seq"]} } 
		local errcode, paramErrs = dm.SetObjToDB(voicelinedomin,voicelineparas)
		if errcode ~= 0 then
			print("seq set fail errcode "..errcode)
		end
	end	
	
	if nil ~= data["line0"] and nil ~= data["line0"]["directorynumber"] then
		local voicelineparas = { {"DirectoryNumber", data["line0"]["directorynumber"]} } 
		local errcode, paramErrs = dm.SetObjToDB(voicelinedomin,voicelineparas)
		if errcode ~= 0 then
			print("directorynumber set fail errcode "..errcode)
		end
	end	
	
	if nil ~= data["line0"] and nil ~= data["line0"]["clipenable"] then
		local voicelineparas = { {"X_ClipEnable", data["line0"]["clipenable"]} } 
		local errcode, paramErrs = dm.SetObjToDB(voicelinedomin,voicelineparas)
		if errcode ~= 0 then
			print("clipenable set fail errcode "..errcode)
		end
	end	
	
	if nil ~= data["line0"] and nil ~= data["line0"]["faxoption"] then
		local voicelineparas = { {"X_FaxOption", data["line0"]["faxoption"]} } 
		local errcode, paramErrs = dm.SetObjToDB(voicelinedomin,voicelineparas)
		if errcode ~= 0 then
			print("faxoption set fail errcode "..errcode)
		end
	end	
	
	if nil ~= data["line0"] and nil ~= data["line0"]["faxdetecttype"] then
		local voicelineparas = { {"X_FaxDetectType", data["line0"]["faxdetecttype"]} } 
		local errcode, paramErrs = dm.SetObjToDB(voicelinedomin,voicelineparas)
		if errcode ~= 0 then
			print("faxdetecttype set fail errcode "..errcode)
		end
	end	

	if nil ~= data["line0"] and nil ~= data["line0"]["busyonbusy"] then
		local voicelineparas = { {"X_BusyOnBusy", data["line0"]["busyonbusy"]} } 
		local errcode, paramErrs = dm.SetObjToDB(voicelinedomin,voicelineparas)
		if errcode ~= 0 then
			print("busyonbusy set fail errcode "..errcode)
		end
	end		
end

local voicelinesipdomin = "InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid..".Line."..lineinstid..".SIP."

if nil ~= data["line0"] and nil ~= data["line0"]["username"] then
	local voiceusername = sys.decodeXMLPara(data["line0"]["username"])
	local voicelinesipparas = { {"AuthUserName", voiceusername} } 
	local errcode, paramErrs = dm.SetObjToDB(voicelinesipdomin,voicelinesipparas)
	if errcode ~= 0 then
		print("username set fail errcode "..errcode)
	end
end	

if nil ~= data["line0"] and nil ~= data["line0"]["password"] then
	local voicepassword = sys.decodeXMLPara(data["line0"]["password"])
	local voicelinesipparas = { {"AuthPassword", voicepassword}} 
	local errcode, paramErrs = dm.SetObjToDB(voicelinesipdomin,voicelinesipparas)
	if errcode ~= 0 then
		print("password set fail errcode "..errcode)
	end
end	
						 
local voicelinecallfeaturedomin = "InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid..".Line."..lineinstid..".CallingFeatures." 						  
if nil ~= data["line0"] and nil ~= data["line0"]["wmienable"] then
	local voicelinecallfeatureparas = { {"MWIEnable", data["line0"]["wmienable"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voicelinecallfeaturedomin,voicelinecallfeatureparas)
	if errcode ~= 0 then
		print("wmienable set fail errcode "..errcode)
	end
end	
						 
if nil ~= data["line0"] and nil ~= data["line0"]["uaprofileenable"] then
	local voicelinecallfeatureparas = { {"X_UaProfileEnable", data["line0"]["uaprofileenable"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voicelinecallfeaturedomin,voicelinecallfeatureparas)
	if errcode ~= 0 then
		print("uaprofileenable set fail errcode "..errcode)
	end
end	

if nil ~= data["line0"] and nil ~= data["line0"]["calltransferenable"] then
	local voicelinecallfeatureparas = { {"CallTransferEnable", data["line0"]["calltransferenable"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voicelinecallfeaturedomin,voicelinecallfeatureparas)
	if errcode ~= 0 then
		print("calltransferenable set fail errcode "..errcode)
	end
end	

if nil ~= data["line0"] and nil ~= data["line0"]["callwaitingenable"] then
	local voicelinecallfeatureparas = { {"CallTransferEnable", data["line0"]["callwaitingenable"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voicelinecallfeaturedomin,voicelinecallfeatureparas)
	if errcode ~= 0 then
		print("callwaitingenable set fail errcode "..errcode)
	end
end	

local voicelinecallprocessdomin = "InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid..".Line."..lineinstid..".VoiceProcessing."						  
if nil ~= data["line0"] and nil ~= data["line0"]["echocancelenable"] then
	local voicelinecallprocessparas = { {"EchoCancellationEnable", data["line0"]["echocancelenable"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voicelinecallprocessdomin,voicelinecallprocessparas)
	if errcode ~= 0 then
		print("echocancelenable set fail errcode "..errcode)
	end
end							  

if nil ~= data["line0"] and nil ~= data["line0"]["comfortnoisegeneration"] then
	local voicelinecallprocessparas = { {"X_ComfortNoiseGeneration", data["line0"]["comfortnoisegeneration"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voicelinecallprocessdomin,voicelinecallprocessparas)
	if errcode ~= 0 then
		print("comfortnoisegeneration set fail errcode "..errcode)
	end
end

if nil ~= data["global0"] and nil ~= data["global0"]["tansmitgain"] then
	local voicelinecallprocessparas = { {"TransmitGain", data["global0"]["tansmitgain"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voicelinecallprocessdomin,voicelinecallprocessparas)
	if errcode ~= 0 then
		print("tansmitgain set fail errcode "..errcode)
	end
end

if nil ~= data["global0"] and nil ~= data["global0"]["receivegain"] then
	local voicelinecallprocessparas = { {"ReceiveGain", data["global0"]["receivegain"]}} 
	local errcode, paramErrs = dm.SetObjToDB(voicelinecallprocessdomin,voicelinecallprocessparas)
	if errcode ~= 0 then
		print("receivegain set fail errcode "..errcode)
	end
end
						
--linecodec节点
--定制的codec数目
local customcodecnum = 0
local codecinst = {}
local codecvalue = {}
if nil ~= data["codec0"] and nil ~= data["codec1"] and nil ~= data["codec2"] and nil ~= data["codec3"] and nil ~= data["codec4"] and nil ~= data["codec5"] then
for i=0,5 do
	if data["codec"..i] ~= nil then
		customcodecnum = customcodecnum + 1
		local codec = data["codec"..i]["codec"]
		s1,e1 = string.find(codec, "G.711") 
		s2,e2 = string.find(codec, "A") 
		s3,e3 = string.find(codec, "a")
		s4,e4 = string.find(codec, "U")
		s5,e5 = string.find(codec, "u")
		s6,e6 = string.find(codec, "G.726")
		s7,e7 = string.find(codec, "24")
		s8,e8 = string.find(codec, "32")
		s9,e9 = string.find(codec, "G.729")
		s10,e10 = string.find(codec, "G.722")
		if s2 ~= nil or s3 ~= nil and s1 ~= nil then
			data["codec"..i]["codec"] = "G.711ALaw"
		end
		if s4 ~= nil or s5 ~= nil and s1 ~= nil then
			data["codec"..i]["codec"] = "G.711MuLaw"
		end
		if s6 ~= nil and s7 ~= nil then
			data["codec"..i]["codec"] = "G.726-24"
		end
		if s6 ~= nil and s8 ~= nil then
			data["codec"..i]["codec"] = "G.726-32"
		end
		if s9 ~= nil then
			data["codec"..i]["codec"] = "G.729"
		end
		if s10 ~= nil then
			data["codec"..i]["codec"] = "G.722"
		end
		print("custom codec "..data["codec"..i]["codec"])
	end
end
print("customcodecnum "..customcodecnum)	
local errcode, codecnum, codecarray = dm.GetObjNum("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid..".Line."..lineinstid..".Codec.List.{i}.")
print("codecnum "..codecnum)

if codecnum == 0 then
	--数据库里codec数目为0，需要添加
	for i=0, (customcodecnum-1) do
		local voicelinecodecparas = {{"SilenceSuppression", data["codec"..i]["sliencesuppression"]}, 
							{"PacketizationPeriod", data["codec"..i]["packetizationperiod"]},
							{"Codec", data["codec"..i]["codec"]},
							{"Enable", data["codec"..i]["enable"]},
							{"Priority", data["codec"..i]["priority"]}
							}
		errcode, codecinstid, paramerr= dm.AddObjectToDB("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid..".Line."..lineinstid..".Codec.List.", voicelinecodecparas)
		if errcode ~= 0 then
			print("voicelinecodecparas add fail errcode "..errcode)
		end	
	end
else
	--数据库里面有codeclist数据，需要设置
	if errcode == 0 and codecnum ~= 0 and codecarray ~= nil then
		for k,v in pairs(codecarray) do
			codecinst[k+1] = v
		end
	end

	for i=1, codecnum do
		local errcode, codecobj = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid..".Line."..lineinstid..".Codec.List."..codecinst[i]..".",{ "Codec" })
		if codecobj ~= nil then
			for k,v in pairs(codecobj) do
				codecvalue[codecinst[i]] = v["Codec"]
				print("codecvalue "..codecvalue[codecinst[i]])
				break
			end
		end
	end
	
	for i=1, codecnum do
		for j=0, (customcodecnum-1) do
			if codecvalue[codecinst[i]] == data["codec"..j]["codec"] then
				local voicelinecodecparas = {{"SilenceSuppression", data["codec"..j]["sliencesuppression"]}, 
							{"PacketizationPeriod", data["codec"..j]["packetizationperiod"]},
							{"Enable", data["codec"..j]["enable"]},
							{"Priority", data["codec"..j]["priority"]}
							}
				local codecdomain = "InternetGatewayDevice.Services.VoiceService.1.VoiceProfile."..profileinstid..".Line."..lineinstid..".Codec.List."..codecinst[i].."."
				local errcode, paramErrs = dm.SetObjToDB(codecdomain,voicelinecodecparas)
				if errcode ~= 0 then
					print("voicelinecodecparas set fail errcode "..errcode)
				end	
				break
			end
		end
	end
end
end

--voicePhyInterface
local voicephyinterface = "InternetGatewayDevice.Services.VoiceService.1.PhyInterface.1."
local voiceservicepath = "InternetGatewayDevice.Services.VoiceService.1."

if nil ~= data["global0"] and nil ~= data["global0"]["voipcsselect"] then

if data["global0"]["voipcsselect"] == "1" then
	--voipcsselect: 1-CS First, then VoIP
	local phyinterfaceparas1 = {{"X_IncomingLineList", "all"}}
	local phyinterfaceparas2 = {{"X_OutgoingLineList", "CS"}}

	if nil ~= data["line0"]and nil ~= data["line0"]["directorynumber"] then
		if "" ~= data["line0"]["directorynumber"] then
			--phyinterfaceparas1[1][2] = "CS,"..data["line0"]["directorynumber"]
			phyinterfaceparas2[1][2] = "CS,"..data["line0"]["directorynumber"]
		end
	end

	local errcode1, paramErrs1 = dm.SetObjToDB(voicephyinterface, phyinterfaceparas1)
	if errcode1 ~= 0 then
		print("set Phy Interface fail errcode "..errcode1)
	end
	
	local errcode2, paramErrs2 = dm.SetObjToDB(voicephyinterface, phyinterfaceparas2)
	if errcode2 ~= 0 then
		print("set Phy Interface fail errcode "..errcode2)
	end

elseif data["global0"]["voipcsselect"] == "2" then
	--voipcsselect: 2-VoIP only
	local phyinterfaceparas1 = {{"X_IncomingLineList", "all"}}
	local phyinterfaceparas2 = {{"X_OutgoingLineList", ""}}

	if nil ~= data["line0"]and nil ~= data["line0"]["directorynumber"] then
		if "" ~= data["line0"]["directorynumber"] then
			--phyinterfaceparas1[1][2] = data["line0"]["directorynumber"]
			phyinterfaceparas2[1][2] = data["line0"]["directorynumber"]
		end
	end

	local errcode1, paramErrs1 = dm.SetObjToDB(voicephyinterface, phyinterfaceparas1)
	if errcode1 ~= 0 then
		print("set Phy Interface fail errcode "..errcode1)
	end
	
	local errcode2, paramErrs2 = dm.SetObjToDB(voicephyinterface, phyinterfaceparas2)
	if errcode2 ~= 0 then
		print("set Phy Interface fail errcode "..errcode2)
	end

elseif data["global0"]["voipcsselect"] == "3" then
	--voipcsselect: 3-CS only
	local phyinterfaceparas1 = {{"X_IncomingLineList", "all"}}
	local phyinterfaceparas2 = {{"X_OutgoingLineList", "CS"}}

	local errcode1, paramErrs1 = dm.SetObjToDB(voicephyinterface, phyinterfaceparas1)
	if errcode1 ~= 0 then
		print("set Phy Interface fail errcode "..errcode1)
	end
	
	local errcode2, paramErrs2 = dm.SetObjToDB(voicephyinterface, phyinterfaceparas2)
	if errcode2 ~= 0 then
		print("set Phy Interface fail errcode "..errcode2)
	end

else
	--voipcsselect: 0(&>3)-VoIP First, then CS
	local phyinterfaceparas1 = {{"X_IncomingLineList", "all"}}
	local phyinterfaceparas2 = {{"X_OutgoingLineList", "auto"}}

	local errcode1, paramErrs1 = dm.SetObjToDB(voicephyinterface, phyinterfaceparas1)
	if errcode1 ~= 0 then
		print("set Phy Interface fail errcode "..errcode1)
	end
	
	local errcode2, paramErrs2 = dm.SetObjToDB(voicephyinterface, phyinterfaceparas2)
	if errcode2 ~= 0 then
		print("set Phy Interface fail errcode "..errcode2)
	end
	
end
end

print("voice config end 1")
function SetObjParamInputs(data, maps)
    local inputs = {}
    for k, v in pairs(maps) do
        local param = {}
        if nil ~= data and nil ~= data[k] then
          param["key"] = v      
          param["value"] = data[k]
          table.insert(inputs, param)
        end  
    end
    return inputs
end
local multiwandomin = "InternetGatewayDevice.X_Config.dialup.multiwan.3."
local multiwanmaps = {
    roam_connect="roam_connect",
    use_internet_profile = "enable",	
}
local param = SetObjParamInputs(data, multiwanmaps)
local errcode, paramErrs = dm.SetObjToDB(multiwandomin,param)
if errcode ~= 0 then
   print("voice set multiwan errcode = ", errcode)
end

local umtsWandomin = ""
function getUmtswan()
	for i = 1, 5 do
		local errcode, accessdevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice."..i..".WANCommonInterfaceConfig.", {"WANAccessType"})
		if nil ~= accessdevs then
			for k, v in pairs(accessdevs) do
				if "UMTS" == v["WANAccessType"] then
					umtsWandomin = k
					local start = string.find(umtsWandomin, ".WANCommonInterfaceConfig.")
				    if start then
						umtsWandomin = string.sub(umtsWandomin, 0, start)
					end
					umtsWandomin = umtsWandomin.."WANConnectionDevice."
					return 
				end
			end

		end
	end
end

function addvoicetointernetservicelist()
	local internetwan = umtsWandomin.."1.WANPPPConnection.1."
	local errcode, servicelist = dm.GetParameterValues(internetwan, {"X_ServiceList"})
	local internetservicelist = servicelist[internetwan]["X_ServiceList"]
	local addservicelist = internetservicelist.."_VOICE"
	print("setvoice to ", addservicelist)
	local specialparam = {{"X_ServiceList", addservicelist}}
	local errcode, paramErrs = dm.SetObjToDB(internetwan, specialparam)
	if (0 ~= errcode) then
		print("errcode = "..errcode)
	end
end

function delvoicetointernetservicelist()
	local internetwan = umtsWandomin.."1.WANPPPConnection.1."
	local errcode, servicelist = dm.GetParameterValues(internetwan, {"X_ServiceList"})
	local internetservicelist = servicelist[internetwan]["X_ServiceList"]
	--把入参1字符串internetservicelist，里面所有入参2"_VOICE"，用入参3“”替换，达到删除所有"_VOICE"的目的
	local delservicelist = string.gsub(internetservicelist, "_VOICE", "")
	print("setvoice to ",  delservicelist)
	local specialparam = {{"X_ServiceList", delservicelist}}
	local errcode, paramErrs = dm.SetObjToDB(internetwan, specialparam)
	if (0 ~= errcode) then
		print("delvoiceinternetservicelist errcode = "..errcode)
	end
end

function setmultilwanenablestatus(status)
	local voicewan = umtsWandomin.."4.WANPPPConnection.1."
	local specialparam = {{"Enable", status}}
	local errcode, paramErrs = dm.SetObjToDB(voicewan, specialparam)
	if (0 ~= errcode) then
		print("errcode = "..errcode)
	end
end

function issuportvoice()
    return 0
end

function setethvoiceservicelist(internetwan)
    local errcode, servicelist = dm.GetParameterValues(internetwan, {"X_ServiceList"})
    local internetservicelist = servicelist[internetwan]["X_ServiceList"]
    local addservicelist = internetservicelist.."_VOICE"
    local specialparam = {{"X_ServiceList", addservicelist}}
    local errcode, paramErrs = dm.SetObjToDB(internetwan, specialparam)
    if (0 ~= errcode) then
        print("errcode = "..errcode)
    end 
end

function delethvoiceservicelist(internetwan)
	local errcode, servicelist = dm.GetParameterValues(internetwan, {"X_ServiceList"})
	local internetservicelist = servicelist[internetwan]["X_ServiceList"]
	local servicepath = string.find(internetservicelist, "_VOICE")
	if(servicepath) then
		local delservicelist = string.gsub(internetservicelist, "_VOICE", "")
		print("delethvoiceservicelist, set to ",  delservicelist)
		local specialparam = {{"X_ServiceList", delservicelist}}
		local errcode, paramErrs = dm.SetObjToDB(internetwan, specialparam)
		if (0 ~= errcode) then
			print("delvoiceinternetservicelist errcode = "..errcode)
		end
	end
end

function setWANIPService(dailtype, isadd)
    local errcode,ipCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANIPConnection.{i}.", { "X_AutoFlag","Enable"})
    local ret = 0
    if nil ~= ipCon then
        for k,v in pairs(ipCon) do
            if nil ~= v["X_AutoFlag"] then
                if utils.toboolean(v["X_AutoFlag"]) and (1 == v["Enable"]) then
                    ret = utils.IfIpWanNeedAddService(dailtype, k, "VOICE") 
                    if 1 == ret and 1 == isadd then
                        setethvoiceservicelist(k)
                        print("voice set to ethservice ipCon ok", k)
                    end
                    if 0 == ret and 0 == isadd then
                        delethvoiceservicelist(k)
                        print("del voice from ethservice ipCon ok", k)
                    end					
                end
            end
        end
    else
        print("can't find wanpath")
    end
end

function setWANPPPService(dailtype, isadd)
    local errcode,pppCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}.", { "X_AutoFlag","Enable"})
    local ret = 0
    if nil ~= pppCon then
        for k,v in pairs(pppCon) do
            if nil ~= v["X_AutoFlag"] then
                if utils.toboolean(v["X_AutoFlag"]) and (1 == v["Enable"]) then
                    ret = utils.IfPppWanNeedAddService(dailtype, k, "VOICE")
                    if 1 == ret and 1 == isadd then
                        setethvoiceservicelist(k)
                        print("voice set to ethservice pppCon ok", k)
                    end
                    if 0 == ret and 0 == isadd then
                        delethvoiceservicelist(k)
                        print("del voice from ethservice pppCon ok", k)
                    end					
                end
            end
        end
    else
        print("can't find wanpath")
    end
end

--1.刷新原来的voice wan的X_ServiceList(VOICE->Custom)
--注意:目前写死的umts这条wan是voice,如果未来默认配置xml中eth wan配置成voice,整个lua需要重写
function SetCurrentVoiceToCustom()
    local voicewan = umtsWandomin.."4.WANPPPConnection.1."
    local servicetype = {{"X_ServiceList", "Custom"}}
    local errcode, paramErrs = dm.SetObjToDB(voicewan, servicetype)
    print("voiceconfig: first set voice to Custom")
    if (0 ~= errcode) then
        print("voiceconfig: set servicelist to be Custom errcode = "..errcode)
    end
     
    --设置umts wan disable,不允许其拨号
    local voice_enable = {{"Enable", 0}}
    local errcode, paramErrs = dm.SetObjToDB(voicewan, voice_enable)
    print("voiceconfig: first set voice to disable")
    if (0 ~= errcode) then
        print("voiceconfig:set umts wan to be disable errcode = "..errcode)
    end
end

function SetCurrentCustomToVoice()
    local internetwan = umtsWandomin.."4.WANPPPConnection.1."
    local errcode, servicelist = dm.GetParameterValues(internetwan, {"X_ServiceList"})
    if nil ~= servicelist then
        local internetservicelist = servicelist[internetwan]["X_ServiceList"]
        local servicepath = string.find(internetservicelist, "Custom")
        if(servicepath) then
            local voicewan = umtsWandomin.."4.WANPPPConnection.1."
            local servicetype = {{"X_ServiceList", "VOICE"}}
            local errcode, paramErrs = dm.SetObjToDB(voicewan, servicetype)
            print("first set custom to voice")
            if (0 ~= errcode) then
                print("errcode = "..errcode)
            end

            --设置umts wan disable,允许其拨号
            local voice_enable = {{"Enable", 1}}
            local errcode, paramErrs = dm.SetObjToDB(voicewan, voice_enable)
            print("SetCurrentCustomToVoice: first set VOICE to enable")
            if (0 ~= errcode) then
                print("SetCurrentCustomToVoice:set umts wan to be enable errcode = "..errcode)
            end
        end
    end
end

--2.刷新所有eth wan的X_ServiceList,采取尾部添加_VOICE的方式,原来已经包含VOICE字段时无需处理
function SetEthInternetWanToVoice()
    setWANIPService("Ethernet",1)
    setWANPPPService("Ethernet",1)
end

function DelEthInternetWanVoice()
    setWANIPService("Ethernet",0)
    setWANPPPService("Ethernet",0)
end
--voice业务使用以太上行总入口
function AddVoiceToEthInternetWanService()
    SetCurrentVoiceToCustom()
    SetEthInternetWanToVoice()
end

--设置profile显示
function SetProfileDisplay(status)
    local voiceprofile = "InternetGatewayDevice.X_Config.profiledisplay."
	local specialparam = {{"voice_display", status}}
	local errcode, paramErrs = dm.SetObjToDB(voiceprofile, specialparam)
	if (0 ~= errcode) then
		print("errcode = "..errcode)
	end
end

--设置拨号voice use internet profile flag
function SetVoiceUseInternetProfileFlag(status)
    local dialupvoiceuseinternet = "InternetGatewayDevice.X_Config.dialup."
	local specialparam = {{"voice_useinternetprofile", status}}
	local errcode, paramErrs = dm.SetObjToDB(dialupvoiceuseinternet, specialparam)
	if (0 ~= errcode) then
		print("errcode = "..errcode)
	end
end

if nil ~= data then
	getUmtswan()
	local status = issuportvoice()
	print("voice status ", status)
	if 1 == status then
		if nil ~= data["use_internet_profile"] then
			if '1' == data["use_internet_profile"] then
				--先删除umts wan servicelist所有“_VOICE”后缀
				delvoicetointernetservicelist()
				--再添加“_VOICE”后缀
				addvoicetointernetservicelist()
				setmultilwanenablestatus(0)
				SetVoiceUseInternetProfileFlag(1)
			end
			if '0' == data["use_internet_profile"] then
				--把umts wan servicelist INTERNET后面加的_VOICE字段全部删掉
				delvoicetointernetservicelist()
				--把默认VOICE WAN使能，这个不用使能，因为下面enable会使能
				--setmultilwanenablestatus(1)
				SetVoiceUseInternetProfileFlag(0)
			end
		end	
		
		if '0' == data["enable"] then
			setmultilwanenablestatus(0)
			--先删除umts wan servicelist所有“_VOICE”后缀
			delvoicetointernetservicelist()
			SetVoiceUseInternetProfileFlag(0)
		elseif '1' == data["enable"] then                                                  
			setmultilwanenablestatus(1)
			
			--如果voice业务使用以太上行,需要做两件事情:
			--1.刷新原来的voice wan的X_ServiceList(VOICE->Custom)
			--2.刷新所有eth wan的X_ServiceList,采取尾部添加_VOICE的方式,原来已经包含VOICE字段时无需处理
		   if nil ~= data["only_use_eth_internet_wan"] then
			if '1' == data["only_use_eth_internet_wan"] then
			    AddVoiceToEthInternetWanService()
			end
			if '0' == data["only_use_eth_internet_wan"] then
			    SetCurrentCustomToVoice()
			    DelEthInternetWanVoice()
			end
		   end
		end
		if '1' == data["profile_display"] then
				SetProfileDisplay(1)
		elseif '0' == data["profile_display"] then
				SetProfileDisplay(0)
		end
    else
--- not support VOICE
	delvoicetointernetservicelist()
	SetVoiceUseInternetProfileFlag(0)
	DelEthInternetWanVoice()
	end
end
print("voice config end 2")