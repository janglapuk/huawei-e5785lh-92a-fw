local utils = require('utils')
require('dm')
require('web')
require('json')
require('utils')

-- 如果voip开关是关的，则不能响应restful接口
local errcode,values= dm.GetParameterValues("X_Config.global.",{"voipenable"})
obj = values["X_Config.global."];

print("voipenable "..obj["voipenable"])

if obj["voipenable"] == 0 then
    utils.xmlappenderror("100003")
    return
end

local codec = {}
local response = {}

local errcode, Codec_values = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.Codec.List.{i}.", {"Enable"});
if nil ~= Codec_values then
    for id, Codec_valuesinfo in pairs(Codec_values) do
        local errcode,each_codec = dm.GetParameterValues(id, {"Enable","Codec","Priority"});
        if errcode ~= 0 then
	   print("!!! errcode "..errcode)
	   break
	end		
           local each_codec_obj = each_codec[id]		    
	   local codecitem = {}  
           codecitem.enable = each_codec_obj["Enable"]		   
           codecitem.codec = each_codec_obj["Codec"]
           codecitem.priority = each_codec_obj["Priority"]		
           table.insert(codec,codecitem)		
    end
end
response.codec = codec 
sys.print(json.xmlencodex(response))

