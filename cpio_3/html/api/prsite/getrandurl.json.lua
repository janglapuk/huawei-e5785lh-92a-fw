require('dm')
require('utils')
require('sys')
require('web')

local response = {}
local randinfos = {}

local tab = web.geturlbyrandid()
for k,v in pairs(tab) do
    local newObj = {} 
    print("key:"..k)
	newObj.id = k
	print("val:"..v)
	newObj.url = v
	table.insert(randinfos, newObj)
end
response.randinfos = randinfos
sys.print(json.xmlencode(response))
