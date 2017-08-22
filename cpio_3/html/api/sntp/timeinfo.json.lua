
local dm = require('dm')
local json = require('json')
local utils = require('utils')

--sntp module Switch Data nodes  "InternetGatewayDevice.Time.X_TimeServerDisplay_Enabled"
--------------------check the status of sntp module switch--------------------
local errcode,SwitchValues= dm.GetParameterValues("InternetGatewayDevice.Time.",
        {"X_TimeServerDisplay_Enabled"})

if utils.toboolean(SwitchValues["InternetGatewayDevice.Time."]["X_TimeServerDisplay_Enabled"]) then
--print("sntp module Switch is on")
else
--print("sntp module Switch is off")
	local response = {}
	response.code = 100002
	response.message = ""
	sys.print(json.xmlencode(response,"error"))
	return	false
end

local errcode,values= dm.GetParameterValues("InternetGatewayDevice.Time.",
    {"CurrentLocalTime","LocalTimeZoneName","NTPServer1","NTPServer2","Status","X_Label","CurrentTimeZone"})
obj = values["InternetGatewayDevice.Time."];

local dst = {}
dst.syncstatus = obj["Status"]
dst.localtimezonename = obj["LocalTimeZoneName"]
dst.currentlocaltime = obj["CurrentLocalTime"]
dst.currenttimezone = obj["CurrentTimeZone"]
if obj["NTPServer1"] == "" then
    dst.firstserver = "None"
else
    dst.firstserver = obj["NTPServer1"]
end
if obj["NTPServer2"] == "" then
    dst.secondserver = "None"
else
    dst.secondserver = obj["NTPServer2"]
end

if obj["X_Label"] == "" then
   dst.timezoneidx = "None"
else
   dst.timezoneidx = obj["X_Label"]
end
print("timezoneidx:",dst.timezoneidx)
print("localtimezonename:",dst.localtimezonename)
print("currenttimezone:",dst.currenttimezone)
sys.print(json.xmlencode(dst))
