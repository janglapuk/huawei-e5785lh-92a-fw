local utils = require('utils')
require('dm')

local customercfg = ""
local tmpstr = ""

local ue_map = {
	CallWaitEnable="1_1=",
	MultiCallEnable="1_2=",
	ConferenceEnable="1_3=",
	CallTransferEnable="1_4=",
	OnHookEctEnable="1_5=",
	CidMode="1_6=", 
	DialToneMode="1_7=", 
	PortBindingMode="1_8=",
	FskDisplayMode="1_9=",
	OnHookEctExtEnable="1_10=",
	OnHookPlayToneMode="1_11=",
	IncomOutgoComb="1_12=",
	PlayTongReferResponsecode="1_13=",
	CallFeatureCustom="1_14=",
	PortRingInterval="1_15=",
	VoIPLedCustom="1_16=",
	MinFlashCustom="",  --"1_17="
	MaxFlashCustom="",  --"1_18="
	FastBusyToneTime="1_19=",
	PlaySelectToneDisabled="1_20=",
	VoxInnerNumEnable="1_21=",
	VoxInnerCTRInConference="1_22=",
	TRGainCustom="1_23=",
	FlashSimplified="1_24=",
}

local sip_map = {
	InfoMessageBodyMethod="2_1=",
	SpecCharTransformString="2_2=",
	GetRemoteUserFromHeaderPAI="2_3=",
	UriAddUserParameter="2_4=",
	DTMF2833PayloadType="2_5=",
	SdpAddXAttr="2_6=",
	OverlapEnable="2_7=",
	FisrtRegisterAddInit="2_8=",
	RegisterSupportSubscription="2_9=",
	SupportSIPLocalPort="2_10=",
	Conferencefocus="2_11=",
	FaxSdpAttrStr="",   --"2_12="
	ModemSdpAttrStr="",   --"2_13="
	SIPDSCPMark="2_14=",
	RTPDSCPMark="2_15=",
	SupportDNSSRV="2_16=",
	SupportCallNoRespSwitchBackup="2_17=",
	SupportInviteAddPrivacy="2_18=",
	SupportCodecCapabilityMode="2_19=",
	SupportLogNumberHided="2_20=",
	SupportClirType="2_21=",
	FaxG711Only="2_22=",
}

local pbx_map = {
	AutoSwitchTobackgroundCallDurBusyTone="3_1=",
	BusyToneLastBeforeAutoSwitch="3_2=",
	DailShortAndLongTimerDisabled="3_3=",
	FlashStartNewOutgoingDisabled="3_4=",
	FilterRepeatedCalllog="3_5=",
}

local linemng_map = {
	SipMainRegisterServerPreferredUsing="4_1=",
	SipDeRegisterWhenServerSwitchBack="4_2=",
	SipRegisterRandomDelay="4_3=",
	LineMngSipRemoveBindByFirstRegisterFail="4_4=",
	SipRemoveBindForEachDomainServer="4_5=",
	SipSwitchDelayTimeBetweenIPs="4_6=",
	SipDelayTimeBetweenServers="4_7=",
	SipDelayTimeBetweenRounds="4_8=",
	SipDelayTimeForPollLineBusy="4_9=",
	CallDelayTimeForSipAccountChange="4_10=",
	SipDelayTimerAferDnsTTL0="4_11=",
	OptionsDetectProxy="4_12=",
	OptionsDependOnRegister="4_13=",
	OptionsDelayTimeBetweenIPs="4_14=",
	OptionsDelayTimeBetweenServers="4_15=",
	OptionsDelayTimeBetweenRounds="4_16=",
	SipIsResponseMeanAvailable="4_17=",
	SipDetectFlowInterval="4_18=",
	SipServerCustomize="4_19=",
	LineCodecList="4_20=",
	SipOptionDetectEnable="4_21=",
	UrgCallFromInternetEnable="4_22=",
	eUAPVersion="4_23=",
	ComfortNoiseGeneration="4_24=",
	RegExpireRegister="4_25=",
	SipRegDelay="4_26=",
	OpenEuapProvider="4_27=",
	VoiceFromInternetEnable="4_28=",
}

local dplan_map = {
	CfuActiveDM="5_1=",
	CfuDeactiveDM="5_2=",
	CfuCheckDM="5_3=",
	CfbActiveDM="5_4=",
	CfbDeactiveDM="5_5=",
	CfbCheckDM="5_6=",
	CfnrActiveDM="5_7=",
	CfnrDeactiveDM="5_8=",
	CfnrCheckDM="5_9=",
	McidDM="5_10=",
	CcbsActiveDM="5_11=",
	CcbsDeactiveDM="5_12=",
	CcbsCheckDM="5_13=",
	AnswerOtherPortCIDDM="5_14=",
	StartWlanDM="5_15=",
	StopWlanDM="5_16=",
	StartAnycallDM="5_17=",
	StopAnycallDM="5_18=",
	ClirCode="5_19=",
	ClipCode="5_20=",
	SipUrgCallPriorLogicFault="5_21=",
	EmergencyMapAddEnbale="5_22=",
	DplanMatchResultProcessMode="5_23=",
	CWActiveDM="5_24=",
	CWDeactiveDM="5_25=",
	RestrictCallAOActiveDM="5_26=",
	RestrictCallAODeactiveDM="5_27=",   
	RestrictCallOIActiveDM="5_28=",   
	RestrictCallOIDeactiveDM="5_29=",   
	RestrictCallOXActiveDM="5_30=",   --"5_30="
	RestrictCallOXDeactiveDM="5_31=",   --"5_31="
	RestrictCallAGDeactiveDM="5_32=",  --"5_32="
	RestrictCallABDeactiveDM="5_33=",   --"5_33="
	CfallDeactiveDM="5_34=",
	VolumeSettingDM="5_35=",   
	PWChangingDM="5_36=",  
	CWCheckDM="5_37=",   --"5_37="
	CSFunOpEnable="5_38=",
	CSModemUrgCodeEnable="5_39=",
}
		
for k, v in pairs(ue_map) do
    if "" ~= v then
	    tmpstr = v..data["UE"][k]..";"
	    customercfg = customercfg..tmpstr
	end	
end

for k, v in pairs(sip_map) do
	if "" ~= v then
		tmpstr = v..data["SIP"][k]..";"
		customercfg = customercfg..tmpstr
	end	
end

for k, v in pairs(pbx_map) do
	if "" ~= v then
		tmpstr = v..data["PBX"][k]..";"
		customercfg = customercfg..tmpstr
	end
end

for k, v in pairs(linemng_map) do
	if "" ~= v then
		tmpstr = v..data["LineMng"][k]..";"
		customercfg = customercfg..tmpstr
	end	
end

for k, v in pairs(dplan_map) do
	if "" ~= v then
		tmpstr = v..data["Dplan"][k]..";"
		customercfg = customercfg..tmpstr
	end
end

local length
length = string.len(customercfg)

if length < 2048 then
	customercfg = string.sub(customercfg, 1, length-1)
    --print("customercfg444 "..customercfg)

    local voiceservicedomin = "InternetGatewayDevice.Services.VoiceService.1."
    local voiceserviceparas = {{"X_CustomerProfile", customercfg}} 
    local errcode, paramErrs = dm.SetObjToDB(voiceservicedomin,voiceserviceparas)
    print("atpconfig.lua errcode "..errcode)
	return errcode, paramErrs
else
    print("customercfg too long "..length)
end
