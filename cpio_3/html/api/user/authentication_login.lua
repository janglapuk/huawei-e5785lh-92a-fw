require('utils')
require('web')


local err1,serversignature,rsapubkeysignature,level,failcount,waittime,fromapp,ishilink = web.proof(data['clientproof'], data['finalnonce'])
local rsan,rsae = web.getrsakey()
print("err1",err1)


if err1 == 0 then
    local thirtyToken=""
    local param, token = web.getcsrf()
    web.setHeaderRequestVerificationToken(token,"one")
    local paramTwo, tokenTwo = web.getcsrf()
    web.setHeaderRequestVerificationToken(tokenTwo,"two")
    web.setHistoryLoginInfo(0)
    if nil ~= token then
        thirtyToken = token.."#"..tokenTwo
    end
    local count = 30
    while count > 0 do
        count = count-1
        local param, token = web.getcsrf()
        thirtyToken = thirtyToken.."#"..token
    end
    web.setHeaderRequestVerificationToken(thirtyToken,"token")
else
    local param, token = web.getcsrf()
    web.setHeaderRequestVerificationToken(token,"token")
end

if 0 == err1 then
    --utils.xmlappenderror(err1)
    utils.appendErrorItem('serversignature', serversignature)
    utils.appendErrorItem('rsapubkeysignature', rsapubkeysignature)
    utils.appendErrorItem('rsan', rsan)
    utils.appendErrorItem('rsae', rsae)	
else
    if err1 == 108003 then
        utils.xmlappenderror(108003)
        utils.appendErrorItem('count', failcount)
    else
        utils.xmlappenderror(108006)
    end    
    local errcode,failedvalues = dm.GetParameterValues("InternetGatewayDevice.UserInterface.X_Web.",{"DefaultMaxFailTimes"});
    local obj = failedvalues["InternetGatewayDevice.UserInterface.X_Web."]
    local failtimes = obj["DefaultMaxFailTimes"]
    --4784229 4784230表示用户名,密码错误; 4784231表示3次登陆失败，等1min，4784232表示重复登陆 4784233表示用户过多，47844784258表示token过期
    --这里的错误码与modal相互关联，对应的是webapi.h里面的错误码
    if err1 == 4784229 or err1 == 4784230 then
        if failcount < failtimes then
            utils.xmlappenderror(108006)--ATP_WEB_RET_INVALID_USERNAME --ATP_WEB_RET_INVALID_PASSWORD
            utils.appendErrorItem('count', failcount)
        else
            web.setHistoryLoginInfo(-1)
            utils.xmlappenderror(108007)--ATP_WEB_RET_LOGIN_WAIT
            utils.appendErrorItem('waittime', waittime)
        end 
    elseif loginerr == 4784231 then
        web.setHistoryLoginInfo(-1)	
        utils.xmlappenderror(108007)--ATP_WEB_RET_LOGIN_WAIT
        utils.appendErrorItem('waittime', waittime)         
    end
end