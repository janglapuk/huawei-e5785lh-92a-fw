local utils = require('utils')

local switchobjdomin = "InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.DHCPStaticAddress."

local switchparam = {}

local switchmaps = {
    HostHw="Chaddr",
    HostIp="Yiaddr",
    HostEnabled="Enable",
}

function checkIsdefaultObj(HostEnabled, HostHw, HostIp)
    -- body
    if HostEnabled == "0" and HostHw == "" and HostIp == "" then
        print("default one...")
        return true
    end
    return false
end


function switchSetObjParamInputs(switchobjdomin, data, switchmaps)
    local inputs = {}
    for k, v in pairs(switchmaps) do
        local param = {}
        if nil ~= data and nil ~= data[k] then
            param["key"] = v      
            param["value"] = data[k]
            table.insert(inputs, param)
        end  
    end
    return inputs
end

function SetObjParamInputs()
    local inputs = {}
    for k, v in pairs(data["Hosts"]) do
        if checkIsdefaultObj(v["HostEnabled"], v["HostHw"], v["HostIp"]) == false then
            local param = {}
            local param = switchSetObjParamInputs(switchobjdomin, data["Hosts"][k], switchmaps)

            local errcode, paramErrs = dm.AddObjectToDB(switchobjdomin, param)
            if errcode ~= 0 then
    			print("Satic Host errcode = ", errcode)
    		end
        end
	end
end

SetObjParamInputs()

print("lan static is ok ...........")