local xml = require('xml')
local _G = _G
local string = string

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
--print("do post")

function decode(s)
  -- Handle nil values
  if nil == s or '' == s then
    return nil
  end
  return xml.decode(s)
end

function getRequest()
    local request = decode(_G["FormData"]["JSONDATA"])
    return request
end

function getRequestData()
    local request = getRequest()    
    if nil ~= request["config"] then	        
        return request["config"]
    end
end
data = getRequestData()
--printTab(data)
