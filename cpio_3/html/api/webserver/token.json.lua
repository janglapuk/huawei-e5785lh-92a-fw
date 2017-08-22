local web  = require('web')
local json = require('json')

local csrf_param, csrf_token = web.getcsrf()

local response = {}
response.token = csrf_param..csrf_token

sys.print(json.xmlencode(response))