local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.update."
local maps = {
    enable="enable",
    localupdate_enabled = "localupdate_enabled",
    ip = "ip",
    port = "port",
    virtual_directory = "virtual_directory",
    update_interval = "update_interval",
    get_server_time = "get_server_time",	
    upgrade_poweron = "upgrade_poweron",
    check_rule = "check_rule",
    battery_low_timer = "battery_low_timer",
    timer_minutes = "timer_minutes",
    submit_field = "submit_field",
    KeyCTL_timer = "KeyCTL_timer",
    bbou_day = "bbou_day",
    bbou_month = "bbou_month",
    bbou_year = "bbou_year",
    updatereminderstatus = "updatereminderstatus",
    update_force_hint = "update_force_hint",
    force_hint_times = "force_hint_times",
    default_times = "default_times",
    auto_upg = "auto_upg",
    reminder_interval = "reminder_interval",
    start_time = "start_time",
    end_time = "end_time",
    retry_time = "retry_time",
    not_need_login = "not_need_login",
}

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
	
local param = SetObjParamInputs(objdomin, data, maps)
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)
if 0 ~= errcode then                                                    
    print("set update errcode = ",errcode)                           
end   
return errcode, paramErrs
