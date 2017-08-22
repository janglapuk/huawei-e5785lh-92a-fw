local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.dialup.Pinmanagement."
local pindomin = "InternetGatewayDevice.X_Config.dialup.Pinmanagement.CustomerPin.1"
if nil ~= data and nil ~= data["savepin"] then
    local param = {{"simsavepinenable", data["savepin"]["simsavepinenable"]}}
	local errcode, paramErrs = dm.SetObjToDB(objdomin,param)
	if 0 ~= errcode then 
		print("autopin 1 errcode:",errcode)
	end
	
	local newObj = {
		{"Pin", data["savepin"]["simsavepinpin"]}, 
		{"SecondPin", data["savepin"]["simsavepinsecond"]},	
		{"ICCID", data["savepin"]["simsavepinscid"]}, 		
		{"Enable", data["savepin"]["simsavepinstatus"]},	
	}	
	local errcode, paramErrs= dm.SetObjToDB(pindomin, newObj)
	if errcode ~= 0 then
		print("autopin 2 set errcode = ", errcode)
	end		
end


