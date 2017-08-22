require('utils')

local objdomin = "InternetGatewayDevice.ManagementServer."
local maps = {
    enablecwmp="EnableCWMP",
    url = "URL",
    username = "Username",
    password = "Password",
    periodicinformenable = "PeriodicInformEnable",
    periodicinforminterval = "PeriodicInformInterval",
    connectionrequestusername = "ConnectionRequestUsername",
    connectionrequestpassword = "ConnectionRequestPassword",	
	xsslcertenable = "X_SSLCertEnable",
	xconnreqport = "X_ConnReqPort",
	authmode = "X_ConnReqMode",
	
}

local objdisplay = "InternetGatewayDevice.Services.X_CWMPDISPLAY."
if nil ~= data then
        local errcode, paramErrs = dm.SetObjToDB(objdisplay,{{"Cwmp_Display", data["cwmp_display"]}})
        print('set cwmp switch errorcode = ', errcode, data["cwmp_display"])
end

function SetObjParamInputs(domain, data, maps)
    local inputs = {}
    for k, v in pairs(maps) do
        local param = {}
		if nil ~= data and nil ~= data[k] then
			param["key"] = v      
			param["value"] = data[k]
			table.insert(inputs, param)
		end
    end
    return inputs
end

local param = SetObjParamInputs(objdomin, data, maps)
local errcode, paramErrs = dm.SetObjToDB(objdomin,param)
if errcode ~= 0 then
   print("cwmp set errcode = ", errcode)
end

local multiwandomin = "InternetGatewayDevice.X_Config.dialup.multiwan.2."
local multiwanmaps = {
    roam_connect="roam_connect",
    use_internet_profile = "enable",	
}
local param = SetObjParamInputs(multiwandomin, data, multiwanmaps)
local errcode, paramErrs = dm.SetObjToDB(multiwandomin,param)
if errcode ~= 0 then
   print("cwmp set multiwan errcode = ", errcode)
end


local umtsWandomin = ""
function getUmtswan()
	for i = 1, 5 do
		local errcode, accessdevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice."..i..".WANCommonInterfaceConfig.", {"WANAccessType"})
		if nil ~= accessdevs then
			for k, v in pairs(accessdevs) do
				if "UMTS" == v["WANAccessType"] then
					umtsWandomin = k
					local start = string.find(umtsWandomin, ".WANCommonInterfaceConfig.")
				    if start then
						umtsWandomin = string.sub(umtsWandomin, 0, start)
					end
					umtsWandomin = umtsWandomin.."WANConnectionDevice."
					return 
				end
			end

		end
	end
end

local ethWandomin = ""
function getethswan()
    for i = 1, 5 do
        local errcode, accessdevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice."..i..".WANCommonInterfaceConfig.", {"WANAccessType"})
        if nil ~= accessdevs then
            for k, v in pairs(accessdevs) do
                if "Ethernet" == v["WANAccessType"] then
                    ethWandomin = k
                        local start = string.find(ethWandomin, ".WANCommonInterfaceConfig.")
                        if start then
                            ethWandomin = string.sub(ethWandomin, 0, start)
                        end
                        ethWandomin = ethWandomin.."WANConnectionDevice."
                        return 
                end
            end

        end
    end
end


function addtr069tointernetservicelist()
	local internetwan = umtsWandomin.."1.WANPPPConnection.1."
	local errcode, servicelist = dm.GetParameterValues(internetwan, {"X_ServiceList"})
    if nil ~= servicelist then
    	local internetservicelist = servicelist[internetwan]["X_ServiceList"]
        local servicepath = string.find(internetservicelist, "TR069")
        if(servicepath) then
            print("already have TR069 return "..internetwan)
            return
        end
    	local addservicelist = internetservicelist.."_TR069"
    	local specialparam = {{"X_ServiceList", addservicelist}}
    	local errcode, paramErrs = dm.SetObjToDB(internetwan, specialparam)
    	if (0 ~= errcode) then
    		print("errcode = "..errcode)
    	end
    end
end

function deltr069frominternetservicelist()
	local internetwan = umtsWandomin.."1.WANPPPConnection.1."
	local errcode, servicelist = dm.GetParameterValues(internetwan, {"X_ServiceList"})
	if nil ~= servicelist then
    	local internetservicelist = servicelist[internetwan]["X_ServiceList"]
        local servicepath = string.find(internetservicelist, "_TR069")
        if(servicepath) then
            print("need del internet TR069 ... "..internetwan)
            local delservicelist = string.gsub(internetservicelist, "_TR069", "")
            print("del TR069 from internet: to ",  delservicelist)
            local specialparam = {{"X_ServiceList", delservicelist}}
            local errcode, paramErrs = dm.SetObjToDB(internetwan, specialparam)
            if (0 ~= errcode) then
                print("delethtr069servicelist errcode = "..errcode)
            end
        end	
    end
end


