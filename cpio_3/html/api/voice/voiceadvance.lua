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

--print(json.xmlencode(data))

function updatevoipcsselect(_str)	

       local voicephyinterface = "InternetGatewayDevice.Services.VoiceService.1.PhyInterface.1."
	
	--voipcsselect: 0(&>3)-VoIP First, then CS
	if 0 == _str then			    

            local setValues = 
           {
              {voicephyinterface.."X_IncomingLineList", "all" },
              {voicephyinterface.."X_OutgoingLineList", "auto"}
           }

           errcode,needreboot, paramerror = dm.SetParameterValues( setValues )
           if errcode ~= 0 then
	      print("set Phy Interface fail errcode "..errcode)
              utils.xmlappenderror(errcode)
           end
				
	end
	
	--voipcsselect: 1-CS First, then VoIP
	if  1 == _str then		
	    --voipcsselect: 1-CS First, then VoIP
	    local phyinterfaceparas2 = "CS"
	    local errcode, directorynumber_value = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.", {"DirectoryNumber"})
            if nil ~= directorynumber_value then
	       for k, directorynumber in pairs(directorynumber_value) do
	       	if "" ~= directorynumber["DirectoryNumber"]	then
		    	phyinterfaceparas2 = "CS,"..directorynumber["DirectoryNumber"]
		    end
	       end
            else
	        print("!!! errcode"..errcode)
            end

            local setValues = 
           {
              {voicephyinterface.."X_IncomingLineList", "all" },
              {voicephyinterface.."X_OutgoingLineList", phyinterfaceparas2}
           }

           errcode,needreboot, paramerror = dm.SetParameterValues( setValues )
           if errcode ~= 0 then
	      print("set Phy Interface fail errcode "..errcode)
              utils.xmlappenderror(errcode)
           end	
	end
	
	--voipcsselect: 2-VoIP only
	if  2 == _str then		
	   --voipcsselect: 2-VoIP only
	  local phyinterfaceparas2 = ""
	  local errcode, directorynumber_value = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.", {"DirectoryNumber"})
          if nil ~= directorynumber_value then
	       for k, directorynumber in pairs(directorynumber_value) do			   
		    phyinterfaceparas2 = directorynumber["DirectoryNumber"]	
	       end
          else
	        print("!!! errcode"..errcode)
          end

            local setValues = 
           {
              {voicephyinterface.."X_IncomingLineList", "all"},
              {voicephyinterface.."X_OutgoingLineList", phyinterfaceparas2}
           }

           errcode,needreboot, paramerror = dm.SetParameterValues( setValues )
           if errcode ~= 0 then
	      print("set Phy Interface fail errcode "..errcode)
              utils.xmlappenderror(errcode)
           end	
	
	end	
	
	--voipcsselect: 3-CS only
	if  3 == _str then	      

            local setValues = 
           {
              {voicephyinterface.."X_IncomingLineList", "all"},
              {voicephyinterface.."X_OutgoingLineList", "CS"}
           }

           errcode,needreboot, paramerror = dm.SetParameterValues( setValues )
           if errcode ~= 0 then
	      print("set Phy Interface fail errcode "..errcode)
              utils.xmlappenderror(errcode)
           end
	
	end
end

function createSubmitData(paras, k, _str)
	if  "dtmfmethod" == _str then		
		if nil ~= data["dtmfmethod"] then
		utils.add_one_parameter(paras,  k.."DTMFMethod", data["dtmfmethod"])
	    end
	    print(json.xmlencode(paras))
	    return 0					
	end
	
	if  "EchoCancellationEnable" == _str then		
		if nil ~= data["EchoCancellationEnable"] then
		utils.add_one_parameter(paras,  k.."EchoCancellationEnable", data["EchoCancellationEnable"])
	    end
	    print(json.xmlencode(paras))
	    return 0					
	end
	
	if  "faxoption" == _str then		
		if nil ~= data["faxoption"] then
		utils.add_one_parameter(paras,  k.."X_FaxOption", data["faxoption"])
	    end
	    print(json.xmlencode(paras))
	    return 0					
	end
	
	if  "voipcsselect" == _str then		
		if nil ~= data["voipcsselect"] then
		updatevoipcsselect(tonumber(data["voipcsselect"]))
		utils.add_one_parameter(paras,  k.."X_Voipcsselect", data["voipcsselect"])
	    end
	    print(json.xmlencode(paras))
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
	print("update", paras)
    return errcode
end

function setCodec(_str)
if 	"dtmfmethod" == _str then
    local errcode,Con = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.{i}.VoiceProfile.{i}.", {"DTMFMethod"})
    if nil ~= Con then
        for k,v in pairs(Con) do
            local errcode = update(k,_str)            
            utils.xmlappenderror(errcode)
        end
    else
        print("can't find setCodecPath")
    end
end

if 	"EchoCancellationEnable" == _str then
    local errcode,Con = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.{i}.VoiceProfile.{i}.Line.{i}.VoiceProcessing.", {"EchoCancellationEnable"})
    if nil ~= Con then
        for k,v in pairs(Con) do
            local errcode = update(k,_str)            
            utils.xmlappenderror(errcode)
        end
    else
        print("can't find setCodecPath")
    end
end

if 	"faxoption" == _str then
    local errcode,Con = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.{i}.VoiceProfile.{i}.Line.{i}.", {"X_FaxOption"})
    if nil ~= Con then
        for k,v in pairs(Con) do
            local errcode = update(k,_str)            
            utils.xmlappenderror(errcode)
        end
    else
        print("can't find setCodecPath")
    end
end

if 	"voipcsselect" == _str then
    local errcode,Con = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.{i}.X_CommonConfig.", {"X_Voipcsselect"})
    if nil ~= Con then
        for k,v in pairs(Con) do
            local errcode = update(k,_str)            
            utils.xmlappenderror(errcode)
        end
    else
        print("can't find setCodecPath")
    end
end

end

setCodec("dtmfmethod")
setCodec("EchoCancellationEnable")
setCodec("faxoption")
setCodec("voipcsselect")
