local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.oled."

function SetObjParamInputs(domain, data, maps)
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

if nil ~= data["oled_fun"] then                                                                                                                        
	oled_fun_enable = data["oled_fun"]["enable"]                                                                                            
	local switchpara={                                                         
		{"oled_fun_enable",oled_fun_enable},                                                                     
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled_fun_enabled  errcode = ",errcode)                              
	end                                                                        
end  

if nil ~= data["scr_size"] then         
	local maps={   
		height = "height",
		width = "width"	
	}
	local switchpara = SetObjParamInputs(objdomin,data["scr_size"],maps)	
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)              
	if 0 ~= errcode then                                                 
		print("set height width  errcode = ",errcode)                              
	end                                                                  
end  

if nil ~= data["oled_dim"] then                                                                                                                        
	oled_dim_time = data["oled_dim"]["time"]  
                                                                                      
	local switchpara={                                                         
		{"oled_dim_time",oled_dim_time},                                                                   
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled oled_dim_time errcode = ",errcode)                              
	end                                                                        
end  

if nil ~= data["oled_sleep"] then                                                                                                                        
	oled_sleep_time = data["oled_sleep"]["time"]  
                                                                                      
	local switchpara={                                                         
		{"oled_sleep_time",oled_sleep_time},                                                                   
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled oled_sleep_time errcode = ",errcode)                              
	end                                                                        
end  

if nil ~= data["short_key_sleep"] then                                                                                                                        
	short_key_sleep = data["short_key_sleep"]["enable"]  
                                                                                      
	local switchpara={                                                         
		{"short_key_sleep",short_key_sleep},                                                                   
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled short_key_sleep errcode = ",errcode)                              
	end                                                                        
end  


if nil ~= data["flux"] then         
	local maps={   
		enable = "fluxenable",
		type = "fluxtype"
	}
	local switchpara = SetObjParamInputs(objdomin,data["flux"],maps)	
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)              
	if 0 ~= errcode then                                                 
		print("set oled flux errcode = ",errcode)                        
	end                                                                  
end  

if nil ~= data["light"] then                                                                                                                        
	light_enable = data["light"]["enable"] 
                                                                                      
	local switchpara={                                                         
		{"light_enable",light_enable},                                                                
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled light errcode = ",errcode)                              
	end                                                                        
end  

if nil ~= data["oper"] then                                                                                                                        
	opernumber = data["oper"]["number"] 
                                                                                      
	local switchpara={                                                         
		{"opernumber",opernumber},                                                                
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled opennumber errcode = ",errcode)                              
	end                                                                        
end 


if nil ~= data["ssid"] then         
	local maps={   
		enable = "ssid_enable",
		screen_number = "ssid_screen_number"	
	}
	local switchpara = SetObjParamInputs(objdomin,data["ssid"],maps)	
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)              
	if 0 ~= errcode then                                                 
		print("set oled ssid infor errcode = ",errcode)                              
	end                                                                  
end  

if nil ~= data["idlessid"] then                                                                                                                        
	idlessid_enable = data["idlessid"]["enable"] 
                                                                                      
	local switchpara={                                                         
		{"idlessid_enable",idlessid_enable},                                                               
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled idlessid_enable infor errcode = ",errcode)                              
	end                                                                        
end 

if nil ~= data["ipaddress"] then                                                                                                                        
	ipaddress_enable = data["ipaddress"]["enable"] 
                                                                                      
	local switchpara={                                                         
		{"ipaddress_enable",ipaddress_enable},                                                               
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled ipaddress_enable infor errcode = ",errcode)                              
	end                                                                        
end 

if nil ~= data["softversion"] then                                                                                                                        
	softversion_enable = data["softversion"]["enable"] 
                                                                                      
	local switchpara={                                                         
		{"softversion_enable",softversion_enable},                                                               
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled softversion_enable infor errcode = ",errcode)                              
	end                                                                        
end 

if nil ~= data["homepage"] then                                                                                                                        
	homepage_enable = data["homepage"]["enable"] 
                                                                                      
	local switchpara={                                                         
		{"homepage_enable",homepage_enable},                                                               
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled homepage_enable infor errcode = ",errcode)                              
	end                                                                        
end 

if nil ~= data["update"] then                                                                                                                        
	updatecomplete = data["update"]["complete"] 
                                                                                      
	local switchpara={                                                         
		{"updatecomplete",updatecomplete},                                                               
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled updatecomplete infor errcode = ",errcode)                              
	end                                                                        
end 

if nil ~= data["menu"] then         
	local maps={   
		infotime = "menu_infotime",
		smslist_count = "smslist_count",
		qrtime = "qrtime",
	}
	local switchpara = SetObjParamInputs(objdomin,data["menu"],maps)	
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)              
	if 0 ~= errcode then                                                 
		print("set oled menu infor errcode = ",errcode)                              
	end                                                                  
end  

if nil ~= data["homessid"] then                                                                                                                        
	homessid_enable = data["homessid"]["enable"] 
                                                                                      
	local switchpara={                                                         
		{"homessid_enable",homessid_enable},                                                              
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled homessid_enable infor errcode = ",errcode)                              
	end                                                                        
end 

if nil ~= data["imei"] then                                                                                                                        
	imei_enable = data["imei"]["enable"] 
                                                                                      
	local switchpara={                                                         
		{"imei_enable",imei_enable},                                                              
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled imei_enable infor errcode = ",errcode)                              
	end                                                                        
end 

if nil ~= data["sn"] then                                                                                                                        
	sn_enable = data["sn"]["enable"] 
                                                                                      
	local switchpara={                                                         
		{"sn_enable",sn_enable},                                                              
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled sn_enable infor errcode = ",errcode)                              
	end                                                                        
end 


if nil ~= data["snimei"] then                                                                                                                        
	snimei_number = data["snimei"]["number"] 
                                                                                      
	local switchpara={                                                         
		{"snimei_number",snimei_number},                                                              
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)                    
	if 0 ~= errcode then                                                       
		print("set oled snimei_number infor errcode = ",errcode)                              
	end                                                                        
end 