local sys  = require('sys')
local json = require('json')
local string = string
local table = table
local strlen, find, strsub, sort, insert, GetParameterValues = string.len, string.find, string.sub, table.sort, table.insert, dm.GetParameterValues
module(..., package.seeall)

_G["g_errMap"] = nil
_G["webtimes"] = 0

function decodestring(s)
    --print("s:"..s);
    --s = string.gsub(s,'\\\\','\\')
    --s = string.gsub(s,'"','\\"')
    --s = string.gsub(s,"'","\\'")
    s = string.gsub(s,'\\n','\n')
    s = string.gsub(s,'\\t','\t')
    s = string.gsub(s,'\\r','\r')
    s = string.gsub(s, "\&amp;", "\&")
    s = string.gsub(s, "\&lt;", "\<")
    s = string.gsub(s, "\&gt;", "\>")
    s = string.gsub(s, "\&quot;", "\"")
    s = string.gsub(s, "\&#x27;", "\'")
    s = string.gsub(s, "\&apos;", "\'")
    s = string.gsub(s, "\&#x2F;", "\/")
    return s
end    

function decodearray(data)
    if type(data) == 'table' then
        for k,s in pairs(data) do
            if type(s) == 'table' then
                decodearray(s)
            else
                decodestring(s)
            end
        end
    else
        decodestring(data)
    end
    return data
end
function xmlgetRequest()
    local request = json.xmldecode(_G["FormData"]["JSONDATA"])
    return request
end

function getRequestData()
    local request = xmlgetRequest()
    if nil ~= request["request"] then
        request["request"] = decodearray(request["request"])
        return request["request"]
    end
    if nil ~= request["config"] then
        request["config"] = decodearray(request["config"])
        return request["config"]
    end
    return nil
end

function getKeyByValue(v)
    if nil ~= _G["g_errMap"] then
        for km, vm in pairs(_G["g_errMap"]) do
            local tmpErr = ","..v..","
            local tmpVM = ","..vm..","
            if nil ~= string.find(tmpVM,tmpErr) then
                return km
            end
        end
    end
    return nil
end

function appenderrorEx(errorcode, message)
    _G["err"]["code"] = errorcode
    _G["err"]["message"] = message
end

function appendErrorItem(key, value)
    _G["err"][key] = value
end

function xmlappenderror(errorcode)
    --兼容两种errorcode
    if nil == errorcode then
        return
    end
    local errCode = getKeyByValue(errorcode)
    if nil ~= errCode then
        appenderrorEx(errCode, "")
    else
        appenderrorEx(errorcode, "")
    end
end

function  getErrkey(paramErr)
    for k, v in pairs(paramErr) do
        return getKeyByValue(v)
    end
end

function xmlresponseErrorcode(err, paramErr, maps)
    if paramErr == nil or 0 == err then
        return
    end
    local errKey = getErrkey(paramErr)
    if nil ~= errKey then
        xmlappenderror(errKey)
    end
end

function xmlresponserror()
    local xmlstr = json.xmlencode(_G["err"], "error")
    sys.print(xmlstr)
end

function count(ht)
    local n = 0;
    for k, v in pairs(ht) do
        if k ~= "message" and k ~= "code" then
            n = n + 1;
        end
    end
    return n;
end
function responseOK()
    local xmlstr = ""
    if 0 == count(_G["err"]) then
        xmlstr = json.xmlencode("OK", "response")
    else
        xmlstr = json.xmlencode(_G["err"], "response")
    end
    sys.print(xmlstr)
end

function response()
    if nil ~= _G["err"]["code"] and 0 ~= _G["err"]["code"] then
        xmlresponserror()
    else
        responseOK()
    end
end

function add_one_parameter(paras, name, value)
    if nil == value then
        return
    end
    table.insert(paras, {name, value})
end


function toboolean(val)
    if not val then
        return false
    end
    if "0" == val or 0 == val or "false" == val or false == val then
        return false
    end
    return true
end

function booleantoint(var)
    if false == var then
        return 0
    else
        return 1
    end
end

