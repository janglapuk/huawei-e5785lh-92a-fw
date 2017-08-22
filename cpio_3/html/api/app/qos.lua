local utils = require('utils')

if data == nil then
	return
end

local parasqos = {}

    utils.add_one_parameter(parasqos, "InternetGatewayDevice.QueueManagement.Enable", data["enable"])
	utils.add_one_parameter(parasqos, "InternetGatewayDevice.QueueManagement.X_WmmEnable", data["wmmenable"])        
    utils.add_one_parameter(parasqos, "InternetGatewayDevice.QueueManagement.X_BandWidth", data["upbandwidth"])      
    utils.add_one_parameter(parasqos, "InternetGatewayDevice.QueueManagement.DownBandWidth", data["downbandwidth"])      
local errcode, NeedReboot, paramerr = dm.SetParameterValues(parasqos)

if errcode ~= 0 then
        utils.xmlappenderror(errcode)
end	



