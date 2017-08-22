local utils = require('utils')

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

local objdomin = "InternetGatewayDevice.X_Config.global."
local maps = {
    enable="websdenable",
    sambaenable	= "sambaenable",
    dlnaenable = "dlnaenable",
}
local param = SetObjParamInputs(objdomin, data,	maps)
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)
if 0 ~= errcode then                                                    
    print("set websd enbale dlna samba errcode = ",errcode)                           
end   

if nil ~= data then
	local sdcard = "InternetGatewayDevice.X_Config.websd.sdcard."
	local sdmaps = {
		sdsharemode="sdsharemode",
		sdcardsharestatus="sdcardsharestatus",
		sdsharefilemode="sdsharefilemode",
		sdaccesstype="sdaccesstype",
		sdsharepath="sdsharepath",
	}
	if nil ~= data and nil ~= data["sdcard"] then
		local param = SetObjParamInputs(sdcard, data["sdcard"], sdmaps)		
		local errcode, paramErrs = dm.SetObjToDB(sdcard,param)
		print("web sdcard config sync errocde", errcode)
	end

	local litesamba = "InternetGatewayDevice.Services.StorageService.1.SMBServer."
	if nil ~= data and nil ~= data["samba"] then
		local paras ={{"PrinterEnable",data["samba"]["printerenable"]}}
		local errcode, paramErrs = dm.SetObjToDB(litesamba,paras)
		print("web sabma config sync errocde", errcode)
	end
end