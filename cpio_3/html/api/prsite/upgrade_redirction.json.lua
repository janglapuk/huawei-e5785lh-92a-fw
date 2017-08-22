require('dm')
require('json')
require('utils')
require('sys')

local errcode,val = dm.GetParameterValues("InternetGatewayDevice.X_Config.Prsite.", {"CurrUpdateState"})

local obj = {}

local s = val["InternetGatewayDevice.X_Config.Prsite."]["CurrUpdateState"]
print("upgrade_redirction:"..s)
obj.upgrade_redirction = s
sys.print(json.xmlencode(obj))






















