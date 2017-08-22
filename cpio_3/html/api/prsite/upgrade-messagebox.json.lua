require('dm')
require('json')
require('utils')
require('sys')
local errcode,val= dm.GetParameterValues("InternetGatewayDevice.X_Config.Prsite.", {"MessageBoxEnable"})
local obj = {}

obj.messagebox = val["InternetGatewayDevice.X_Config.Prsite."]["MessageBoxEnable"]
print("messagebox:"..obj.messagebox)
sys.print(json.xmlencode(obj))