function split(str, sep)
    local start = 1
    local pre = nil
    local retval = {}

    if nil == str then
        return retval
    end

    while true do
        ip,fp = string.find(str, sep, start)
        if not ip then 
            if start < string.len(str) then
                table.insert(retval, string.sub(str, start))
            end
            break
        end

        if start < ip -1 then
            table.insert(retval, string.sub(str, start, ip-1))
        end
        start = fp + 1
    end

    return retval
end

function print_paras(parameters)
    if not parameters then
        return
    end
    for k,v in pairs(parameters) do
        print("=============================")
        if v then
            for idx,val in pairs(v) do
                print(val)
            end
        end
    end
end

function GenSetObjParamInputs(domain, data, maps)
    local inputs = {}
    for k, v in pairs(maps) do
        local param = {}
        param["key"] = domain..v
        param["value"] = data[k]
        table.insert(inputs, param)
    end

    return inputs
end

function getCradleAutoIPWan()
    local errcode,ipCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}.", {"X_AutoFlag"})
    for k,v in pairs(ipCon) do
        if toboolean(v["X_AutoFlag"]) then
            return k
        end
    end
end

function getCradleAutoPPPWan()
    local errcode,pppCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}.", {"X_AutoFlag"})
    for k,v in pairs(pppCon) do
        if toboolean(v["X_AutoFlag"]) then
            return k
        end
    end
end

function compID(a, b)
    local a_id_table = {}
    local b_id_table = {}
    for i in string.gmatch(a.ID, "%d+") do
        table.insert(a_id_table, tonumber(i))
    end
    for i in string.gmatch(b.ID, "%d+") do
        table.insert(b_id_table, tonumber(i))
    end

    local size = 0
    if table.getn(a_id_table) > table.getn(b_id_table) then
        size = table.getn(b_id_table)
    else
        size = table.getn(a_id_table)
    end

    if size < 1 then
        return false
    end

    for i=1,size do
        if a_id_table[i] > b_id_table[i] then
            return false
        elseif a_id_table[i] < b_id_table[i] then
            return true
        end
    end

    return false
end

function multiObjSortByID(objs)
    table.sort(objs, compID)
end

-- Get WAN device from WANConnectionDevice or WAN path
function get_wan_dev_of_wan(ID)
    local start = find(ID, ".WANConnectionDevice")
    local wandev = strsub(ID, 1, start)
    return wandev
end

-- Get access type of WAN or WAN conn dev
function get_access_type_by_wan(ID)
    local res = get_wan_dev_of_wan(ID)
    res = res.."WANCommonInterfaceConfig."
    local errcode,getValues= GetParameterValues(res, {"WANAccessType"})
    for k,v in pairs(getValues) do
        return v["WANAccessType"]
    end
    return ""
end

function IsPppInternetWanPath(accesstype, path)
    local devpath = ""
    local umtspath
    local err, wandevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANCommonInterfaceConfig.", {"WANAccessType"})
    for k,v in pairs(wandevs) do
        if accesstype == v["WANAccessType"] then
            umtspath = k
            local wanpath = string.find(umtspath, ".WANCommonInterfaceConfig.")
            if(wanpath) then
                devpath = string.sub(umtspath, 0, wanpath)
            end
        end
    end

    if "" == devpath then
        return 0
    end

    devpath = devpath.."WANConnectionDevice.{i}.WANPPPConnection.{i}."

    local errcode,pppCon = dm.GetParameterValues(devpath, {"X_ServiceList"})

    for k,v in pairs(pppCon) do
        local servicepath = string.find(v["X_ServiceList"], "INTERNET")
        if(servicepath) then
            if path == k then
                return 1
            end
        end
    end

    return 0
end

