require('dm')
require('json')
require('utils')
require('sys')

local errcode,val= dm.GetParameterValues("InternetGatewayDevice.Services.X_DHCPSDNSDISPLAY.", {"Enable"})
local errcode1,val1= dm.GetParameterValues("InternetGatewayDevice.Services.X_DHCPSIPALLCONFIGDISPLAY.", {"Enable"})

local obj = {}

obj.dhcpsdns_display = val["InternetGatewayDevice.Services.X_DHCPSDNSDISPLAY."]["Enable"]
obj.dhcps_ipallconfig_display = val1["InternetGatewayDevice.Services.X_DHCPSIPALLCONFIGDISPLAY."]["Enable"]

sys.print(json.xmlencode(obj))