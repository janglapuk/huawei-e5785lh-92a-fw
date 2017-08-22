local profiles = {}

local domain = "InternetGatewayDevice.X_Config.Wifi.Radio.1.EndPoint.1.Profile."
local errcode, db_profile = dm.GetParameterValues("InternetGatewayDevice.X_Config.Wifi.Radio.1.EndPoint.1.Profile.{i}.",
	{
		"SSID","SecurityMode"
	})

--查找defaultcfg.xml和staprofile.xml中SSID和安全类型都相同的profile，合并两个profile
function search_profile(xml_proflie)
	for k, v in pairs(db_profile) do
		if v["SSID"] == xml_proflie.wifissid and v["SecurityMode"] == xml_proflie.wifiauthmode then
			-- set profile
			local maps = {
				type = "PreSet",
				wifieaptype = "EapType",
				wifiwisprenable = "WisprEnable",
				profileenable = "Enable"
			}
			local param = SetObjParamInputs(k, xml_proflie, maps)
			local errcodeprofile, paramErrs = dm.SetObjToDB(k, param)
			return true
		end
	end
	return false
end

--计算defaultcfg.xml中profile个数
function profile_get_num()
	local errorcode, num, array = dm.GetObjNum("InternetGatewayDevice.X_Config.Wifi.Radio.1.EndPoint.1.Profile.{i}")
	return num
end

function profile_sync()
	local index = profile_get_num() + 1
	for k, v in pairs(data["profiles"]) do
		if false == search_profile(v) then
			-- add profile
			local errcode, paramErrs = dm.AddObjectToDB(domain..index..".",
			{{"SSID", v.wifissid},
			 {"SecurityMode", v.wifiauthmode},
			 {"PreSet", v.type},
			 {"EapType", v.wifieaptype},
			 {"WisprEnable", v.wifiwisprenable},
			 {"Enable", v.profileenable}
			})
			index = index + 1
		end
	end
end

if nil ~= data and nil ~= data["profiles"] then
	profile_sync()
end