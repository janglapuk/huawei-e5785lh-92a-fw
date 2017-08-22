
local web       = require("web")
local json      = require("json")
local utils     = require('utils')

local errcode,values= dm.GetParameterValues("X_Config.global.",{"voipenable"})
obj = values["X_Config.global."];

print("voipenable "..obj["voipenable"])

if obj["voipenable"] == 0 then
    utils.xmlappenderror("100003")
	return
end

--local name,level = web.getuserinfo()
local response = {}

local buttondata = {}
local errcode,buttonlist = dm.GetParameterValues("InternetGatewayDevice.Services.VoiceService.1.X_CommonConfig.Button.{i}.",{"QuickDialNumber","Destination","Description"});
local index = 0
if buttonlist then
	for k,v in pairs(buttonlist) do
		local buttonitem = {}
		buttonitem["ID"] = k
        index = index + 1
        buttonitem["index"] = index
		if v["QuickDialNumber"]~= "" then
			buttonitem["quicknumber"] = v["QuickDialNumber"] 
		else
			buttonitem["quicknumber"] = ""
		end
		buttonitem["destination"] = v["Destination"]
		buttonitem["description"] = v["Description"]
		table.insert(buttondata,buttonitem)
	end
	utils.multiObjSortByID(buttondata)
end
response.speeddial = buttondata
sys.print(json.xmlencodex(response))
  
