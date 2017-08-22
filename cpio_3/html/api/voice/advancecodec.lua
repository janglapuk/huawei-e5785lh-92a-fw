require('dm')
require('utils')
require('sys')
local utils     = require('utils')

if data == nil then
	return
end

-- 如果voip开关是关的，则不能响应restful接口
local errcode,values= dm.GetParameterValues("X_Config.global.",{"voipenable"})
obj = values["X_Config.global."];

print("voipenable "..obj["voipenable"])

if obj["voipenable"] == 0 then
    utils.xmlappenderror("100003")
    return
end

function createSubmitData(paras, k, Codec_Name)
	for l,v in pairs(data) do
	        if  Codec_Name ==  v["codec"] then
	            if nil ~= l and nil ~= v["priority"] then
		        utils.add_one_parameter(paras,  k.."Priority", v["priority"])
	            end
	            return 0					
			end
	end
end

function update(k,Codec_Name)	
	local paras = {}
	local errcode = createSubmitData(paras, k ,Codec_Name)
	if errcode ~= 0 then
		return errcode
	end

    local errcode, NeedReboot, paramerr =  dm.SetParameterValues(paras)
	return errcode
end

function setCodec()	
    local errcode,Con = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.Codec.List.{i}.", { "Codec", "Priority"})
    if nil ~= Con then
        for k,v in pairs(Con) do
		    local Codec_Value = utils.tostring(v["Codec"])
            local errcode = update(k,Codec_Value)
            utils.xmlappenderror(errcode)
        end
    else
        print("can't find SetPath")
    end
end

setCodec()



    
