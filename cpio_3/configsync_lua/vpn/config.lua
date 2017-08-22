local utils = require('utils')
local objdomin = "InternetGatewayDevice.X_Config.global."
local maps = {
    enable="vpnenable",
}

function SetObjParamInputs(domain, data, maps)
    local inputs = {}
    for	k, v in	pairs(maps) do
	local param = {}
		if nil ~= data and nil ~= data[k] then
			param["key"] = v      
			param["value"] = data[k]
			table.insert(inputs, param)
		end
    end
    return inputs
end

local param = SetObjParamInputs(objdomin, data,	maps)
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)
if 0 ~= errcode then                                                    
    print("set vpn errcode = ",errcode)                           
end   

function  vpncreateSubmitData()
    -- body
    local switchobjdomin = "InternetGatewayDevice.X_VPN.L2TP_LAC."
    if nil ~= data then
        local switchparam = {}

        local switchmaps = {
            lns_addr="LNSAddress",
            vpntype = "Enable",
            tunnel_name="HostName",
            tunnel_password="PassWord",
            interval="KeepAliveTime",
			            l2tp_fail_retry_num="FailRetryNum",
            l2tp_fail_retry_interval="FailRetryInterval",
            auth_type="PCAuthMode",
        }

        function switchSetObjParamInputs(switchobjdomin, data, switchmaps)
            local inputs = {}
            for k, v in pairs(switchmaps) do
                local param = {}
                if nil ~= data and nil ~= data[k] then
                    param["key"] = v
                    if v == "Enable" then
                        param["value"] = utils.toboolean(data["vpntype"])
                    else
                        param["value"] = data[k]
                    end
                    table.insert(inputs, param)
                end  
            end
            return inputs
        end
        local param = switchSetObjParamInputs(switchobjdomin, data, switchmaps)
        print("vpn  come")
        local errcode, paramErrs = dm.SetObjToDB(switchobjdomin,param)
        if 0 ~= errcode then  
            print("vpn errcode1", errcode)
        end
	end
end

function  vpnsettingdisplay()
    print("vpnsettingdisplay come in")
    local vpndisplayobjdomin = "InternetGatewayDevice.X_VPN.Display."
	if nil ~= data then	
        local maps = {
                          pptp_display="PptpDisplay",
	    	              l2tp_display="L2tpDisplay",
                     }
    local param = SetObjParamInputs(vpndisplayobjdomin, data, maps)
    local errcode, paramErrs = dm.SetObjToDB(vpndisplayobjdomin, param)
    if 0 ~= errcode then
        print("set vpnsettingdisplay errcode = ",errcode)
    end 
	end
end
vpncreateSubmitData()
vpnsettingdisplay()