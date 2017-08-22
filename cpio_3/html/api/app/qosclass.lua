local utils = require('utils')
require('dm')

if data == nil then
	return
end


function getqosdomain()
    local errcode, objs = dm.GetParameterValues("InternetGatewayDevice.QueueManagement.Classification.{i}.",
    {"ClassificationName"});
    if objs ~= nil then
        for k,v in pairs(objs) do
            if  "GuestNwork2G" ~= v["ClassificationName"] and "GuestNwork5G" ~= v["ClassificationName"] then
            	if nil ~= data["name"] then
					if v["ClassificationName"] == data["name"] then
						return k
	                end
	            end
            end
	    end
    end
end

function getpolicyid(array)
    local errcode,policerVals = dm.GetParameterValues("InternetGatewayDevice.QueueManagement.Policer.{i}.", 
    {"MeterType", "CommittedRate", "PeakRate"
	, "X_DownCommittedRate", "X_DownPeakRate"
	});
    
    i = 1
    local pos = nil
    local predomain = nil
    local lastdomain = nil
    if policerVals ~= nil then
	    for k,v in pairs(policerVals) do
	        pos,  predomain, lastdomain = findLastPoint(k)
	        array[i] = tonumber(pos)
	        i = i+1
	    end
    end
    table.sort(array)
end

function delete_class()
        local err
        local array = {}
        local qosconf
        local qoserrcode
        getpolicyid(array)
        --删除当前class对应的流控id
        local qosclasspolicerdomain 
	local qosdomain = getqosdomain()
	if nil ~= qosdomain then
                qoserrcode,qos = dm.GetParameterValues(qosdomain , {"ClassPolicer"});
                qosconf = qos[qosdomain]
		
		--删除当前class
		err = dm.DeleteObject(qosdomain)
	end

	
	if qoserrcode == 0 and array[qosconf["ClassPolicer"]] ~= nil then
	    qosclasspolicerdomain = "InternetGatewayDevice.QueueManagement.Policer."..array[qosconf["ClassPolicer"]]
	    if qosclasspolicerdomain ~= nil then
	    	err = dm.DeleteObject(qosclasspolicerdomain)
	    end

	end

	return err
end

function findLastPoint(domain)
	local start = 1
	local pos = nil
	local predomain = nil
	local lastdomain = nil

	while true do
		ip,fp = string.find(domain, "%.", start)
		if not ip then break end
		predomain = string.sub(domain, start, ip-1)
		pos = ip
		start = fp + 1
	end
	
	if pos ~= nil then
		lastdomain = string.sub(domain, pos + 1)
	end

	return predomain, lastdomain, pos
end

function calc_index(instanceId)
	local errcode,policerVals = dm.GetParameterValues("InternetGatewayDevice.QueueManagement.Policer.{i}.", 
		{"MeterType"});
	local array = {}
	local pos = nil
	local predomain = nil
	local lastdomain = nil
	
	i = 1
	if policerVals ~= nil then
		for k,v in pairs(policerVals) do
			pos,  predomain, lastdomain = findLastPoint(k)
			array[i] = tonumber(pos)
	    	i = i+1
		end
	end
	table.sort(array)
	for j=1, i-1 do
		if array[j] == instanceId then
			return j
		end
	end
	return -1
end


function get_policer_num()
    local errcode,policer = dm.GetParameterValues("InternetGatewayDevice.QueueManagement.Policer.{i}.", {"MeterType"})
    local num = 0
    if policer ~= nil then 
        for k,v in pairs(policer) do
            num = num + 1 
        end
    end
    return num
end

