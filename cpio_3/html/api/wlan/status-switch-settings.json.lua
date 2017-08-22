require('dm')
require('json')
require('utils')
local radios = {}
local response = {}

local errcode, wifiConf = dm.GetParameterValues("InternetGatewayDevice.X_Config.Wifi.Radio.{i}.",
    {
        "Enable"
    }
)

function get_index_by_key(key)
    local radioindex = string.match(key, "%d+")
	if(nil == radioindex) then
		return nil
	else
		return radioindex
	end
end

for k, v in pairs(wifiConf) do
	local radio = {}
	radio.index = get_index_by_key(k) - 1
	if(nil == radio.index) then
		return sys.print(json.xmlencode("error"))
	end
	radio.ID = k
	radio.wifienable = v["Enable"]
	table.insert(radios, radio)
end

utils.multiObjSortByID(radios)
response.radios = radios
sys.print(json.xmlencode(response))