local utils = require('utils')
local web = require('web')

loginerr,salt,iteration,servernonce,failcount,waittime,fromapp,ishilink = web.nonce(data['username'], data['firstnonce'])
--print("err:"..tostring(loginerr)..",salt:"..salt..",iteration:"..tostring(iteration)..",servernonce:"..servernonce)
if 0 == loginerr then
	--print("setp 0 ")
	--utils.xmlappenderror(0)
	--print("setp 1 ")
	utils.appendErrorItem('salt', salt)
	--print("setp 2 ")
	utils.appendErrorItem('iterations', iteration)
	--print("setp 3 ")
	utils.appendErrorItem('servernonce', servernonce)
	--print("setp 4 ")
	utils.appendErrorItem('modeselected', 1)	
	--print("setp 5 ")

else
    if loginerr == 108003 then
        utils.xmlappenderror(108003)
        utils.appendErrorItem('count', failcount)
    else
        utils.xmlappenderror(108006)
    end 
    local errcode,failedvalues = dm.GetParameterValues("InternetGatewayDevice.UserInterface.X_Web.",{"DefaultMaxFailTimes"});
    local obj = failedvalues["InternetGatewayDevice.UserInterface.X_Web."]
    local failtimes = obj["DefaultMaxFailTimes"]
    --4784229 4784230±íÊ¾ÓÃ»§Ãû,ÃÜÂë´íÎó; 4784231±íÊ¾3´ÎµÇÂ½Ê§°Ü£¬µÈ1min£¬4784232±íÊ¾ÖØ¸´µÇÂ½ 4784233±íÊ¾ÓÃ»§¹ý¶à£¬47844784258±íÊ¾token¹ýÆÚ
    --ÕâÀïµÄ´íÎóÂëÓëmodalÏà»¥¹ØÁª£¬¶ÔÓ¦µÄÊÇwebapi.hÀïÃæµÄ´íÎóÂë
    if loginerr == 4784229 or loginerr == 4784230 then
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
