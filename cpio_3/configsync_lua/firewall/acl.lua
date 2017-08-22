
local utils = require('utils')
local objHostdomin = "InternetGatewayDevice.ACL."

local aclAllsupport = {}
aclAllsupport[1] = "FTP"
aclAllsupport[2] = "HTTP"
aclAllsupport[3] = "SAMBA"
aclAllsupport[4] = "UPNP"
aclAllsupport[5] = "ICMP"


function GetAclExit(service, direction)
    for i=1, 4 do
        local errcode, ACLAccessType = dm.GetParameterValues("InternetGatewayDevice.ACL."..i..".", {"X_Service", "X_Direction"})
        print('GetAclExit error = ', errcode)
        if nil ~= ACLAccessType then
            for k, v in pairs(ACLAccessType) do
                if service ==  v["X_Service"] and direction == v["X_Direction"] then
                    print('acl exit now')
                    return false
                end
            end
        end
    end
    return true
end


function getaclisValid(name)
    -- body
    for i=1, 5 do
        if name == aclAllsupport[i] then
            print("valid acl types")
            return true
        end
    end
    return false
end

function add_acl_sync()
    local acldomain = "InternetGatewayDevice.ACL."
    for k,v in pairs(data["acls"]) do
        if (getaclisValid(v.service) == true and GetAclExit(v.service, v.direction) == true)then
            local errcode, paramErrs = dm.AddObjectToDB("InternetGatewayDevice.ACL.", 
                    {{"X_Service", v.service}, {"X_Direction", v.direction}})
            if errcode ~= nil then
                print("acl acl errcode = ", errcode)
            end
        end
    end
end

if nil ~= data and nil ~= data["acls"] then
    add_acl_sync()
end

