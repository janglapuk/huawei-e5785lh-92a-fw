local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.sms."
local maps = {
    enable="enable",
    session_sms_enabled = "session_sms_enabled",
    pagesize = "pagesize",
    maxphone = "maxphone",
    smscharlang = "smscharlang",
    localmax = "localmax",
    validity = "validity",
    import_enabled = "import_enabled",	
	sms_center_enabled = "sms_center_enabled",
	sms_priority_enabled = "sms_priority_enabled",
	sms_validity_enabled = "sms_validity_enabled",
	cdma_enabled = "cdma_enabled",
	url_enabled = "url_enabled",
	smscharmap = "smscharmap",
	cbsenable = "cbsenable",
	cbschannellist = "cbschannellist",
	getcontactenable = "getcontactenable",
	uselocal = "uselocal",
	usepdu  = "usepdu",
	usesreport = "usesreport",
	sendtype = "sendtype",
	priority = "priority",
	saveussdsms = "saveussdsms",
	smsfulltype = "smsfulltype",
	
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
return errcode, paramErrs
