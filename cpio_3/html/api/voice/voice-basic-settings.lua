require('dm')
require('utils')
require('sys')
local utils = require('utils')
local dtmf_method = {}
if data == nil then
	return
end

function createSubmitData(paras, k, _str)
	if  "cs_dtmf_method" == _str then		
		if nil ~= k and nil ~= data["cs_dtmf_method"] and ("0" == data["cs_dtmf_method"]) then
		utils.add_one_parameter(paras,  k.."X_UmtsDTMFMethod", "InBand")
	    end
		if nil ~= k and nil ~= data["cs_dtmf_method"] and ("1" == data["cs_dtmf_method"]) then
		utils.add_one_parameter(paras,  k.."X_UmtsDTMFMethod", "OutBand")
	    end	
	    return 0					
	end
	
	if  "cid_send_type" == _str then		
		if nil ~= k and nil ~= data["cid_send_type"] then
		utils.add_one_parameter(paras,  k.."X_CIDSendType", data["cid_send_type"])
	    end
	    return 0					
	end
end

function update(k,_str)	
	local paras = {}
	local errcode = createSubmitData(paras, k ,_str)
	if errcode ~= 0 then
		return errcode
	end
    local errcode, NeedReboot, paramerr =  dm.SetParameterValues(paras)
    return errcode
end

function setValue(_str)
if 	"cs_dtmf_method" == _str then
    if data["cs_dtmf_method"] == "0" then
		dtmf_method = "InBand"
	else
		dtmf_method = "OutBand"
	end
    local errcode,Con = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.{i}.", {"X_UmtsDTMFMethod"})
    if nil ~= Con then
        for k,v in pairs(Con) do
			if dtmf_method ~= v["X_UmtsDTMFMethod"] then
				local errcode = update(k,_str)            
				utils.xmlappenderror(errcode)
			end
        end
    else
        print("can't find setPath")
    end
end

if 	"cid_send_type" == _str then
    local errcode,Con = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.{i}.X_CommonConfig.", {"X_CIDSendType"})
    if nil ~= Con then
        for k,v in pairs(Con) do
			if data["cid_send_type"] ~= utils.tostring(v["X_CIDSendType"]) then
			    local errcode = update(k,_str)            
				utils.xmlappenderror(errcode)
			end
        end
    else
        print("can't find setPath")
    end
end

end
setValue("cs_dtmf_method")
setValue("cid_send_type")





    