--创建流控对象
function create_Policer()
    local newObj = {
	    {"PolicerEnable", 1}, --使能
		{"MeterType","TwoRateThreeColor"}, --策略类型
        {"CommittedRate", data["upcommittedrate"]}, --上行最小
        {"PeakRate",  data["uppeakrate"]},--上行最大
        {"X_DownCommittedRate", data["downcommittedrate"]}, --下行最小
        {"X_DownPeakRate", data["downpeakrate"]} --下行最大                         
    }
	dm.CreatQosPolicerEx("begin")
	local policerindex
	local errcode, instnum, NeedReboot, paramerr = dm.AddObjectWithValues("InternetGatewayDevice.QueueManagement.Policer.", newObj)
	policerindex = calc_index(instnum)
	dm.CreatQosPolicerEx("end")
	return policerindex
end


--更新流控对象
function update_Policer(instanceId)
    print("update_Policer")
    if nil == instanceId then
    	return
    end
	local parasqos = {}	
    --utils.add_one_parameter(parasqos, "InternetGatewayDevice.QueueManagement.Policer."..instanceId.."PolicerEnable", 1)
	utils.add_one_parameter(parasqos, "InternetGatewayDevice.QueueManagement.Policer."..instanceId.."MeterType", data["metertype"])        
    utils.add_one_parameter(parasqos, "InternetGatewayDevice.QueueManagement.Policer."..instanceId..".CommittedRate", data["upcommittedrate"])      
    utils.add_one_parameter(parasqos, "InternetGatewayDevice.QueueManagement.Policer."..instanceId..".PeakRate", data["uppeakrate"])      
	utils.add_one_parameter(parasqos, "InternetGatewayDevice.QueueManagement.Policer."..instanceId..".X_DownCommittedRate", data["downcommittedrate"])      
    utils.add_one_parameter(parasqos, "InternetGatewayDevice.QueueManagement.Policer."..instanceId..".X_DownPeakRate", data["downpeakrate"])  
    local errcode, NeedReboot, paramerr = dm.SetParameterValues(parasqos)
    print(errcode)
    if errcode ~= 0 then
        utils.xmlappenderror(errcode)
    end	
end



--基于IP
function create_class_ip(instanceId)
	local newObj
	if nil ~= data["isipv4"] then
	    if '1' == data["isipv4"] then
			newObj = {
		        {"ClassificationEnable", 1}, --使能
	            {"ClassificationName", data["name"]}, --业务名称
	            {"SourceIP", data["sourceip"]}, --源ip起始地址
	            {"SourceIPEnd",  data["sourceipend"]},--源ip终结地址
	            {"X_Type", data["type"]}, --流量管理模式
	            {"X_QosLinkType", 3}, --上下行
	            {"ClassQueue", data["classqueue"]}, --队列id 
	            {"ClassPolicer", instanceId}, --流量id 	
	            {"DSCPMark", data["dscpmark"]} --dscp打标	
			}
		else
			newObj = {
		        {"ClassificationEnable", 1}, --使能
	            {"ClassificationName", data["name"]}, --业务名称
	            {"SourceIP", data["sourceip"]}, --源ip起始地址
				{"SourceMask",  data["sourcemask"]},--掩码
	            {"X_Type", data["type"]}, --流量管理模式
		    {"X_QosLinkType", 3}, --上下行
	            {"ClassQueue", data["classqueue"]}, --队列id 
	            {"ClassPolicer", instanceId}, --流量id 	
	            {"DSCPMark", data["dscpmark"]} --dscp打标	
			}
		end
	end 
    
	local errcode, instnum, NeedReboot, paramerr= dm.AddObjectWithValues("InternetGatewayDevice.QueueManagement.Classification.", newObj)
	return errcode
end		

--基于mac
function create_class_mac(instanceId)
    local newObj = {
	    {"ClassificationEnable", 1}, --使能
        {"ClassificationName", data["name"]}, --业务名称
	    {"SourceMACAddress", data["sourcemacaddress"]},--源mac地址 
        {"X_Type", data["type"]}, --流量管理模式
        {"X_QosLinkType", 3}, --上下行
        {"ClassQueue", data["classqueue"]}, --队列id 
        {"ClassPolicer", instanceId}, --流量id 	
        {"DSCPMark", data["dscpmark"]} --dscp打标		
    }

	local errcode, instnum, NeedReboot, paramerr= dm.AddObjectWithValues("InternetGatewayDevice.QueueManagement.Classification.", newObj)
	return errcode
