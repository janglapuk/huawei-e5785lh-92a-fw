local dm = require('dm')
local utils = require('utils')
local paras = {}

function parse_data_to_radio_para(key, v)
    if nil ~= key then
        utils.add_one_parameter(paras, key.."Enable", v.wifienable)
    end
end

function get_key_by_index(radioindex)
    -- key ÑùÀý"InternetGatewayDevice.X_Config.Wifi.Radio.1."
    if nil ~= radioindex then
        return "InternetGatewayDevice.X_Config.Wifi.Radio."..radioindex.."."
    end
end

if nil ~= data and nil ~= data["radios"] then
    local radios = data["radios"]
    local num = 1
    for k, v in pairs(radios) do
        local ID = get_key_by_index(v.index + 1)
        if nil == ID then
    		print("ID error")
    		utils.xmlappenderror(100005)
    		return nil
        end
        parse_data_to_radio_para(ID, v)
        num = num + 1
    end
end

local errcode, NeedReboot, paramerr = dm.SetParameterValues(paras)
utils.xmlappenderror(errcode)