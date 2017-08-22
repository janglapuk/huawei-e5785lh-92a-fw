local utils = require('utils')

local dialupdomin = "InternetGatewayDevice.X_Config.dialup."
local umtsWandomin = ""

function SetObjParamInputs(data, maps)
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

function parse_data_to_dialup(objdomin, data)
	local maps = {
		data_enable = "data_enable",
		apn_retry = "apn_retry",
		connect_mode = "connect_mode",
		roam_connect = "roam_connect",
		max_idle_time = "max_idle_time",
		mtu_size = "mtu_size",
		dataswitch = "dataswitch",
		auto_dial_enabled = "auto_dial_enabled",
		auto_dial_switch = "auto_dial_switch",
		dialup_number_enabled = "dialup_number_enabled",
		authentication_info_enabled = "authentication_info_enabled",
		ip_type_enabled = "ip_type_enabled",
		apn_enabled = "apn_enabled",
		pdp_always_on = "pdp_always_on",
		idle_time_enabled = "idle_time_enabled",
		dnsstatus = "dnsstatus",
		max_profile_number = "max_profile_number",
		pin_checkbox_checked = "pin_checkbox_checked",
		apn_empty_enable = "apn_empty_enable",
	}

	if nil ~= data then
		local param = SetObjParamInputs(data, maps)
		local errcode, paramErrs = dm.SetObjToDB(objdomin, param)
		if (0 ~= errcode) then
			print("errcode = "..errcode)
		end
	end
end

function parse_data_to_wanumts(objdomin, data)
	local maps = {
		max_idle_time = "IdleDisconnectTime",
		mtu_size = "MaxMRUSize",
		dataswitch = "Enable",
	}
	if nil ~= data then
		local param = SetObjParamInputs(data, maps)
		local errcode, paramErrs = dm.SetObjToDB(objdomin, param)
		if (0 ~= errcode) then
			print("errcode = "..errcode)
		end
	end
	
    if nil ~= data and nil ~= data["connect_mode"] then
	    local TmpStatus = ""

		if '0' == data["connect_mode"] then
			TmpStatus = "OnDemand"
		elseif '1' == data["connect_mode"] then                                                  
			TmpStatus = "Manual"
		end
				
		if '0' == data["idle_time_enabled"] and '0' == data["connect_mode"] then
			TmpStatus = "AlwaysOn" 
		end
		local specialparam = {{"ConnectionTrigger", TmpStatus}}
		local errcode, paramErrs = dm.SetObjToDB(objdomin, specialparam)
		if (0 ~= errcode) then
					print("errcode = "..errcode)
		end
	end
end

function getUmtsInfo()
	for i = 1, 5 do
		local errcode, accessdevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice."..i..".WANCommonInterfaceConfig.", {"WANAccessType"})
		if nil ~= accessdevs then
			for k, v in pairs(accessdevs) do
				if "UMTS" == v["WANAccessType"] then
					umtsWandomin = k
					local start = string.find(umtsWandomin, ".WANCommonInterfaceConfig.")
				    if start then
						umtsWandomin = string.sub(umtsWandomin, 0, start)
					end
					umtsWandomin = umtsWandomin.."WANConnectionDevice.1.WANPPPConnection.1."
					return 
				end
			end

		end
	end
end

parse_data_to_dialup(dialupdomin, data)
getUmtsInfo()
parse_data_to_wanumts(umtsWandomin, data)
