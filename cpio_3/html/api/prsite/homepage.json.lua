require('dm')
require('json')
require('utils')
require('sys')

local errcode,val= dm.GetParameterValues("InternetGatewayDevice.X_Config.Prsite.", {"HomePagePrsiteUrl","EnablePriorityBits"})

local obj = {}

local s = val["InternetGatewayDevice.X_Config.Prsite."]["EnablePriorityBits"]
local   op1 = sys.getbit(s,0)
obj.Homepage = val["InternetGatewayDevice.X_Config.Prsite."]["HomePagePrsiteUrl"]
obj.EnableRedirection = op1
print("EnableRedirection:"..obj.EnableRedirection)
print("Homepage:"..obj.Homepage)
sys.print(json.xmlencode(obj))






