end		 


--基于端口
function create_class_port(instanceId)
    local newObj = {
	    {"ClassificationEnable", 1}, --使能
        {"ClassificationName", data["name"]}, --业务名称
	    {"ClassInterface", data["laninterface"]}, --laninterface
        {"X_Type", data["type"]}, --流量管理模式
        {"X_QosLinkType", 3}, --上下行
        {"ClassQueue", data["classqueue"]}, --队列id 
        {"ClassPolicer", instanceId}, --流量id 	
        {"DSCPMark", data["dscpmark"]} --dscp打标		
    }
	local errcode, instnum, NeedReboot, paramerr= dm.AddObjectWithValues("InternetGatewayDevice.QueueManagement.Classification.", newObj)
	return errcode
end	


--基于应用
function create_class_app(instanceId)
	local TmpProtocol
    if nil ~= data["protocol"] then
		if "TCP" == data["protocol"] then
		    TmpProtocol = 6
		elseif "UDP" == data["protocol"] then
		    TmpProtocol = 17
		elseif "TCP/UDP" == data["protocol"] then
		    TmpProtocol = 0
		end
	end

    local newObj = {
	    {"ClassificationEnable", 1}, --使能
        {"ClassificationName", data["name"]}, --业务名称	  
	    {"APPName", data["name"]}, --app名称		
            {"Protocol", TmpProtocol}, --协议类型
            {"X_QosLinkType", 3}, --上下行
	    {"SourcePort", data["sourceport"]}, --源端口起始
	    {"SourcePortRangeMax", data["sourceportend"]}, --源端口终结
	    {"DestPort", data["destport"]}, --目的端口起始
	    {"DestPortRangeMax ", data["destportend"]}, --目的端口终结
        {"X_Type", data["type"]}, --流量管理模式
        {"ClassQueue", data["classqueue"]}, --队列id 
        {"ClassPolicer", instanceId}, --流量id 	
        {"DSCPMark", data["dscpmark"]} --dscp打标
    }
	local errcode, instnum, NeedReboot, paramerr= dm.AddObjectWithValues("InternetGatewayDevice.QueueManagement.Classification.", newObj)

	return errcode
end	


function create_class()
    local err
	local qosclasspolicerdomain
        local policernum = get_policer_num()
        if policernum >= 16 then
            return 9003
        end
    local policeid = create_Policer()
    if nil ~= data["type"] then
		if '1' == data["type"] then  --基于IP
		    err = create_class_ip(policeid)
		elseif '2' == data["type"] then --基于mac
		    err = create_class_mac(policeid)
		elseif '3' == data["type"] then --基于物理端口
		    err = create_class_port(policeid)
		elseif '4' == data["type"] then --基于应用
		    err = create_class_app(policeid)
		end
	end
	if 0 ~= err and nil ~= policeid then 
	    qosclasspolicerdomain = "InternetGatewayDevice.QueueManagement.Policer."..policeid
	    if nil ~= qosclasspolicerdomain then
	    	dm.DeleteObject(qosclasspolicerdomain)
	    end
	end
	return err
end


