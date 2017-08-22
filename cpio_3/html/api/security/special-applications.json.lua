require('dm')
require('json')
require('utils')
require('sys')

function parse_protocol(proto)
	if proto == "TCP" then
		return 6
	elseif proto == "UDP" then
		return 17
	else
		return 0
	end
end

local wanpath = utils.getCradleAutoIPWan()
local domain = wanpath.."X_PortTrigger.{i}."
local errcode,objs= dm.GetParameterValues(domain, {"PortTriggerDescription", "PortTriggerEnable", "TriggerPort", 
	"Protocol", "TriggerProtocol", "OpenPort", "OpenPortEnd", "OpenPort1", "OpenPortEnd1", "OpenPort2", "OpenPortEnd2",
	"OpenPort3", "OpenPortEnd3", "OpenPort4", "OpenPortEnd4"})

local resp = {}
resp.LanPorts = {}
for k,v in pairs(objs) do
local Index
	--print("key is "..k)
	--print("VirtualServerIPName is "..v["PortMappingDescription"])
	--从key值中读取实例号
	Index = utils.getIndexFromKey(k)
	if Index == false then 
		local response = {}
		response.code = 100008 --100008 读取配置文件节点错误
		response.message = ""
		sys.print(json.xmlencode(response,"error"))
		return	false
	end

	local map = {}
	map.SpecialApplicationTriggerName = v["PortTriggerDescription"]
	map.SpecialApplicationTriggerStatus = utils.toboolean(v["PortTriggerEnable"])
	map.SpecialApplicationTriggerPort = v["TriggerPort"]
	map.SpecialApplicationTriggerProtocol = parse_protocol(v["TriggerProtocol"])
	map.SpecialApplicationOpenProtocol = parse_protocol(v["Protocol"])
	map.SpecialApplicationStartOpenPort0 = v["OpenPort"]
	map.SpecialApplicationEndOpenPort0 = v["OpenPortEnd"]
	map.SpecialApplicationStartOpenPort1 = v["OpenPort1"]
	map.SpecialApplicationEndOpenPort1 = v["OpenPortEnd1"]
	map.SpecialApplicationStartOpenPort2 = v["OpenPort2"]
	map.SpecialApplicationEndOpenPort2 = v["OpenPortEnd2"]
	map.SpecialApplicationStartOpenPort3 = v["OpenPort3"]
	map.SpecialApplicationEndOpenPort3 = v["OpenPortEnd3"]
	map.SpecialApplicationStartOpenPort4 = v["OpenPort4"]
	map.SpecialApplicationEndOpenPort4 = v["OpenPortEnd4"]
	Index = tonumber(Index)
    resp.LanPorts[Index] = {}
	resp.LanPorts[Index] =  map
end

sys.print(json.xmlencode(resp))