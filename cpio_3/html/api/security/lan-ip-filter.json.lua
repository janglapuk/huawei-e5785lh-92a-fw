require('dm')
require('web')
require('json')
require('utils')
require('table')


local errcode, objs = dm.GetParameterValues("InternetGatewayDevice.X_FireWall.IpFilter.{i}.",
    {   "Name",
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


local response = {}
local IPFilters = {}
if objs ~= nil then
    for k,v in pairs(objs) do
		if (0 == v["IPFltFlag"]) or (1 == v["IPFltFlag"]) then
			local TmpProtocol
			local Tmplsip
			local Tmpldip
			local Tmpwsip
			local Tmpwdip 
			local TmpIpversion=0
			
			local Tmpsrcprefix
			local Tmpdstprefix
			
			local Tmpstrlen	
			local Tmpspos
			local Tmpepos
			
			---------------------------------------------------------IPv4
			if 4 == v["IPVersion"] then
				TmpIpversion = 0

				if "1" == v["SrcIPandMask"] then
					Tmplsip = v["SourceIPStart"]
					if v["SourceIPStart"] == v["SourceIPEnd"] then
						Tmpldip = ""
					else
						Tmpldip = v["SourceIPEnd"]
					end
				else
					Tmpldip = ""
					if ".0" ==  string.sub(v["SourceIPStart"],-2) then
						if ".255.255.254" ==  string.sub(v["SourceIPEnd"],-12) then
							Tmplsip = string.format("%s%s", string.sub(v["SourceIPStart"], 1, -6), "*.*.*") 
						elseif ".255.254" ==  string.sub(v["SourceIPEnd"],-8) then
							Tmplsip = string.format("%s%s", string.sub(v["SourceIPStart"], 1, -4), "*.*")
						elseif ".254" ==  string.sub(v["SourceIPEnd"],-4) then
							Tmplsip = string.format("%s%s", string.sub(v["SourceIPStart"], 1, -2), "*")
						else
							Tmplsip = v["SourceIPStart"]         
						end
					else
						Tmplsip = v["SourceIPStart"]
					end
				end
				if "1" == v["Tmpdstipmask"] then
					Tmpwsip = v["DestIPStart"]
					if v["DestIPStart"] == v["DestIPEnd"] then
						Tmpwdip = ""
					else
						Tmpwdip = v["DestIPEnd"]
					end
				else
					Tmpwdip = ""
					if ".0" ==  string.sub(v["DestIPStart"],-2) then
						if "0.0.0.0" == v["DestIPStart"] then
							Tmpwsip = "*.*.*.*"
						elseif ".255.255.254" ==  string.sub(v["DestIPEnd"],-12) then
							Tmpwsip = string.format("%s%s", string.sub(v["DestIPStart"], 1, -6), "*.*.*") 
						elseif ".255.254" ==  string.sub(v["DestIPEnd"],-8) then
							Tmpwsip = string.format("%s%s", string.sub(v["DestIPStart"], 1, -4), "*.*")
						elseif ".254" ==  string.sub(v["DestIPEnd"],-4) then
							Tmpwsip = string.format("%s%s", string.sub(v["DestIPStart"], 1, -2), "*")
						else
							Tmpwsip = v["DestIPStart"]            
						end
					else
						Tmpwsip = v["DestIPStart"]
					end
				end

			---------------------------------------------------------IPv6
			elseif 6 == v["IPVersion"] then
				TmpIpversion = 1
				Tmpstrlen = string.len(v["SrcIPandMask"])			
				Tmpspos,Tmpepos = string.find(v["SrcIPandMask"],'/')			
				Tmplsip = string.sub(v["SrcIPandMask"],1,Tmpspos-1)			
				Tmpsrcprefix = string.sub(v["SrcIPandMask"],Tmpspos+1)	

				Tmpstrlen = string.len(v["DstIPandMask"])			
				Tmpspos,Tmpepos = string.find(v["DstIPandMask"],'/')			
				Tmpwsip = string.sub(v["DstIPandMask"],1,Tmpspos-1)			
				Tmpdstprefix = string.sub(v["DstIPandMask"],Tmpspos+1)
			end
			----------------------------------------------------------------²»Çø·Öv4v6
			if "TCP/UDP" == v["Protocol"] then
				TmpProtocol = 0
			elseif "ICMP" == v["Protocol"] then
				TmpProtocol = 1
			elseif "TCP" == v["Protocol"] then
				TmpProtocol = 6
			elseif "UDP" == v["Protocol"] then               
				TmpProtocol = 17
			end
	  
			local newObj                 = {} 
			
			newObj["LanIPFilterProtocol"] = TmpProtocol
			newObj["LanIPFilterStatus"] = v["IPFltFlag"] 
			newObj["LanIPFilterLanStartAddress"] = Tmplsip
			if "" ~= Tmpldip then
				newObj["LanIPFilterLanEndAddress"] = Tmpldip
			end
			newObj["LanIPFilterLanStartPort"] = v["SourcePortStart"]
			newObj["LanIPFilterLanEndPort"] = v["SourcePortEnd"]
			newObj["LanIPFilterWanStartAddress"] = Tmpwsip
			if "" ~= Tmpwdip then
				newObj["LanIPFilterWanEndAddress"] = v["DestIPEnd"]
			end
			newObj["LanIPFilterWanStartPort"] = v["DestPortStart"]
			newObj["LanIPFilterWanEndPort"] = v["DestPortEnd"]
			newObj["LanIPFilterSrcStartIPMask"] = 0
			newObj["LanIPFilterDestStartIPMask"] = 0
			newObj["LanIPFilterPolicy"] = 1
			newObj["LanIPFilterFlag"] = TmpIpversion
			if 1 == TmpIpversion then
				newObj["LanIPFilterSrcPreFix"] = Tmpsrcprefix
				newObj["LanIPFilterDestPreFix"] = Tmpdstprefix
			end
			newObj.ID = v["Priority"]	
			table.insert(IPFilters, newObj)
		end
	end
end

utils.multiObjSortByID(IPFilters)
response.IPFilters = IPFilters
--print(json.xmlencode(response))
sys.print(json.xmlencode(response))