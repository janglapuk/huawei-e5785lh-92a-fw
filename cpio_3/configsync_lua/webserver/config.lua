local utils = require('utils')

function SetObjParamInputs(domain, data, maps)
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

if nil ~= data and nil ~= data["version"] then
    local objdomin = "InternetGatewayDevice.X_Config.webserver.config."
    local paras = {{"version", data["version"]}}
    local errcode, paramErrs = dm.SetObjToDB(objdomin,paras)
end

if nil ~= data then
    local errcode=0
    local paramErrs = nil
    if nil ~= data["user"] then
        if nil ~= data["user"]["main_page"] then
            local objdomin = "InternetGatewayDevice.X_Config.webserver.config.user."
            local maps = {
                main_page="main_page",
            }
            local param = SetObjParamInputs(objdomin, data["user"], maps)
            errcode, paramErrs = dm.SetObjToDB(objdomin,param)
        end
        if nil ~= data["user"]["hilink_login"] then
            local objhilink = "InternetGatewayDevice.X_Config.webserver.config.user."
            local maps = {
                hilink_login="hilink_login",
            }
            local param = SetObjParamInputs(objhilink, data["user"], maps)
            errcode, paramErrs = dm.SetObjToDB(objhilink,param)
        end
        if nil ~= data["user"]["loginusername_enable"] then
            local objloginusername = "InternetGatewayDevice.X_Config.webserver.config.user."
            local maps = {
                loginusername_enable="loginusername_enable",
            }
            local param = SetObjParamInputs(objloginusername, data["user"], maps)
            errcode, paramErrs = dm.SetObjToDB(objloginusername,param)
        end		
        if nil ~= data["user"]["password_with_session"] then
            local user = "InternetGatewayDevice.UserInterface.X_Web.UserInfo.1."
            local usermaps = {
                password_with_session="Userpassword",
            }
            data["user"]["password_with_session"] = dm.base64Decode(data["user"]["password_with_session"])
            local param = SetObjParamInputs(user, data["user"], usermaps)
            errcode, paramErrs = dm.SetObjToDB(user,param)
        end
        if nil ~= data["user"]["username"] and "" ~= data["user"]["username"] and nil ~= data["user"]["password"] and "" ~= data["user"]["password"] then
            local userdomain = "InternetGatewayDevice.UserInterface.X_Web.UserInfo.2."
            local paras = {{"Username", data["user"]["username"]},{"Userpassword", data["user"]["password"]}}
            errcode, paramErrs = dm.SetObjToDB(userdomain,paras)
            print("user errcode = ", errcode)
        end
        print('webserver config sync errcode:', errcode)
    end
    if nil ~= data["admin"] then
        if nil ~= data["admin"]["username"] and "" ~= data["admin"]["username"] and nil ~= data["admin"]["password"] and "" ~= data["admin"]["password"] then
            local admindomain = "InternetGatewayDevice.UserInterface.X_Web.UserInfo.1."
            local paras = {{"Username", data["admin"]["username"]},{"Userpassword", data["admin"]["password"]}}
            errcode, paramErrs = dm.SetObjToDB(admindomain,paras)
            print("admin errcode = ", errcode)
        end
    end
    return errcode, paramErrs
end