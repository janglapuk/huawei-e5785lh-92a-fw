require('dm')
require('web')
require('json')
require('utils')

local tostring = tostring

local errcode,values = dm.GetParameterValues("InternetGatewayDevice.X_SyslogConfig.", { "DisplayType", "DisplayLevel" });
local obj = values["InternetGatewayDevice.X_SyslogConfig."]
local loginfo = {}
loginfo.DisplayType = obj["DisplayType"]
loginfo.DisplayLevel = obj["DisplayLevel"]

local ret = web.getlogcontent(obj["DisplayLevel"], obj["DisplayType"], 1024)

f = io.open("/var/logtemp", "r")
if f == nil then
    loginfo.LogContent = ""
    io.close()
else
    file = f:read("*a")
    loginfo.LogContent = string.gsub(file, "\r\n", "\n")
    loginfo.LogContent = string.gsub(file, "|", " ")
    f:close()
    os.remove("/var/logtemp")
end
loginfo.LogContent = string.gsub(loginfo.LogContent, "<", "&lt")
loginfo.LogContent = string.gsub(loginfo.LogContent, ">", "&gt")
sys.print(json.xmlencode(loginfo))