function setethtr069servicelist(internetwan)
    local errcode, servicelist = dm.GetParameterValues(internetwan, {"X_ServiceList"})
    if nil ~= servicelist then
        local internetservicelist = servicelist[internetwan]["X_ServiceList"]
        local servicepath = string.find(internetservicelist, "TR069")
        if(servicepath) then
            print("already have TR069 return "..internetwan)
            return
        end
        local addservicelist = internetservicelist.."_TR069"
        local specialparam = {{"X_ServiceList", addservicelist}}
        local errcode, paramErrs = dm.SetObjToDB(internetwan, specialparam)
        if (0 ~= errcode) then
            print("errcode = "..errcode)
        end 
    end 
end

function addtr069toethinternetservicelist()
    if "" ~= ethWandomin then
        local internetwanppp = ethWandomin.."1.WANPPPConnection.1."
        local internetwanip = ethWandomin.."1.WANIPConnection.1."
        setethtr069servicelist(internetwanppp)
        setethtr069servicelist(internetwanip)
    end
end

function delethtr069servicelist(internetwan)
    local errcode, servicelist = dm.GetParameterValues(internetwan, {"X_ServiceList"})
    if nil ~= servicelist then
        local internetservicelist = servicelist[internetwan]["X_ServiceList"]
        local servicepath = string.find(internetservicelist, "_TR069")
        if(servicepath) then
            print("need del TR069 ... "..internetwan)
            local delservicelist = string.gsub(internetservicelist, "_TR069", "")
            print("delethtr069servicelist to ",  delservicelist)
            local specialparam = {{"X_ServiceList", delservicelist}}
            local errcode, paramErrs = dm.SetObjToDB(internetwan, specialparam)
            if (0 ~= errcode) then
                print("delethtr069servicelist errcode = "..errcode)
            end
        end
    end 
end

function deltr069fromethinternetservicelist()
    if "" ~= ethWandomin then
        local internetwanppp = ethWandomin.."1.WANPPPConnection.1."
        local internetwanip = ethWandomin.."1.WANIPConnection.1."
        delethtr069servicelist(internetwanppp)
        delethtr069servicelist(internetwanip)
    end
end

function setmultilwanenablestatus(status)
	local tr069wan = umtsWandomin.."3.WANPPPConnection.1."
	local specialparam = {{"Enable", status}}
	local errcode, paramErrs = dm.SetObjToDB(tr069wan, specialparam)
	if (0 ~= errcode) then
		print("errcode = "..errcode)
	end
end


function issuporttr069()
    return 0	
end

function setWANIPService(dailtype, isadd)
    local errcode,ipCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANIPConnection.{i}.", { "X_AutoFlag","Enable"})
    local ret = 0
    if nil ~= ipCon then
        for k,v in pairs(ipCon) do
            if nil ~= v["X_AutoFlag"] then
                if utils.toboolean(v["X_AutoFlag"]) and (1 == v["Enable"]) then
                    ret = utils.IfIpWanNeedAddService(dailtype, k, "TR069") 
                    if 1 == ret and 1 == isadd then
                        setethtr069servicelist(k)
                        print("set to ethservice ipCon to TR069 ok", k)
                    end
                    if 0 == ret and 0 == isadd then
                        delethtr069servicelist(k)
                        print("del TR069 from ethwan ipCon ok", k)
                    end
                end
            end
        end
    else
        print("can't find wanpath")
    end
end

function setWANPPPService(dailtype, isadd)
    local errcode,pppCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}.", { "X_AutoFlag","Enable"})
    local ret = 0
    if nil ~= pppCon then
        for k,v in pairs(pppCon) do
            if nil ~= v["X_AutoFlag"] then
                if utils.toboolean(v["X_AutoFlag"]) and (1 == v["Enable"]) then
                    ret = utils.IfPppWanNeedAddService(dailtype, k, "TR069")
                    if 1 == ret and 1 == isadd then
                        setethtr069servicelist(k)
                        print("set to ethservice TR069 pppCon ok", k)
                    end
                    if 0 == ret and 0 == isadd then
                        delethtr069servicelist(k)
                        print("del TR069 from ethwan pppCon ok", k)
                    end
                end
            end
        end
    else
        print("can't find wanpath")
    end
end

--1.刷新原来的tr069 wan的X_ServiceList(TR069->Custom)
--注意:目前写死的umts这条wan是tr069,如果未来默认配置xml中eth wan配置成tr069,整个lua需要重写
function SetCurrentTr069ToCustom()
    local tr069wan = umtsWandomin.."3.WANPPPConnection.1."
    local servicetype = {{"X_ServiceList", "Custom"}}
    local errcode, paramErrs = dm.SetObjToDB(tr069wan, servicetype)
    print("first set tr069 to custom")
    if (0 ~= errcode) then
        print("errcode = "..errcode)
    end

    --设置umts wan disable,不允许其拨号
    local tr069_enable = {{"Enable", 0}}
    local errcode, paramErrs = dm.SetObjToDB(tr069wan, tr069_enable)
    print("SetCurrentTr069ToCustom: first set tr069 to disable")
    if (0 ~= errcode) then
        print("SetCurrentTr069ToCustom:set umts wan to be disable errcode = "..errcode)
    end
