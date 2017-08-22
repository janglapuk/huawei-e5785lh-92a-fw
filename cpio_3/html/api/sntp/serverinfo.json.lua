require('dm')
require('json')
require('utils')
require('sys')

--sntp module Switch Data nodes  "InternetGatewayDevice.Time.X_TimeServerDisplay_Enabled"
--------------------check the status of sntp module switch--------------------
local errcode,SwitchValues= dm.GetParameterValues("InternetGatewayDevice.Time.",
        {"X_TimeServerDisplay_Enabled"})

if utils.toboolean(SwitchValues["InternetGatewayDevice.Time."]["X_TimeServerDisplay_Enabled"]) then
--print("sntp module Switch is on")
else
--print("sntp module Switch is off")
	local response = {}
	response.code = 100002
	response.message = ""
	sys.print(json.xmlencode(response,"error"))
	return	false
end

local servername = {}
local server_list = {}
local allsntpserver = {}
allsntpserver[0] = 'clock.fmt.he.net'
allsntpserver[1] = 'clock.nyc.he.net'
allsntpserver[2] = 'clock.sjc.he.net'
allsntpserver[3] = 'clock.via.net'
allsntpserver[4] = 'ntp1.tummy.com'
allsntpserver[5] = 'ntp1.inrim.it'
allsntpserver[6] = 'ntp2.inrim.it'
allsntpserver[7] = 'time.cachenetworks.com'
allsntpserver[8] = 'time.nist.gov'
allsntpserver[9] = 'ntp.nasa.gov'
allsntpserver[10] = 'time-nw.nist.gov'

	for id=0, 10 do
		local server = {}
		server.id = id
		server.name = allsntpserver[id]
		print("server.name =",server.name)
		
		table.insert(server_list, server)
	end


local response = {}
response.servers = server_list
sys.print(json.xmlencode(response))
