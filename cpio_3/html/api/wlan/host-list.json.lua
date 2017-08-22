local utils = require('utils')
require('dm')
require('web')
require('json')
require('utils')
local Hosts = {}
local response = {}

local count = 1;

local errcode,hostipinfo = dm.GetParameterValues("InternetGatewayDevice.LANDevice.1.Hosts.Host.{i}.",
    {
		"IPAddress",
		"MACAddress",
		"HostName"
    }
);

local errcode1,hostipinfo1 = dm.GetParameterValues("InternetGatewayDevice.LANDevice.2.Hosts.Host.{i}.",
    {
		"IPAddress",
		"MACAddress",
		"HostName"
    }
);

function get_host_ip( mac )
	for k,v in pairs(hostipinfo) do
		if ( mac == v["MACAddress"] ) then
			return v["IPAddress"]
		end
	end

	if( nil ~= hostipinfo1 ) then
		for k1,v1 in pairs(hostipinfo1) do
			if ( mac == v1["MACAddress"] ) then
				return v1["IPAddress"]
			end
		end
	end
end

function get_host_hostname( mac )
	for k,v in pairs(hostipinfo) do
		if ( mac == v["MACAddress"] ) then
			return v["HostName"]
		end
	end

	if( nil ~= hostipinfo1 ) then
		for k1,v1 in pairs(hostipinfo1) do
			if ( mac == v1["MACAddress"] ) then
				return v1["HostName"]
			end
		end
	end
end

function find_same_sta(mac)
	for k,v in pairs(Hosts) do
		for k1,v1 in pairs(v) do
			if mac == v1 then
				return true
			end
		end
	end
	return false
end

local errcode,wifiConf = dm.GetParameterValues("InternetGatewayDevice.X_Config.Wifi.Radio.{i}.",
    {
        "Enable"
    }
);

for k,v in pairs(wifiConf) do
    local errcode2,wifissid = dm.GetParameterValues(k.."Ssid.{i}.", {"Enable",
																	"Status",
																	"BSSID",
																	"SSID",
																	"AdvertisementEnabled",
																	"RadioEnabled",
																	"TotalAssociations",
																	"AssociateDeviceNum",
																	"IsolateControl",
																	"DisassocTime",
																	"OffTime",
																	"RTSThreshold",
																	"FragThreshold",
																	"DtimPeriod",
																	"BeaconPeriod",
																	"BridgeInfo"
																	})
	for k1,v1 in pairs(wifissid) do
		local errcode3,stainfos = dm.GetParameterValues(k1.."AssociatedDevice.{i}.", {"MACAddress",
																					"IPAddress",
																					"StayTime",
																					"Name"})
		for k4,v4 in pairs(stainfos) do
			local Host ={}
			Host.ID = count
			count = count+1
			Host.MacAddress = v4["MACAddress"]
			Host.IpAddress = get_host_ip( Host.MacAddress )
			Host.HostName = get_host_hostname( Host.MacAddress )
			Host.AssociatedTime = v4["StayTime"]
			Host.AssociatedSsid = v1["SSID"]

			if false == find_same_sta(Host.MacAddress) then
				table.insert(Hosts, Host)
			end
		end
	end
end

response.Hosts = Hosts
sys.print(json.xmlencode(response))
