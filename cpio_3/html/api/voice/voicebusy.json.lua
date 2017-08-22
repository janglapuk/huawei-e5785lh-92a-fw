local web       = require("web")
local json      = require("json")

local  voicebusy = {}
local phy_errcode,phy_values = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.PhyInterface.{i}.", {"X_InCallNumber", "InterfaceID"});
voicebusy = "Idle"
for k,v in pairs(phy_values) do
    local voiceitem = {}
    voiceitem.ID = k  
    voiceitem.callnumber = v["X_InCallNumber"]
    
    local status = web.getVoicePortStatus(v["InterfaceID"]-1)
    if 1 == status then
		voicebusy = "Busy"
    end 

end

sys.print(json.xmlencodex(voicebusy))
