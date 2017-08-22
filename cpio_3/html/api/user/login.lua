local utils = require('utils')
local web = require('web')

local csrf = web.getTokenFromHttpHeader()
if nil == data or nil == data['Username'] or nil == data['Password'] then
    return
end
local level,err,failcount,waittime,first,wizard = web.login(data['Username'], web.base64Decode(data['Password']), csrf)

g_errMap = {
  ["108003"] = "4784232,4784233",
  ["108006"] = "4784229,4784230",
  ["108007"] = "4784231"
}

if err == 0 then
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

if err == 4784229 or err == 4784230 then
    if failcount < 3 then
        utils.xmlappenderror(108006)--ATP_WEB_RET_INVALID_USERNAME --ATP_WEB_RET_INVALID_PASSWORD
        utils.appendErrorItem('count', failcount)
    else
        web.setHistoryLoginInfo(-1)
        utils.xmlappenderror(108007)--ATP_WEB_RET_LOGIN_WAIT
        utils.appendErrorItem('waittime', waittime)
    end
elseif err == 4784231 then
    web.setHistoryLoginInfo(-1) 
    utils.xmlappenderror(108007)--ATP_WEB_RET_LOGIN_WAIT
    utils.appendErrorItem('waittime', waittime)         
else        
    utils.xmlappenderror(err) --ATP_WEB_RET_TOO_MANY_USERS
end