local web  = require('web')
local json = require('json')

local session, token = web.getSesTokInfo()

local response = {}

response.SesInfo = session
response.TokInfo = token
sys.print(json.xmlencode(response))