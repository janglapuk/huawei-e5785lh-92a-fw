require('dm')
require('utils')
require('sys')

local errcode=0

if nil == data then
    return
end

function isolate_check_parameter()
if data.lanwlanisolatetype == "1" or data.lanwlanisolatetype == "2" then
    return true
else 
    print("lan-wlanisolate, paramerr check error for isolate type")
    return false
end

if data.lanwlanisolatevalue == "1" or data.lanwlanisolatevalue == "0" then
    return true
else 
    print("lan-wlanisolate, paramerr check error for isolate value")
    return false
end

end

function isolate_set_parameter()
if data.lanwlanisolatetype == "1" then
    errcode = dm.SetParameterValues("InternetGatewayDevice.X_LanWlanIsolate.LanWlanIsolateEnable", data.lanwlanisolatevalue)
end
if data.lanwlanisolatetype == "2" then
    errcode = dm.SetParameterValues("InternetGatewayDevice.X_LanWlanIsolate.WlanIsolateEnable", data.lanwlanisolatevalue)
end
end

if false == isolate_check_parameter() then
	print("isolate_check_parameter err")
	utils.xmlappenderror(9003)
	return
end

isolate_set_parameter()

if errcode == 0 then
	print("isolate_set_parameter success.")
else
	print("isolate_set_parameter fail.")
end
utils.xmlappenderror(errcode)