function IsIpInternetWanPath(accesstype, path)
    local devpath = ""
    local umtspath
    local err, wandevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANCommonInterfaceConfig.", {"WANAccessType"})

    for k,v in pairs(wandevs) do
        if accesstype == v["WANAccessType"] then
            umtspath = k
            local wanpath = string.find(umtspath, ".WANCommonInterfaceConfig.")
            if(wanpath) then
                devpath = string.sub(umtspath, 0, wanpath)
            end
        end
    end

    if "" == devpath then
        return 0
    end
    devpath = devpath.."WANConnectionDevice.{i}.WANIPConnection.{i}."

    local errcode,IPCon = dm.GetParameterValues(devpath, {"X_ServiceList"})

    for k,v in pairs(IPCon) do
        local servicepath = string.find(v["X_ServiceList"], "INTERNET")
        if(servicepath) then
            if path == k then
                return 1
            end
        end
    end

    return 0
end

function IfPppWanNeedAddService(accesstype, path, servicetype)
    local devpath = ""
    local umtspath
    local err, wandevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANCommonInterfaceConfig.", {"WANAccessType"})
    for k,v in pairs(wandevs) do
        if accesstype == v["WANAccessType"] then
            umtspath = k
            local wanpath = string.find(umtspath, ".WANCommonInterfaceConfig.")
            if(wanpath) then
                devpath = string.sub(umtspath, 0, wanpath)
            end
        end
    end

    if "" == devpath then
        return -1
    end

    devpath = devpath.."WANConnectionDevice.{i}.WANPPPConnection.{i}."

    local errcode,pppCon = dm.GetParameterValues(devpath, {"X_ServiceList"})

    for k,v in pairs(pppCon) do
        local servicepath = string.find(v["X_ServiceList"], "INTERNET")
        if(servicepath) then
            if path == k then
                local service = string.find(v["X_ServiceList"], servicetype)
                --如果已经包含servicetype则不需要添加
                if(service) then
                    return 0
                else
                    return 1
                end
            end
        end
    end

    return -1
end

function IfIpWanNeedAddService(accesstype, path, servicetype)
    local devpath = ""
    local umtspath
    local err, wandevs = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANCommonInterfaceConfig.", {"WANAccessType"})

    for k,v in pairs(wandevs) do
        if accesstype == v["WANAccessType"] then
            umtspath = k
            local wanpath = string.find(umtspath, ".WANCommonInterfaceConfig.")
            if(wanpath) then
                devpath = string.sub(umtspath, 0, wanpath)
            end
        end
    end

    if "" == devpath then
        return -1
    end
    devpath = devpath.."WANConnectionDevice.{i}.WANIPConnection.{i}."

    local errcode,IPCon = dm.GetParameterValues(devpath, {"X_ServiceList"})

    for k,v in pairs(IPCon) do
        local servicepath = string.find(v["X_ServiceList"], "INTERNET")
        if(servicepath) then
            if path == k then
                local service = string.find(v["X_ServiceList"], servicetype)
                --如果已经包含servicetype则不需要添加
                if(service) then
                    return 0
                else
                    return 1
                end
            end
        end
    end

    return -1
end

--get the "i" form xxx.{i}.
function getIndexFromKey(KeyVal)
local StartPoint = 0
local IndexNum
local KeyValLen
local count = -2
local temp

	if nil == KeyVal then 
	    print("KeyVal is nil")
		return false
	end
	KeyValLen = string.len(KeyVal)
	if KeyValLen == 0 or KeyValLen > 2000 then 
	    print("KeyValLen is 0 or bigger ; KeyValLen is "..KeyValLen)
		return false
	end
	--check KeyVal pattern ; pattern is xxx.{i}. 
    temp = string.sub(KeyVal,-1)
	if temp ~= "." then
	    print("KeyVal pattern error ; temp is "..temp)
		return false
	end
	
	for i=1,KeyValLen do
		temp = string.sub(KeyVal,count,count)
		if temp == "." then
			StartPoint = count + 1
			break
		end
		count = count -1
	end
	--no find the start "."
	if StartPoint == 0 then 
	    print("no find the start '.' ")
		return false
	end

	IndexNum = string.sub(KeyVal,StartPoint,-2)
	--print("IndexNum is "..IndexNum)

	--KeyVal pattern is xxx.{i}.
	if tonumber(IndexNum) == nil then
	    print(" i is not num; IndexNum is "..IndexNum)
		return false
	end

	return IndexNum
end

