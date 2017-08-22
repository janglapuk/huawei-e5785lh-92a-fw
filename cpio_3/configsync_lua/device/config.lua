local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.device."
local maps = {
    powersave_enable="powersave_enable",
    tetheringswitch	= "tetheringswitch",
    poweroff_enabled = "poweroff_enabled",
    maxsignal = "maxsignal",
    ecomode_enable	= "ecomode_enable",
    restore_default_status = "restore_default_status",
    copyright_enabled = "copyright_enabled",
    sms_backup_enable = "sms_backup_enable",
    atp_backup_enable = "atp_backup_enable",
    touch_backup_enable = "touch_backup_enable",
    pb_backup_enable = "pb_backup_enable",
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
    print("set devicemap errcode = ",errcode)                           
end      

if nil ~= data["hardware"] then
param = {
            {"classify",data["hardware"]["classify"]}
        }
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)  
    if 0 ~= errcode then                                                    
        print("set classify errcode = ",errcode)                           
    end    
end  

if nil ~= data["webui"] then
param = {
            {"webuiapi",data["webui"]["api"]}
        }           
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)    
    if 0 ~= errcode then                                                    
        print("set  webuiapi errcode = ",errcode)                           
    end   
end

if nil ~= data["pc"] then
param = {
            {"pcversion",data["pc"]["version"]}
        }                
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)   
    if 0 ~= errcode then                                                    
        print("set  pcversion errcode = ",errcode)                           
    end     
end

if nil ~= data["poweroff"] then
param = {
         {"powerofftime",data["poweroff"]["time"]}
        }              
local errcode, paramErrs = dm.SetObjToDB(objdomin,param) 
    if 0 ~= errcode then                                                    
        print("set  powerofftime errcode = ",errcode)                           
    end  
end


if nil ~= data["fastboot"] then         
	local maps={   
		fastbootswitch = "fastbootswitch",
		autoshutdown = "autoshutdown"	
	}
	local switchpara = SetObjParamInputs(objdomin,data["fastboot"],maps)	
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)              
	if 0 ~= errcode then                                                 
		print("set device fastboot errcode = ",errcode)                        
	end                                                                  
end  
    
if nil ~= data["ecomode"] then         
	local maps={   
		ecomodeswitch = "ecomodeswitch",
		ecomodetype = "ecomodetype",
		ecowifiofftime = "ecowifiofftime"	
	}
	local switchpara = SetObjParamInputs(objdomin,data["ecomode"],maps)	
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)              
	if 0 ~= errcode then                                                 
		print("set device ecomode errcode = ",errcode)                        
	end                                                                  
end  

if nil ~= data["qrcode"] then         
	local maps={   
		version = "qrcodeversion",
		mcloadurl = "mcloadurl",
		foremcloadurl = "foremcloadurl"	
	}
	local switchpara = SetObjParamInputs(objdomin,data["qrcode"],maps)	
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)              
	if 0 ~= errcode then                                                 
		print("set device qrcode errcode = ",errcode)                        
	end                                                                  
end   

if nil ~= data["antenna"] then         
	local maps={   
		antennaenable = "antennaenable",
		antennanumber = "antennanumber",
		antennasettype = "antennasettype"	
	}
	local switchpara = SetObjParamInputs(objdomin,data["antenna"],maps)	
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)              
	if 0 ~= errcode then                                                 
		print("set device antenna errcode = ",errcode)                        
	end                                                                  
end   
                                                                   
if nil ~= data["supportmode"] then 
       supportmode = data["supportmode"]
       local switchpara={                                                   
		{"supportmode",supportmode}                                                                            
	}                                                                    
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)               
	if 0 ~= errcode then                                                 
		print("set device supportmode errcode = ",errcode)                        
        end		
end                                                                       
if nil ~= data["flight_timer_time"] then 
       flight_timer_time = data["flight_timer_time"]
	   print("set device flight_timer_time ..... ")   
       local switchpara={                                                   
		{"flight_timer_time",flight_timer_time}                                                                            
	}                                                                    
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)               
	if 0 ~= errcode then                                                 
		print("set device flight_timer_time errcode = ",errcode)                        
        end		
end      
                                                               
if nil ~= data["fastdorm"] then         
	local maps={   
		fastdorm_enable = "fastdorm_enable",
		fastdorm_type = "fastdorm_type",
		fastdorm_time = "fastdorm_time"	
	}
	local switchpara = SetObjParamInputs(objdomin,data["fastdorm"],maps)	
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)              
	if 0 ~= errcode then                                                 
		print("set device fastdorm errcode = ",errcode)                        
	end                                                                  
end                                                                
