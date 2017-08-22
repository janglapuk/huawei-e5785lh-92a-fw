local string = string
local table = table
local strlen, find, strsub, sort, insert, GetParameterValues = string.len, string.find, string.sub, table.sort, table.insert, dm.GetParameterValues
module(..., package.seeall)
_G["g_errMap"] = nil
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
function appenderror(errorcode)
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

