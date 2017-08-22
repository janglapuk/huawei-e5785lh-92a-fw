require('dm')
require('web')
require('json')
require('utils')
require('table')

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

local errcode,policerVals = dm.GetParameterValues("InternetGatewayDevice.QueueManagement.Policer.{i}.", 
    {"MeterType", "CommittedRate", "PeakRate"

	, "X_DownCommittedRate", "X_DownPeakRate"

	});

local array = {}
i = 1
local pos = nil
local predomain = nil
local lastdomain = nil
for k,v in pairs(policerVals) do
    pos,  predomain, lastdomain = findLastPoint(k)
    array[i] = tonumber(pos)
    i = i+1
end
table.sort(array)

local errcode, objs = dm.GetParameterValues("InternetGatewayDevice.QueueManagement.Classification.{i}.",
    {   "ClassificationEnable",
    	"ClassificationName",
        "X_Type",
        "ClassQueue",
		"ClassPolicer",
        "DSCPMark",
        "SourceIP",
		"SourceMask",
        "SourceIPEnd",
        "SourceMACAddress",
        "ClassInterface",
        "Protocol",
        "SourcePort",
        "SourcePortRangeMax",
        "DestPort",
		"DestPortRangeMax"
    }
);

function apendPolicerData(newObj, policerIndex)
    if array[policerIndex] == nil then
        return
    end
	
    local policerdomain = "InternetGatewayDevice.QueueManagement.Policer."..array[policerIndex].."."
    local errcode, Policerobjs = dm.GetParameterValues("InternetGatewayDevice.QueueManagement.Policer.{i}.",
    {   "PolicerEnable",
    	"MeterType",
        "CommittedRate",
        "PeakRate",
		"X_DownCommittedRate",
        "X_DownPeakRate"
    });
    if Policerobjs ~= nil then
        for k,v in pairs(Policerobjs) do
            if  k == policerdomain then		
			    newObj["metertype"] = v["MeterType"]
			    newObj["upcommittedrate"] = v["CommittedRate"]
				newObj["uppeakrate"] = v["PeakRate"]
				newObj["downcommittedrate"] = v["X_DownCommittedRate"]
				newObj["downpeakrate"] = v["X_DownPeakRate"]
				return
			end
        end	
	end
	
end


local response = {}	
local qoslists = {}
local flag = 0
if objs ~= nil then
    for k,v in pairs(objs) do
        if "GuestNwork2G" ~= v["ClassificationName"] and "GuestNwork5G" ~= v["ClassificationName"]then
	local newObj = {}
        newObj["id"] = flag
        newObj["enable"] = v["ClassificationEnable"]
        newObj["name"] = v["ClassificationName"]
        newObj["type"] = v["X_Type"]
		newObj["dscpmark"] = v["DSCPMark"]
		newObj["classqueue"] = v["ClassQueue"]
		
		newObj["sourceip"] = ""
		newObj["sourceipend"] = ""
		newObj["sourcemacaddress"] = ""
		newObj["laninterface"] = ""
		newObj["protocol"] = -1
		newObj["sourceport"] = -1
		newObj["sourceportend"] = -1
		newObj["destport"] = -1
		newObj["destportend"] = -1
		if 1 == v["X_Type"] then --基于IP
		    newObj["sourceip"] = v["SourceIP"]
			if '' ~= v["SourceMask"] then
			    newObj["sourcemask"] = v["SourceMask"]
				newObj["isipv4"] = 0
			else
			    newObj["isipv4"] = 1
			    newObj["sourceipend"] = v["SourceIPEnd"]
			end
		elseif 2 == v["X_Type"] then --基于mac
		    newObj["sourcemacaddress"] = v["SourceMACAddress"]
		elseif 3 == v["X_Type"] then --基于物理端口
		    newObj["laninterface"] = v["ClassInterface"]
		elseif 4 == v["X_Type"] then --基于应用
			if 6 == v["Protocol"] then
		        newObj["protocol"] = "TCP"
		    elseif 17 == v["Protocol"] then
		        newObj["protocol"] = "UDP"
		    elseif 0 == v["Protocol"] then
		        newObj["protocol"] = "TCP/UDP"
		    end
			newObj["sourceport"] = v["SourcePort"]
			newObj["sourceportend"] = v["SourcePortRangeMax"]
			newObj["destport"] = v["DestPort"]
			newObj["destportend"] = v["DestPortRangeMax"]
		end
		
	    apendPolicerData(newObj,v["ClassPolicer"])
        table.insert(qoslists, newObj)
		flag = flag + 1
		end
	end
end	

response.qoslists = qoslists
print(json.xmlencode(response))
sys.print(json.xmlencode(response))