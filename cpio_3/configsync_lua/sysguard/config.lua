local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.TimeReboot."
local errcode, paramErrs
local totalTimestart,totalTimeEnd,AutoRebootEnable
local maps = {
    dayinterval="DayInterval", 	
	statisticperiod="StatisticPeriod", 
	statisticthreshold="WANStatisticThreshold", 	
	lanstatisticthreshold="LANStatisticThreshold", 
	debugmode="DebugMode", 
	rebootflag="RebootFlag", 
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

function calcTotalMinutes(times)
	local start ,end1 = string.find(times,":")
	if nil == start then
		print("invalid time format!")
	end
	local timeour = string.sub(times,1,2)
	local timemin = string.sub(times,4,5)
	
	timemin = tonumber(timeour)*60+ tonumber(timemin)
	--print("timemin total:",timemin)
	return timemin
end

if nil ~= data["autoreboot"] then
	totalTimestart = calcTotalMinutes(data["autoreboot"]["begintime"])
	totalTimeEnd = calcTotalMinutes(data["autoreboot"]["endtime"])
	local switchpara={
		{"BeginTime",totalTimestart},
		{"EndTime",totalTimeEnd}
	}
	errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara)
	if 0 ~= errcode then
		print("set time  errcode = ",errcode)
	end
end

if nil ~= data["sysguardswitch"] then
	AutoRebootEnable = data["sysguardswitch"]["autorebootswitch"]
	errcode, paramErrs = dm.SetObjToDB(objdomin,{{"Enable",AutoRebootEnable}})
	if 0 ~= errcode then
		print("autorebootswitch errcode = ",errcode)
	end
end

local switchpara1 = SetObjParamInputs(objdomin, data["autoreboot"], maps)
 errcode, paramErrs = dm.SetObjToDB(objdomin,switchpara1)
if 0 ~= errcode then
	print("sysguard errcodeh = ",errcode)
end

