local utils = require('utils')


local objdomin = "InternetGatewayDevice.Services.X_SmartPush.InterestGroup."

local gwd = data["gwd"]

local gwdurls = gwd["url"]

local diagnet = data["diagnet"]
local upgrade = data["upgrade"]
local upgradeurl = upgrade["url"]

local smartpush = data["smartpush"]
local smartpushurl = smartpush["url"]

function splitUrl(str, sep)
    local start = 1
    local pre = nil
    local retval = {}
    if nil == str then
        return retval
    end
    while true do
        ip,fp = string.find(str, sep, start)
        if not ip then 
            if start < string.len(str) then
                table.insert(retval, string.sub(str, start))
            end
            break 
        end
        if start < ip -1 then
            table.insert(retval, string.sub(str, start, ip-1))
        end
        start = fp + 1
    end
    return retval
end


print(gwd["Name"],gwd["Enable"],gwd["Type"],gwd["PushLink"])
local errcode, groupinstid, paramErrs = dm.AddObjectToDB(objdomin, {{"Name", gwd["Name"]}, {"Enable", gwd["Enable"]}, {"Type", gwd["Type"]}, {"PushLink", gwd["PushLink"]}})

if errcode ~= nil then
    print("add gwd group = ", errcode,groupinstid)
    
    if errcode == 0 and gwdurls ~= nil then
        print(gwdurls)
        local urlarray = splitUrl(gwdurls,"|")
        local urldomain = objdomin..groupinstid..".URL."
        for k,v in pairs(urlarray) do
            local errcode, urlinstid, paramErrs = dm.AddObjectToDB(urldomain, {{"URL", v}})
            print("urlinstid",urlinstid)
        end
    end

end

print(diagnet["Name"],diagnet["Enable"],diagnet["Type"],diagnet["PushLink"])
local errcode, groupinstid,paramErrs = dm.AddObjectToDB(objdomin, {{"Name", diagnet["Name"]}, {"Enable", diagnet["Enable"]}, {"Type", diagnet["Type"]}, {"PushLink", diagnet["PushLink"]}})
if errcode ~= nil then
    print("add diagnet group = ", errcode,groupinstid)
end

print(upgrade["Name"],upgrade["Enable"],upgrade["Type"],upgrade["PushLink"])
local errcode, groupinstid,paramErrs = dm.AddObjectToDB(objdomin, {{"Name", upgrade["Name"]}, {"Enable", upgrade["Enable"]}, {"Type", upgrade["Type"]}, {"PushLink", upgrade["PushLink"]}})
if errcode ~= nil then
    print("add hota upgrade group = ", errcode,groupinstid)
     if errcode == 0 and upgradeurl ~= nil then
        print(upgradeurl)
        local urlarray = splitUrl(upgradeurl,"|")
        local urldomain = objdomin..groupinstid..".URL."
        for k,v in pairs(urlarray) do
            local errcode, urlinstid, paramErrs = dm.AddObjectToDB(urldomain, {{"URL", v}})
            print("upgrade urlinstid",urlinstid)
        end
    end
end
local errcode, groupinstid,paramErrs = dm.AddObjectToDB(objdomin, {{"Name", smartpush["Name"]}, {"Enable", smartpush["Enable"]}, {"Type", smartpush["Type"]}, {"PushLink", smartpush["PushLink"]}})
if errcode ~= nil then
    print("add hota smartpush group = ", errcode,groupinstid)
     if errcode == 0 and smartpushurl ~= nil then
        print(smartpushurl)
        local urlarray = splitUrl(smartpushurl,"|")
        local urldomain = objdomin..groupinstid..".URL."
        for k,v in pairs(urlarray) do
            local errcode, urlinstid, paramErrs = dm.AddObjectToDB(urldomain, {{"URL", v}})
            print("smartpush urlinstid",urlinstid)
        end
    end
end

return errcode