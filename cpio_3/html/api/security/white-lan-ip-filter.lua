local utils = require('utils')
require('dm')
local string = string
local print = print

--ipfilterWhiteList display Switch Data nodes "InternetGatewayDevice.X_Config.firewall.WhiteListDisplay"
--------------------check the display switch--------------------
local errcode,SwitchValues= dm.GetParameterValues("InternetGatewayDevice.X_Config.firewall.",
        {"WhiteListDisplay"})
		
if utils.toboolean(SwitchValues["InternetGatewayDevice.X_Config.firewall."]["WhiteListDisplay"]) then
--print("WhiteListDisplay display Switch is on")
else
--print("WhiteListDisplay display Switch is off")
    utils.xmlappenderror("100002")
	return	false
end

local IPFilters= {}
local errcode, objs = dm.GetParameterValues("InternetGatewayDevice.X_FireWall.IpFilter.{i}.",
    { 
        "Name",
    	"Status",
        "Priority",
        "Interface",
        "SourceIPStart",
        "SourceIPEnd",
        "DestIPStart",
        "DestIPEnd",
        "Protocol",
        "SourcePortStart",
        "SourcePortEnd",
        "DestPortStart",
        "DestPortEnd",
        "IPVersion",
		"SrcIPandMask",
        "DstIPandMask",
        "IPFltFlag"
    });
-----------------------------------------
--对下发的报文进行校验
-----------------------------------------
if data ~= nil then
	if nil ~= data["IPFilters"] and "" ~= data["IPFilters"] then
		for k,v in pairs(data["IPFilters"]) do    
			local TmpLanIp=0
			local TmpWanIp=0
			local TmpInvalidValue
			if nil == v["LanIPFilterProtocol"] or nil == v["LanIPFilterStatus"] or nil == v["LanIPFilterLanStartAddress"] or nil == v["LanIPFilterWanStartAddress"] or nil == v["LanIPFilterPolicy"] or nil == v["LanIPFilterFlag"] then
				utils.xmlappenderror(9003)
				return
			end
			if  '' == v["LanIPFilterWanStartAddress"] or nil == v["LanIPFilterWanStartAddress"] then
				utils.xmlappenderror(9003)
				return
			end
			TmpLanIp,TmpInvalidValue = string.find(v["LanIPFilterLanStartAddress"],':')
			TmpWanIp,TmpInvalidValue = string.find(v["LanIPFilterWanStartAddress"],':')
			----------------------------------------------------------------IPv4 
			if '0' == v["LanIPFilterFlag"] or nil == v["LanIPFilterFlag"] then
				if nil ~= TmpWanIp then		
					utils.xmlappenderror(9003)
					return
				end
				if '' ~= v["LanIPFilterLanStartAddress"] and nil ~= TmpLanIp then
					utils.xmlappenderror(9003)
					return
				end

			----------------------------------------------------------------IPv6
			elseif '1' == v["LanIPFilterFlag"] then
				if nil == TmpWanIp then
					utils.xmlappenderror(9003)
					return
				end
				if '' ~= v["LanIPFilterLanStartAddress"] and nil == TmpLanIp then								
					utils.xmlappenderror(9003)
					return
				end	   
			else
				utils.xmlappenderror(9003)
				return
			end				
			if '0' ~= v["LanIPFilterProtocol"] and '1' ~= v["LanIPFilterProtocol"] and '6' ~= v["LanIPFilterProtocol"] and '17' ~= v["LanIPFilterProtocol"] then
				utils.xmlappenderror(9003)	
				return
			end 		
		end
	end
end
--------------------------------------------------------------
--需要删除已有的白名单，同时disable黑名单
--staus:0 disable   1:accept 2:deny
--IPFltFlag:表示开关
-- 0 黑名单关闭
-- 1 黑名单开启
-- 2 白名单关闭
-- 3 白名单开启
--------------------------------------------------------------
if objs ~= nil then
    print("begin delete all obj")
	dm.StartTransactionEx("ipfilter")
    for k,v in pairs(objs) do
        if (2 == v["IPFltFlag"]) or (3 == v["IPFltFlag"]) then
            dm.DBDeleteObject(k)                                           --删除白名单
			print("---Delete existed white list---")
		elseif (2 == v["Status"]) and (1 == v["IPFltFlag"]) then           --disable黑名单中enabled的项
			print("---disable existed black list---")
			local ipparas = {}
			utils.add_one_parameter(ipparas, k.."Status", 0)
			local errcode, NeedReboot, paramerr =  dm.SetParameterValues(ipparas)
        end
    end
	dm.EndTransactionEx("ipfilter", 0)
end

