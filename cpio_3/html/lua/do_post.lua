local web = require('web')
local utils = require('utils')
local _G = _G
local string = string

local api = _G["FormData"]["API"]
local apicontent = web.getfile(api)
data = utils.getRequestData()
if nil == data then
	utils.xmlappenderror(100005)
	utils.response()
	return
end
print("\n\n=================  Do post for "..api.."=================")

err = {}
local csrfString = web.getTokenFromHttpHeader()
local csrfErr = web.checkcsrf("",csrfString )

if api == '/api/prsite/getrandurl.lua' then
    csrfErr = 0
end
if csrfErr ~=0 then
	print("\n\n=================csrfErr :",csrfErr)
	local name, level = web.getuserinfo()
		if level == 0 or api == '/api/user/login.lua' or api == '/api/user/challenge_login.lua' or api == '/api/user/authentication_login.lua' then
			local param, token = web.getcsrf()
			web.setHeaderRequestVerificationToken(token,"token")
		end
	utils.xmlappenderror(125003)
else
	if apicontent == nil then
		utils.xmlappenderror(1001)
	else
		prog = loadstring(apicontent)
		if prog then
			prog()
		else
			print(api.." format error.")
		end
		--login.lua中单独处理token分配32个token
		if api ~= '/api/user/login.lua' and api ~= '/api/user/authentication_login.lua' then
                    if api ~= '/api/prsite/getrandurl.lua' then
			    local param, token = web.getcsrf()
			    web.setHeaderRequestVerificationToken(token,"token")		
                    end
		end
	end
end

if api ~= '/api/test/autotestget.lua' then
	utils.response()	
end
-- utils.response()