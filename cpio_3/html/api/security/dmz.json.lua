require('dm')
require('json')
require('utils')
require('sys')

--目前所有产品上行都包含umts,这里仅遍历umts是否配置了dmz
function getWANPPPdmz(dailtype)
    local errcode,pppCon = dm.GetParameterValues("InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}.", { "X_AutoFlag","Enable"})
    local ret = 0
    if nil ~= pppCon then
        for k,v in pairs(pppCon) do
            if nil ~= v["X_AutoFlag"] then
                if utils.toboolean(v["X_AutoFlag"]) and (1==v["Enable"]) then
                    print("ppp",k,v["Enable"])
                    ret = utils.IsPppInternetWanPath(dailtype, k)
                    if 1 == ret then
                        print("dmz get pppCon ", k)
                        return k
                    end
                end
            end
        end
    else
        print("can't find wanpath")
        return 0
    end
end

local ipdomain = getWANPPPdmz("UMTS")

--只有umts wan没有使能的时候才会走到这里,目前所有产品形态都不应该走到这里
if 0 == ipdomain then
    utils.xmlappenderror(9003)
end

local errcode,ipCon = dm.GetParameterValues(ipdomain.."X_DMZ.", 
     {"DMZEnable", "DMZHostIPAddress"});

local DMZconf = ipCon[ipdomain.."X_DMZ."]

local DMZInfo = {}
DMZInfo.DmzStatus = DMZconf["DMZEnable"]
DMZInfo.DmzIPAddress = DMZconf["DMZHostIPAddress"]
sys.print(json.xmlencode(DMZInfo))