--------------------------------------------------------------
--最后设置ip过滤模式，用于页面首先显示哪个分页符
--------------------------------------------------------------
function setmode()
	local ipfltmode = "InternetGatewayDevice.X_Config.firewall."

	if nil ~= ipfltmode then
		local errcode, paramErrs = dm.SetObjToDB(ipfltmode,{{"IpFltMode", true}})
		print("set IpFltMode true result...",errcode)
	end
end

local flag = 100
--------------------------------------------------------------
--配置当前页面下发的白名单参数
--------------------------------------------------------------
if data ~= nil then
	dm.StartTransactionEx("ipfilter")
	if nil == data["IPFilters"] or "" == data["IPFilters"] then
		dm.EndTransactionEx("ipfilter", 2)
		setmode()
		return
	end
	for k,v in pairs(data["IPFilters"]) do
		local TmpProtocol
		local TmpStatus
		local Tmplsip = ""
		local Tmpldip = ""
		local Tmpwsip
		local Tmpwdip       
		local Tmpipversion
		local Tmpwsport=0
		local Tmpweport=0
		local Tmplsport=0
		local Tmpleport=0
		local Tmpsrcipmask = ""
		local Tmpdstipmask
		local Tmpipfltflag=0
		
		if nil == v["LanIPFilterProtocol"] or nil == v["LanIPFilterStatus"] or nil == v["LanIPFilterLanStartAddress"] or nil == v["LanIPFilterWanStartAddress"] or nil == v["LanIPFilterPolicy"] or nil == v["LanIPFilterFlag"] then
			print("Lost some item in restful, please check!")
			dm.EndTransactionEx("ipfilter", 9003)
			utils.xmlappenderror(9003)
			return
		end
		----------------------------------------------------------------IPv4 
		if '0' == v["LanIPFilterFlag"] or nil == v["LanIPFilterFlag"] then
			Tmpipversion = 4 	
		
			if '0' == v["LanIPFilterSrcStartIPMask"] then
				Tmplsip = v["LanIPFilterLanStartAddress"]
				if nil == v["LanIPFilterLanEndAddress"] or '' == v["LanIPFilterLanEndAddress"] then
					Tmpldip = v["LanIPFilterLanStartAddress"]
				else
					Tmpldip = v["LanIPFilterLanEndAddress"]
					Tmpsrcipmask="1"
				end
			elseif '1' == v["LanIPFilterSrcStartIPMask"] then --192.168.8.0
				Tmplsip = v["LanIPFilterLanStartAddress"]
				Tmpldip = string.format("%s%d", string.sub(v["LanIPFilterLanStartAddress"], 1, -2), 254)  
			elseif '2' == v["LanIPFilterSrcStartIPMask"] then --192.168.0.0
				Tmplsip = v["LanIPFilterLanStartAddress"]
				Tmpldip = string.format("%s%s", string.sub(v["LanIPFilterLanStartAddress"], 1, -4), "255.254")
			elseif '3' == v["LanIPFilterSrcStartIPMask"] then --192.0.0.0
				Tmplsip = v["LanIPFilterLanStartAddress"]
				Tmpldip = string.format("%s%s", string.sub(v["LanIPFilterLanStartAddress"], 1, -6), "255.255.254")
			end   

			if '0' == v["LanIPFilterDestStartIPMask"] then
				Tmpwsip = v["LanIPFilterWanStartAddress"]
				if nil == v["LanIPFilterWanEndAddress"] or '' == v["LanIPFilterWanEndAddress"] then
					Tmpwdip = v["LanIPFilterWanStartAddress"]
				else
					Tmpwdip = v["LanIPFilterWanEndAddress"]
					Tmpdstipmask="1"
				end
			elseif '1' == v["LanIPFilterDestStartIPMask"] then --192.168.8.0
				Tmpwsip = v["LanIPFilterWanStartAddress"]
				Tmpwdip = string.format("%s%d", string.sub(v["LanIPFilterWanStartAddress"], 1, -2), 254)
			elseif '2' == v["LanIPFilterDestStartIPMask"] then --192.168.0.0
				Tmpwsip = v["LanIPFilterWanStartAddress"]
				Tmpwdip = string.format("%s%s", string.sub(v["LanIPFilterWanStartAddress"], 1, -4), "255.254")
			elseif '3' == v["LanIPFilterDestStartIPMask"] then --192.0.0.0
				Tmpwsip = v["LanIPFilterWanStartAddress"]
				Tmpwdip = string.format("%s%s", string.sub(v["LanIPFilterWanStartAddress"], 1, -6), "255.255.254")
			elseif '4' == v["LanIPFilterDestStartIPMask"] then
				Tmpwsip = "0.0.0.0"
				Tmpwdip = "0.0.0.0" 
			end
			
			Tmpsrcipmask="0"
			Tmpdstipmask="0"

		----------------------------------------------------------------IPv6
		elseif '1' == v["LanIPFilterFlag"] then
			Tmpipversion = 6
			Tmpwsip, Tmpwdip = sys.getipv6beginend(v["LanIPFilterWanStartAddress"], v["LanIPFilterDestPreFix"])
			Tmpdstipmask=string.format("%s/%s", v["LanIPFilterWanStartAddress"], v["LanIPFilterDestPreFix"])
			if '' ~= v["LanIPFilterLanStartAddress"] then
				Tmplsip, Tmpldip= sys.getipv6beginend(v["LanIPFilterLanStartAddress"], v["LanIPFilterSrcPreFix"])			
				Tmpsrcipmask=string.format("%s/%s", v["LanIPFilterLanStartAddress"], v["LanIPFilterSrcPreFix"])				
			end	   
		else
			print("LanIPFilterFlag is  error : "..v["LanIPFilterFlag"])
			dm.EndTransactionEx("ipfilter", 9003)
			utils.xmlappenderror(9003)
			return
		end
		
		----------------------------------------------------------------不区分v4v6
		
		if '0' ~= v["LanIPFilterPolicy"] then
			print("LanIPFilterPolicy is error : "..v["LanIPFilterPolicy"])
			dm.EndTransactionEx("ipfilter", 9003)
			utils.xmlappenderror(9003)
			return		
		end
		
		if '0' == v["LanIPFilterStatus"] then
				TmpStatus = 0         --表示白名单状态是关
				Tmpipfltflag = 2      --表示白名单开关是关
		elseif '1' == v["LanIPFilterStatus"] then                                                  
				TmpStatus = 1         --表示白名单状态是开
				Tmpipfltflag = 3      --表示白名单开关是开
		else
				print("LanIPFilterStatus is error")
				dm.EndTransactionEx("ipfilter", 9003)
				utils.xmlappenderror(9003)
				return
		end

		if '0' == v["LanIPFilterProtocol"] then
				TmpProtocol = "TCP/UDP"
				Tmpwsport=v["LanIPFilterWanStartPort"] 
				Tmpweport=v["LanIPFilterWanEndPort"]
				Tmplsport=v["LanIPFilterLanStartPort"]
				Tmpleport=v["LanIPFilterLanEndPort"]
		elseif '1' == v["LanIPFilterProtocol"] then
				TmpProtocol = "ICMP"
		elseif '6' == v["LanIPFilterProtocol"] then
				TmpProtocol = "TCP"
				Tmpwsport=v["LanIPFilterWanStartPort"] 
				Tmpweport=v["LanIPFilterWanEndPort"]
				Tmplsport=v["LanIPFilterLanStartPort"]
				Tmpleport=v["LanIPFilterLanEndPort"]
		elseif '17' == v["LanIPFilterProtocol"] then
				TmpProtocol = "UDP"
				Tmpwsport=v["LanIPFilterWanStartPort"] 
				Tmpweport=v["LanIPFilterWanEndPort"]
				Tmplsport=v["LanIPFilterLanStartPort"]
				Tmpleport=v["LanIPFilterLanEndPort"]
	   else
				print("LanIPFilterProtocol is error")
				dm.EndTransactionEx("ipfilter", 9003)
				utils.xmlappenderror(9003)	
				return
		end  
		
		flag = flag + 1
		local newObj = {
					{"Name", flag}, 
					{"Status", TmpStatus},

					{"Priority", flag}, 
					{"Interface", "br+"},
					{"SourceIPStart", Tmplsip},
					{"SourceIPEnd", Tmpldip},
					{"DestIPStart", Tmpwsip},
					{"DestIPEnd", Tmpwdip},
					{"Protocol", TmpProtocol},                          
					{"SourcePortStart", Tmplsport},
					{"SourcePortEnd", Tmpleport},
					{"DestPortStart", Tmpwsport},
					{"DestPortEnd", Tmpweport},
					{"IPVersion", Tmpipversion},
					{"SrcIPandMask", Tmpsrcipmask},
					{"DstIPandMask", Tmpdstipmask},
					{"IPFltFlag", Tmpipfltflag},
			}                                                                     
		local errcode, instnum, NeedReboot, paramerr= dm.AddObjectWithValues("InternetGatewayDevice.X_FireWall.IpFilter.", newObj)
		if 0 ~= errcode then
			dm.EndTransactionEx("ipfilter", errcode)
			utils.xmlappenderror(errcode)
			return
		end
	end
	dm.EndTransactionEx("ipfilter", 2)
end
setmode()
