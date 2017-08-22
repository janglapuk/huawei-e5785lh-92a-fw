local utils = require('utils')
require('dm')
require('web')
require('json')
require('utils')
local wlan_module = {}
local response = {}

wlan_module.module="wlan"
response.modules = wlan_module
sys.print(json.xmlencode(response))

