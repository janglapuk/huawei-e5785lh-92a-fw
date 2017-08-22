require('dm')
require('utils')
require('sys')

if data == nil then
	return
end


function createSubmitData(paras, k)
	if nil ~= k and nil ~= data["DmzStatus"] then
		utils.add_one_parameter(paras,  k.."X_DMZ.DMZEnable", data["DmzStatus"])
	end
	if nil ~= k and nil ~= data["DmzIPAddress"] then
		utils.add_one_parameter(paras,  k.."X_DMZ.DMZHostIPAddress", data["DmzIPAddress"])
	end
	return 0
end

function update(k)	
	local paras = {}
	local errcode = createSubmitData(paras, k)
	if errcode ~= 0 then
		return errcode
	end

    local errcode, NeedReboot, paramerr =  dm.SetParameterValues(paras)
    return errcode
end

function setWANIPdmz(dailtype)
    local errcode,ipCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANIPConnection.{i}.", { "X_AutoFlag","Enable"})
    local ret = 0
    if nil ~= ipCon then
        for k,v in pairs(ipCon) do
            if nil ~= v["X_AutoFlag"] then
                if utils.toboolean(v["X_AutoFlag"]) and (1 == v["Enable"]) then
                    ret = utils.IsIpInternetWanPath(dailtype, k) 
                    if 1 == ret then						    
                        local errcode = update(k)
                        print("dmz set to ipCon ok", k, errcode)
                        utils.xmlappenderror(errcode)
                    end
                end
            end
        end
    else
        print("can't find wanpath")
    end
end

function setWANPPPdmz(dailtype)	
    local errcode,pppCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}.", { "X_AutoFlag","Enable"})
    local ret = 0
    if nil ~= pppCon then
        for k,v in pairs(pppCon) do
            if nil ~= v["X_AutoFlag"] then
                if utils.toboolean(v["X_AutoFlag"]) and (1 == v["Enable"]) then
                    ret = utils.IsPppInternetWanPath(dailtype, k)
                    if 1 == ret then						
                        local errcode = update(k)
                        print("dmz set to pppCon ok", k, errcode)
                        utils.xmlappenderror(errcode)
                    end
                end
            end
        end
    else
        print("can't find wanpath")
    end
end

setWANPPPdmz("UMTS")
setWANIPdmz("UMTS")

setWANPPPdmz("WIFI")
setWANIPdmz("WIFI")

setWANPPPdmz("Ethernet")
setWANIPdmz("Ethernet")
