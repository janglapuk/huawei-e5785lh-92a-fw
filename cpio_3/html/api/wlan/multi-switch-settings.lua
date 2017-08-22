require('utils')
require('dm')
local paras = {}

--获取当前radio的个数
local errcode, radionum, radioarray = dm.GetObjNum("InternetGatewayDevice.X_Config.Wifi.Radio.{i}")
print("radionum", radionum)

function parse_multi_switch_para(key, v)
    if nil ~= key then
        utils.add_one_parameter(paras, key.."Enable", v.multissidstatus)
        utils.add_one_parameter(paras, "InternetGatewayDevice.X_Config.Wifi.Wifi_Restart", 1)
    end
end

if (2 == radionum) then
	utils.xmlappenderror(100002)
	return 
end

if nil ~= data then
    parse_multi_switch_para("InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.2.", data)
end

local errcode, NeedReboot, paramerr = dm.SetParameterValues(paras)
utils.xmlappenderror(errcode)