local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.X_lmt_net."
local maps = {
    operator_display_rule="operator_display_rule",
    list_display_rule="list_display_rule",
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
    print("set X_lmt_net map errcode = ",errcode)                           
end 

objdomin = "InternetGatewayDevice.X_Config.X_lmt_net.display_rule."
if nil ~= data["network_name_display_rule"] then                                                                                                                    
	enable = (data["network_name_display_rule"]["enable"])                                                                                      
	roam_rule = (data["network_name_display_rule"]["roam_rule"])  
	nonroam_rule = (data["network_name_display_rule"]["nonroam_rule"])     
	search_list_rule = (data["network_name_display_rule"]["search_list_rule"])      
	local rulepara={                                                         
		{"enable",enable},                                 
		{"roam_rule",roam_rule},  
		{"nonroam_rule",nonroam_rule},
		{"search_list_rule",search_list_rule}
	}                                                                          
	errcode, paramErrs = dm.SetObjToDB(objdomin,rulepara)                    
	if 0 ~= errcode then                                                       
		print("set X_lmt_net network_name_display_rule  errcode = ",errcode)                              
	end                                                                        
end  