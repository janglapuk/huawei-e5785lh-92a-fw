
local json = require('xml')
local _G = _G
local string = string


function getRequest()
    local request = json.decode(_G["FormData"]["JSONDATA"])
    return request
end

function getRequestData()
    local request = getRequest()
    if nil ~= request["request"] then
        return request["request"]
    end
    if nil ~= request["config"] then
        return request["config"]
    end
end

function printTab(tab)
	for i,v in pairs(tab) do
		if type(v) == "table" then
			print("table",i,"{")
			printTab(v)

			print("}")
		else
			print(i.."="..v)
		end
	end
end

data = getRequestData()
--printTab(data)