function update_class_type(instanceId,qosdomain)
	if nil == qosdomain or "" == qosdomain then
		return
	end

    local parasqos = {}
    dm.CreatQosPolicerEx("begin")   
    update_Policer(instanceId)
    dm.CreatQosPolicerEx("end")
    utils.add_one_parameter(parasqos, qosdomain..".ClassificationEnable", data["enable"])
	utils.add_one_parameter(parasqos, qosdomain.."ClassificationName", data["name"])        
    utils.add_one_parameter(parasqos, qosdomain.."X_Type", data["type"])      
    utils.add_one_parameter(parasqos, qosdomain.."ClassQueue", data["classqueue"])      
	utils.add_one_parameter(parasqos, qosdomain.."DSCPMark", data["dscpmark"])  
    --基于ip    
    utils.add_one_parameter(parasqos, qosdomain.."SourceIP","") 
    utils.add_one_parameter(parasqos, qosdomain.."SourceIPEnd","") 
	utils.add_one_parameter(parasqos, qosdomain.."SourceMask","") 
	
    --基于mac
    utils.add_one_parameter(parasqos, qosdomain.."SourceMACAddress","") 

	--基于物理端口   
    utils.add_one_parameter(parasqos, qosdomain.."ClassInterface","") 

    --基于应用
    utils.add_one_parameter(parasqos, qosdomain.."Protocol",-1) 
    utils.add_one_parameter(parasqos, qosdomain.."SourcePort",-1) 
    utils.add_one_parameter(parasqos, qosdomain.."SourcePortRangeMax",-1) 
    utils.add_one_parameter(parasqos, qosdomain.."DestPort",-1)     
	utils.add_one_parameter(parasqos, qosdomain.."DestPortRangeMax",-1)

    if nil ~= data["type"] then
		if '1' == data["type"] then  --基于IP
			if nil ~= data["isipv4"] then
				if '1' == data["isipv4"] then
				    utils.add_one_parameter(parasqos, qosdomain.."SourceIP",data["sourceip"]) 
		            utils.add_one_parameter(parasqos, qosdomain.."SourceIPEnd", data["sourceipend"])  
				else
				    utils.add_one_parameter(parasqos, qosdomain.."SourceIP",data["sourceip"]) 
				    utils.add_one_parameter(parasqos, qosdomain.."SourceMask", data["sourcemask"])  
				end
			end
		elseif '2' == data["type"] then --基于mac
		    utils.add_one_parameter(parasqos, qosdomain.."SourceMACAddress",data["sourcemacaddress"]) 
		elseif '3' == data["type"] then --基于物理端口
		    utils.add_one_parameter(parasqos, qosdomain.."ClassInterface",data["laninterface"]) 
		elseif '4' == data["type"] then --基于应用
			local TmpProtocol
			if nil ~= data["protocol"] then
				if "TCP" == data["protocol"] then
				    TmpProtocol = 6
				elseif "UDP" == data["protocol"] then
				    TmpProtocol = 17
				elseif "TCP/UDP" == data["protocol"] then
				    TmpProtocol = 0
				end
			end

			utils.add_one_parameter(parasqos, qosdomain.."APPName",data["name"]) 
		    utils.add_one_parameter(parasqos, qosdomain.."Protocol",TmpProtocol) 
	        utils.add_one_parameter(parasqos, qosdomain.."SourcePort",data["sourceport"]) 
	        utils.add_one_parameter(parasqos, qosdomain.."SourcePortRangeMax",data["sourceportend"]) 
	        utils.add_one_parameter(parasqos, qosdomain.."DestPort",data["destport"])     
		    utils.add_one_parameter(parasqos, qosdomain.."DestPortRangeMax",data["destportend"])   	
		end
	end
	
    local errcode, NeedReboot, paramerr = dm.SetParameterValues(parasqos)
	print(errcode)
	return errcode
end


function update_class()
    local err
	local qosdomain 
	local qosconf
	local array = {}
    qosdomain = getqosdomain()

    if nil == qosdomain then
    	return
    end
    
	print(qosdomain)
    local qoserrcode,qos = dm.GetParameterValues(qosdomain , {"ClassPolicer"});
	if qoserrcode ~= 0 then
	    err = qoserrcode
        return  err
	end
	qosconf = qos[qosdomain]
	getpolicyid(array)
	err = update_class_type(array[qosconf["ClassPolicer"]],qosdomain)
	return err
end

function post_qosclass()
    local err
    if '' == data["id"] then
	    err = create_class()
    elseif nil ~= data["id"] then
	    if nil ~= data["type"] then
		    err = update_class()
		else
		    err = delete_class()
		end
    end
	return err
end

local err
err = post_qosclass()
if err ~= 0 then
    utils.xmlappenderror(err)
end	

