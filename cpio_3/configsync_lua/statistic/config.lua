local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.statistic."    
local maps = {
    enable="enable",
    monthly_volume_enabled = "monthly_volume_enabled",
    sim_change_enabled = "sim_change_enabled",
    turnoffdataenable = "turnoffdataenable",
    iccid = "iccid",
    current_month_limit = "current_month_limit",
    current_month_limit_str = "current_month_limit_str",
    current_start_day = "current_start_day",	
    set_month_data = "set_month_data",
	
    datalimitunittype = "datalimitunittype",
    datalimitlength = "datalimitlength",
    current_month_download_tmp = "current_month_download_tmp",
    current_month_download = "current_month_download",
    current_month_upload_tmp = "current_month_upload_tmp",
    current_month_upload = "current_month_upload",
    month_duration = "month_duration",
    month_duration_tmp = "month_duration_tmp",
	
    wimax2_month_duration_tmp = "wimax2_month_duration_tmp",
    wimax2_month_duration = "wimax2_month_duration",
    wimax2_current_month_download_tmp = "wimax2_current_month_download_tmp",
    wimax2_current_month_download = "wimax2_current_month_download",
    wimax2_current_month_upload_tmp = "wimax2_current_month_upload_tmp",
    wimax2_current_month_upload = "wimax2_current_month_upload",
	
    day = "day",
    month = "month",
    year = "year",
    current_month_threshold = "current_month_threshold",
    wifidatalimit = "wifidatalimit",
    wifistartday = "wifistartday",
    wifimonththreshold = "wifimonththreshold",
    wifimonthlastcleartime = "wifimonthlastcleartime",
    showtraffic = "showtraffic",
    turnoffdataswitch  = "turnoffdataswitch",
    turnoffdataflag = "turnoffdataflag",
    data_limit_awoke = "data_limit_awoke",
	
    lteenable = "lteenable",
    wimax2enable = "wimax2enable",
	
    mode = "mode",
    hsenable = "hsenable",
    hsaenable = "hsaenable",
	
    current_3days_limit = "current_3days_limit",
    current_3days_limit_str = "current_3days_limit_str",
    day_3days = "day_3days",
    month_3days = "month_3days",
    year_3days = "year_3days",
    hs3daysenable = "hs3daysenable",
    hsa3daysenable = "hsa3daysenable",
	
    noticeovermonthlimit = "noticeovermonthlimit",
    duration_display = "duration_display",	
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
        print("set  statistic errcode = ",errcode)                           
end  
return errcode, paramErrs
