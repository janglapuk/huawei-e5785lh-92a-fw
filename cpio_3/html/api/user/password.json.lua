local json      = require("json")
local response = {}
response.encryption_enable = 1
sys.print(json.xmlencode(response))