local utils = require('utils')
require('dm')
require('web')
require('json')
require('utils')

local cs_dtmf_method = {}
local response = {}

local errcode, csdtmf_value = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.{i}.", {"X_UmtsDTMFMethod"});
if nil ~= csdtmf_value then
    for k, csdtmf_info in pairs(csdtmf_value) do  
		if csdtmf_info["X_UmtsDTMFMethod"] == "InBand" then
	       response.cs_dtmf_method = "0" 	
		end
        if csdtmf_info["X_UmtsDTMFMethod"] == "OutBand" then		   
		   response.cs_dtmf_method = "1"
		end
    end
else
    print("!!! errcode"..errcode)
end

local errcode, CIDSendType_value = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.{i}.X_CommonConfig.", {"X_CIDSendType"});
if nil ~= CIDSendType_value then
    for k, CIDSendType_info in pairs(CIDSendType_value) do       
	   response.cid_send_type = CIDSendType_info["X_CIDSendType"]	   
    end
else
    print("!!! errcode"..errcode)
end

sys.print(json.xmlencodex(response))

