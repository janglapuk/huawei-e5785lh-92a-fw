local utils = require('utils')
require('dm')
require('web')
require('json')
require('utils')
local unknow_error = "<error>\r\n<code>100011</code>\r\n<message>special strings</message>\r\n</error>\r\n";
local response = {}


local errcode,wifiConf = dm.GetParameterValues("InternetGatewayDevice.X_Config.Wifi.Radio.{i}.",
    {
        "Enable"
    }
);


local radiocount = 0;
local ssidcount = 0;
for k,v in pairs(wifiConf) do
	radiocount = radiocount +1
	local errcode1,wifissid = dm.GetParameterValues(k.."Ssid.{i}.", {"Enable"})
	for k2,v2 in pairs(wifissid) do
		--print("k2="..k2.."v2="..v2["Enable"])
		ssidcount = ssidcount+1
	end
end

local radioDomain = "InternetGatewayDevice.X_Config.Wifi.Radio."
--获取指定radio下开启的ssid的个数
function get_radio_up_ssid_num(radio_idx)
	local ssid_num = 0;
    --radio所以不是1，或者 2 返回nil
    if(1 ~= radio_idx and 2 ~= radio_idx) then
	return nil
    end
	
	local radioerrcode,radioinfo = dm.GetParameterValues(radioDomain..radio_idx..".",
	    {
	        "Enable"
	    });
	
	for k3,v3 in pairs(radioinfo) do
		local ssiderrcode,wifissid = dm.GetParameterValues(k3.."Ssid.{i}.", {"Enable"})
		for k4,v4 in pairs(wifissid) do
		    if(nil ~= v4["Enable"] and 1 == v4["Enable"])then
				ssid_num = ssid_num+1
			end
		end
	end
	return ssid_num;
end

--获取DBDC模式是否开启
local wifi_dbdc_enable
local domain = "InternetGatewayDevice.X_Config.Wifi."
local errcode, dbdcConf = dm.GetParameterValues(domain,{"WifiDbdcEnable"})
if(nil ~= dbdcConf)then
	dbdcConf = dbdcConf[domain]
	wifi_dbdc_enable = dbdcConf["WifiDbdcEnable"]
end

--如果配置DBDC开启 并且是两个芯片
if (1 == wifi_dbdc_enable and 2 == radiocount) then
	--如果是DBDC模式或者是2.4G双AP模式,状态返回1
	local ssid_num_2 = get_radio_up_ssid_num(1)
	local ssid_num_5 = get_radio_up_ssid_num(2)
	if(nil ~= ssid_num_2 and nil ~= ssid_num_5) then
		--DBDC模式
		if(1 == ssid_num_2 and 1 == ssid_num_5)then
			response.multissidstatus = 1
		--2.4G多AP
		elseif(1 < ssid_num_2 and 0 == ssid_num_5) then
			response.multissidstatus = 1
		else 
			response.multissidstatus = 0
		end
		sys.print(json.xmlencode(response))
		return
	end
end

--该报文只有是单芯片并且最大ap个数为2时才用到
if( 1 ~= radiocount or ( 2 ~= ssidcount)) then
	--print("multi-switch-settings not support")
	--sys.print(json.xmlencode(unknow_error))
	response.multissidstatus = 0
	sys.print(json.xmlencode(response))
	return
end

local errcode2, ssid1enable = dm.GetParameterValues("InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1.", {"Enable"} )
ssid1enable = ssid1enable["InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.1."]
local errcode3, ssid2enable = dm.GetParameterValues("InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.2.", {"Enable"} )
ssid2enable = ssid2enable["InternetGatewayDevice.X_Config.Wifi.Radio.1.Ssid.2."]

response.multissidstatus = 0
if( 1 == ssid1enable["Enable"] and  1 == ssid2enable["Enable"]  ) then
	response.multissidstatus = 1
end

--print("response.multissidstatus = "..response.multissidstatus )
sys.print(json.xmlencode(response))


