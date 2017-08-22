local utils = require('utils')

-- tempprotect_level add
function  tempprotect_level_setvalue()
    -- body
    
    local switchobjdominmode = "InternetGatewayDevice.Services.X_TC."
    
    print('start tempprotect_level......')
	
    if nil ~= data and nil ~= data["tempprotect_level"] then
        local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"TCLevel", data["tempprotect_level"]["value"]}})
        print('tempprotect_level error = ', errcode)
    end
    return true
end

-- tempprotect_downrate add
function  tempprotect_downrate_setvalue()
    -- body
    
    local switchobjdominmode = "InternetGatewayDevice.Services.X_TC."
    
    print('start tempprotect_downrate......')
	
    if nil ~= data and nil ~= data["tempprotect_downrate"] then
        local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"TCDownRate1", data["tempprotect_downrate"]["rate1"]}})
		print('tempprotect_downrate 1 error = ', errcode)
		local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"TCDownRate2", data["tempprotect_downrate"]["rate2"]}})
        print('tempprotect_downrate 2 error = ', errcode)
    end
    return true
end

-- tempprotect_uprate add
function  tempprotect_uprate_setvalue()
    -- body
    
    local switchobjdominmode = "InternetGatewayDevice.Services.X_TC."
    
    print('start tempprotect_uprate......')
	
    if nil ~= data and nil ~= data["tempprotect_uprate"] then
        local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"TCUpRate1", data["tempprotect_uprate"]["rate1"]}})
		print('tempprotect_uprate 1 error = ', errcode)
		local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"TCUpRate2", data["tempprotect_uprate"]["rate2"]}})
        print('tempprotect_uprate 2 error = ', errcode)
    end
    return true
end

-- tempprotect_lanforwardrate add
function  tempprotect_lanforwardrate_setvalue()
    -- body
    
    local switchobjdominmode = "InternetGatewayDevice.Services.X_TC."
    
    print('start tempprotect_lanforwardrate......')
	
    if nil ~= data and nil ~= data["tempprotect_lanforwardrate"] then
        local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"TCLanFwdRate1", data["tempprotect_lanforwardrate"]["rate1"]}})
		print('tempprotect_lanforwardrate 1 error = ', errcode)
		local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"TCLanFwdRate2", data["tempprotect_lanforwardrate"]["rate2"]}})
        print('tempprotect_lanforwardrate 2 error = ', errcode)
    end
    return true
end

-- tempprotect_withoffline add
function  tempprotect_withoffline_setvalue()
    -- body
    
    local switchobjdominmode = "InternetGatewayDevice.Services.X_TC."
    
    print('start tempprotect_withoffline......')
	
    if nil ~= data and nil ~= data["tempprotect_withoffline"] then
        if data["tempprotect_withoffline"]["enable"] == '0' then
            local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"TCWithOffline", false}})
            print('enable 0 for tempprotect_withoffline error = ', errcode)
        elseif data["tempprotect_withoffline"]["enable"] == '1' then
            local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"TCWithOffline", true}})
            print("enable 1 for tempprotect_withoffline error ", errcode)
        else
            print("unavailable value")
        end
    end
    return true
end

-- tempprotect_wifioffload add
function  tempprotect_wifioffloadenable_setvalue()
    -- body
    
    local switchobjdominmode = "InternetGatewayDevice.Services.X_TC."
    
    print('start tempprotect_wifioffload......')
	
    if nil ~= data and nil ~= data["tempprotect_wifioffload"] then
        if data["tempprotect_wifioffload"]["enable"] == '0' then
            local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"TCWiFiOffload", false}})
            print('enable 0 for tempprotect_wifioffload error = ', errcode)
        elseif data["tempprotect_wifioffload"]["enable"] == '1' then
            local errcode, paramErrs = dm.SetObjToDB(switchobjdominmode,{{"TCWiFiOffload", true}})
            print("enable 1 for tempprotect_wifioffload error ", errcode)
        else
            print("unavailable value")
        end
    end
    return true
end

tempprotect_level_setvalue()

tempprotect_downrate_setvalue()

tempprotect_uprate_setvalue()

tempprotect_lanforwardrate_setvalue()

tempprotect_withoffline_setvalue()

tempprotect_wifioffloadenable_setvalue()

print("tc config is ok..........")
