local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.Wifi.Sta."
local wandomain = ""


function SetObjParamInputs(data, maps)
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

function set_offload_mtu()
    getWanInfo()
    local maps = {
        mtu_size = "MaxMTUSize",
    }
    if "" == wandomain then
        print("get wan domain fail")
    return
    end
    if nil ~= data then
        local param = SetObjParamInputs(data, maps)
        local errcode, paramErrs = dm.SetObjToDB(wandomain, param)
        local errcode,wifiConf = dm.GetParameterValues("InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.",
            {
            "MaxMTUSize"
            }
        );
        if (0 ~= errcode) then
            print("set mtu errcode = "..errcode)
        end
    end
end

function parse_data_to_wlan(objdomin, data)
    local maps = {
        enable = "Enable",
        sta_switch = "Sta_Switch",
        sta_sim_relation = "Sta_Sim_Relation",
        maxwifisignal = "MaxWifiSignal",
        stawpsenabled = "StaWpsEnabled",
        stafrequenceenable = "StaFrequenceEnable",
        frequence = "Frequence",
        scanresultwithprofile = "ScanResultWithProfile",
        nopwd = "NoPwd"
    }
    if nil ~= data then
        local param = SetObjParamInputs(data, maps)
        local errcode, paramErrs = dm.SetObjToDB(objdomin, param)
        if (0 ~= errcode) then
            print("errcode = "..errcode)
        end
    end
end


function getWanInfo()
    local errcode, accessdevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANCommonInterfaceConfig.", {"WANAccessType"})
    if nil ~= accessdevs then
        for k, v in pairs(accessdevs) do
            if "WIFI" == v["WANAccessType"] then
                    wandomain = k
                    local start = string.find(wandomain, ".WANCommonInterfaceConfig.")
                    if start then
                        wandomain = string.sub(wandomain, 0, start)
                    end
                    wandomain = wandomain.."WANConnectionDevice.1.WANIPConnection.1."
                    return 
            end
        end
    end
end


parse_data_to_wlan(objdomin, data)		
set_offload_mtu()