end

function SetCurrentCustomToTr069()
    local internetwan = umtsWandomin.."3.WANPPPConnection.1."
    local errcode, servicelist = dm.GetParameterValues(internetwan, {"X_ServiceList"})
    if nil ~= servicelist then
        local internetservicelist = servicelist[internetwan]["X_ServiceList"]
        local servicepath = string.find(internetservicelist, "Custom")
        if(servicepath) then
            local tr069wan = umtsWandomin.."3.WANPPPConnection.1."
            local servicetype = {{"X_ServiceList", "TR069"}}
            local errcode, paramErrs = dm.SetObjToDB(tr069wan, servicetype)
            print("first set custom to TR069")
            if (0 ~= errcode) then
                print("errcode = "..errcode)
            end

            --设置umts wan disable,允许其拨号
            local tr069_enable = {{"Enable", 1}}
            local errcode, paramErrs = dm.SetObjToDB(tr069wan, tr069_enable)
            print("SetCurrentCustomToTr069: first set tr069 to enable")
            if (0 ~= errcode) then
                print("SetCurrentCustomToTr069:set umts wan to be enable errcode = "..errcode)
            end
        end
    end
end

--2.刷新所有eth wan的X_ServiceList,采取尾部添加_TR069的方式,原来已经包含TR069字段时无需处理
function SetEthInternetWanToTr069()
    setWANIPService("Ethernet",1)
    setWANPPPService("Ethernet",1)
end

function DelEthInternetWanTr069()
    setWANIPService("Ethernet",0)
    setWANPPPService("Ethernet",0)
end

--tr069业务使用以太上行总入口
function AddTr069ToEthInternetWanService()
    SetCurrentTr069ToCustom()
    SetEthInternetWanToTr069()
end

--设置profile显示
function SetProfileDisplay(status)
    local tr069profile = "InternetGatewayDevice.X_Config.profiledisplay."
	local specialparam = {{"tr069_display", status}}
	local errcode, paramErrs = dm.SetObjToDB(tr069profile, specialparam)
	if (0 ~= errcode) then
		print("errcode = "..errcode)
	end
end

--设置拨号cwmp use internet profile flag
function SetCwmpUseInternetProfileFlag(status)
    local dialuptr069useinternet = "InternetGatewayDevice.X_Config.dialup."
	local specialparam = {{"cwmp_useinternetprofile", status}}
	local errcode, paramErrs = dm.SetObjToDB(dialuptr069useinternet, specialparam)
	if (0 ~= errcode) then
		print("errcode = "..errcode)
	end
end

local internetflag = 0

if nil ~= data then
    getUmtswan()
    getethswan()
    local status = issuporttr069()
    print("cwmp config.lua: is cwmp wan servicelist include TR069:  "..status)
    if 1 == status then
        if nil ~= data["enablecwmp"] then
            if '0' == data["enablecwmp"] then
                setmultilwanenablestatus(0)
            elseif '1' == data["enablecwmp"] then                                                  
                setmultilwanenablestatus(1)									
            end
        end
		
        if nil ~= data["use_internet_profile"] then
            if '1' == data["use_internet_profile"] then
                addtr069toethinternetservicelist()
                addtr069tointernetservicelist()
                setmultilwanenablestatus(0)
                SetCurrentTr069ToCustom()
                internetflag = 1
                SetCwmpUseInternetProfileFlag(1)
            end
            if '0' == data["use_internet_profile"] then
                deltr069fromethinternetservicelist()
                deltr069frominternetservicelist()
                SetCurrentCustomToTr069()
                SetCwmpUseInternetProfileFlag(0)
            end
            if nil ~= data["enablecwmp"] then
                if '0' == data["enablecwmp"] then
                    deltr069frominternetservicelist()
                end
            end
        end
		--如果tr069业务使用以太上行,需要做两件事情:
		--1.刷新原来的tr069 wan的X_ServiceList(TR069->Custom)
		--2.刷新所有eth wan的X_ServiceList,采取尾部添加_TR069的方式,原来已经包含TR069字段时无需处理
		if nil ~= data["only_use_eth_internet_wan"] then
			if '1' == data["only_use_eth_internet_wan"] then
				AddTr069ToEthInternetWanService()
			end
			if '0' == data["only_use_eth_internet_wan"] then
			    if  0 == internetflag then
				SetCurrentCustomToTr069()
			    end
				DelEthInternetWanTr069()			
			end
		end
		
		print("cwmp config.lua: profile_display set ")
		--cwmp不使能也可以定制开启profile设置页面，由页面出发cwmp使能。
		if nil ~= data["profile_display"] then
			if '1' == data["profile_display"] then
				SetProfileDisplay(1)
			elseif '0' == data["profile_display"] then
				SetProfileDisplay(0)
			end
		end
	else
	-- not support TR069
	deltr069fromethinternetservicelist()
	deltr069frominternetservicelist()
	SetCwmpUseInternetProfileFlag(0)
	DelEthInternetWanTr069()
	end
end
