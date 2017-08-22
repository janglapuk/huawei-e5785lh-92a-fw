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

local dtmfmethod = {}
local response = {}

local errcode, dtmfmethod_value = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.{i}.VoiceProfile.{i}.", {"DTMFMethod"});
if nil ~= dtmfmethod_value then
    for k, dtmfmethod_info in pairs(dtmfmethod_value) do     
	   response.dtmfmethod = dtmfmethod_info["DTMFMethod"]	
	end
else
    print("!!! errcode"..errcode)
end

local errcode, EchoCancel_value = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.{i}.VoiceProfile.{i}.Line.{i}.VoiceProcessing.", {"EchoCancellationEnable"});
if nil ~= EchoCancel_value then
	for k, EchoCancel_info in pairs(EchoCancel_value) do		
		response.EchoCancellationEnable = EchoCancel_info["EchoCancellationEnable"]		
	end
else
	print("!!! errcode"..errcode)
end

local errcode, faxoption_value = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.{i}.VoiceProfile.{i}.Line.{i}.", {"X_FaxOption"});
if nil ~= faxoption_value then
	for k, faxoption_info in pairs(faxoption_value) do		
		response.faxoption = faxoption_info["X_FaxOption"]		
	end
else
	print("!!! errcode"..errcode)
end

local errcode, voipcsselect_value = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.{i}.X_CommonConfig.", {"X_Voipcsselect"});
if nil ~= voipcsselect_value then
	for k, voipcsselect_info in pairs(voipcsselect_value) do		
		response.voipcsselect = voipcsselect_info["X_Voipcsselect"]		
	end
else
	print("!!! errcode"..errcode)
end

sys.print(json.xmlencodex(response))
