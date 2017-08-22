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
local domain = wanpath.."PortMapping.{i}."
local errcode,objs= dm.GetParameterValues(domain, {"PortMappingDescription", "PortMappingEnabled", 
	"RemoteHost", "ExternalPort", "ExternalPortEndRange", "InternalPort", "InternalPortEndRange", "InternalClient", "PortMappingProtocol"})

local resp = {}
resp.Servers = {}
for k,v in pairs(objs) do
local Index
	--print("key is "..k)
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
	map.VirtualServerIPName = v["PortMappingDescription"]
	map.VirtualServerStatus = utils.toboolean(v["PortMappingEnabled"])
	map.VirtualServerRemoteIP = v["RemoteHost"]
	map.VirtualServerWanPort = v["ExternalPort"]
	map.VirtualServerWanEndPort = v["ExternalPortEndRange"]
	map.VirtualServerLanPort = v["InternalPort"]
	map.VirtualServerLanEndPort = v["InternalPortEndRange"]
	map.VirtualServerIPAddress = v["InternalClient"]
	map.VirtualServerProtocol = parse_protocol(v["PortMappingProtocol"])
	Index = tonumber(Index)
    resp.Servers[Index] = {}
	resp.Servers[Index] =  map
end

--get the TR069 ConnReqPort------------
function Get_Tr069DisplaySwitch()
local errcode,SwitchValues = dm.GetParameterValues("InternetGatewayDevice.Services.X_CWMPDISPLAY.",{"Cwmp_Display"})
	--print("Get_Tr069DisplaySwitch errcode is "..errcode)
	if nil ~= SwitchValues and utils.toboolean(SwitchValues["InternetGatewayDevice.Services.X_CWMPDISPLAY."]["Cwmp_Display"]) then
	--print("cwmp  module Switch is on")
		return true
	else
	--print("cwmp  module Switch is off")
		return false
	end
end

--check  PortMapping and TR069 port conflict------------

--全字符串匹配----------------
--入参------------------------
----str1: 被查找对象----------
----str2: 查找对象------------
----SecChar: 分段符------------
----BrkChar: 分隔符------------
--返回值----------------------
----ture: 包含被查找对象------
----false: 不包含被查找对象---
----0: 入参错误---

function CheckTR069PortFromePM(str1,str2,SecChar,BrkChar)
	--print("CheckTR069PortFromePM come in ; str1-str2 is "..str1.."---"..str2)
	--print(type(str1))
	--print(type(str2))
	if nil == str1 or nil == str2 then 
	    print("str1 or str2 is nil ; str1-str2 is "..str1.."-"..str2)
		return 0
	end
local str1len=string.len(str1)
local str2len=string.len(str2)
	if str1len == 0 or str2len == 0 then
	    print("str1 len  or str2 len is nil ; str1len-str2len is "..str1len.."-"..str2len)
		return 0
	end
	if str1len < str2len then
	    print("str1 len is small than  str2 len ; str1len-str2len is "..str1len.."-"..str2len)
		return 0
	end
	--长度相同的字串，直接比较
	if str1len == str2len then
		if str1 == str2 then
			return true
		else
			print("not find str2 from str1")
			return false
		end
	end
local TempPort=""
local StartPort=""

	for i=1,str1len do
		temp = string.sub(str1,i,i)
		--print("temp is"..temp)
		if temp == SecChar then
			if BrkChar == "" then 
				if tonumber(TempPort) == tonumber(str2) then
					return true
				else
				   --print("TempPort is "..TempPort)
				   TempPort=""
				end
			else
				if  tonumber(str2) < tonumber(StartPort) or tonumber(str2) > tonumber(TempPort) then
				    --print("StartPort--TempPort is "..StartPort.."--"..TempPort)
				    TempPort=""
					StartPort=""
				else
					return true
				end
			end
		elseif temp == BrkChar then
			StartPort=TempPort
			TempPort=""
		else
			--去除隔断中的空格
			if temp ~= " " then
			TempPort = TempPort..temp
			end
		end
		i=i+1
	end
	--处理最后一个没有 分割符的 字串
	if BrkChar == "" then 
		if TempPort == str2 then
			return true
		else
			return false
		end
	else
		if  tonumber(str2) < tonumber(StartPort) or tonumber(str2) > tonumber(TempPort) then
			--print("str2-StartPort-TempPort is "..str2.."-"..StartPort.."-"..TempPort)
			return false
		else
			return true
		end
	end
end
--print("Get_Tr069DisplaySwitch ")
local Tr069DisplayStatus = Get_Tr069DisplaySwitch()
local TR069_ConnReqPort = nil

if true == Tr069DisplayStatus then 
local errcode,TR069Value = dm.GetParameterValues("InternetGatewayDevice.ManagementServer.",{"X_ConnReqPort"})
	--print("Then errcode is "..errcode)
	if nil ~= TR069Value then
	local TR069_obj = TR069Value["InternetGatewayDevice.ManagementServer."]
		if nil ~= TR069Value and nil ~= TR069_obj["X_ConnReqPort"] and TR069_obj["X_ConnReqPort"] ~= "0" then
			TR069_ConnReqPort = TR069_obj["X_ConnReqPort"]
			--print("TR069_ConnReqPort is "..TR069_ConnReqPort)
		end
	end
else
	--print("TR069_ConnReqPort is nil ")
end

--get the exclude ports or portintervals------------
resp.PmExPorts = {}
PortMap = {}
local Tmp_ports=""
local Tmp_portintervals=""
Tmp_ports,Tmp_portintervals=sys.getPMExPorts()
--print("Tmp_ports is "..Tmp_ports)
--print("Tmp_portintervals is "..Tmp_portintervals)

if true == Tr069DisplayStatus and nil ~= TR069_ConnReqPort then
	if CheckTR069PortFromePM(Tmp_ports,TR069_ConnReqPort,",","") == false and CheckTR069PortFromePM(Tmp_portintervals,TR069_ConnReqPort,",","-") == false then   
		Tmp_ports = TR069_ConnReqPort..", "..Tmp_ports
		--print("Tmp_ports is "..Tmp_ports)
	else
		--print("TR069_ConnReqPort in the ports of Port Mapping ")
	end
end

PortMap.virtual_server_special_ports = Tmp_ports
PortMap.virtual_server_special_portintervals = Tmp_portintervals
table.insert(resp.PmExPorts,PortMap)

sys.print(json.xmlencode(resp))

